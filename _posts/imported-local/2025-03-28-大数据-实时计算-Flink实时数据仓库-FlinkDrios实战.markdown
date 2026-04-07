---
layout: "post"
title: "Flink+Drios实战"
subtitle: "大数据 / 实时计算 / Flink实时数据仓库"
date: "2025-03-28 09:41:38"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - 实时计算
    - Flink实时数据仓库
categories:
    - 大数据
---

{% raw %}
> 来源：`本机相关/03-大数据/01-实时计算/Flink实时数据仓库/Flink+Drios实战.md`

(1) Flink 写入 Doris 的三种方式
// 示例：Flink SQL 写入 Doris（需 doris-flink-connector）
CREATE TABLE doris_sink (
    user_id STRING,
    event_time TIMESTAMP,
    pv BIGINT
) WITH (
    'connector' = 'doris',
    'fenodes' = 'doris-fe:8030',
    'table.identifier' = 'db.table',
    'username' = 'user',
    'password' = 'pass',
    'sink.batch.size' = '1000',  // 批次大小
    'sink.max-retries' = '3'     // 重试次数
);

INSERT INTO doris_sink 
SELECT user_id, event_time, COUNT(*) as pv 
FROM kafka_source 
GROUP BY user_id, TUMBLE(event_time, INTERVAL '1' MINUTE);

方式 2：通过 StreamLoad API
// 在 Flink 的 ProcessFunction 中调用 Doris 的 HTTP StreamLoad
public void processElement(Event event, Context ctx, Collector<O> out) {
    String loadUrl = "http://doris-fe:8030/api/db/table/_stream_load";
    HttpClient.post(loadUrl)
        .header("Authorization", "Basic " + base64Auth)
        .body(JsonUtils.toJson(event))
        .execute();
}

方式 3：写入 Kafka + Routine Load

-- Doris 侧创建 Routine Load 任务
CREATE ROUTINE LOAD db.job ON table
FROM KAFKA (
    "kafka_broker_list" = "kafka:9092",
    "kafka_topic" = "doris_topic"
)
WITH PROPERTIES (
    "desired_concurrent_number" = "3"
);

(3) 动态分区与自动分桶
-- Doris 动态分区配置（自动按天分区）
ALTER TABLE doris_agg SET (
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.start" = "-7",
    "dynamic_partition.end" = "3"
);

问题 1：写入延迟高
原因：Flink 批次设置过小或 Doris Compaction 压力大。
解决：增大 sink.batch.size 和 sink.batch.interval。
调整 Doris 的 cumulative_compaction_min_deltas。

问题 2：OOM 错误
场景：Flink 窗口聚合数据倾斜。
解决：增加 state.backend.rocksdb.memory.managed（Flink）。
使用 DISTRIBUTED BY HASH(user_id) BUCKETS 64 分散 Doris 数据。

问题 3：数据重复
原因：Flink 未启用 Checkpoint 或 Doris 未开 2PC
-- Flink 配置
execution.checkpointing.interval: 30s
execution.checkpointing.mode: EXACTLY_ONCE

-- Doris Sink 配置
sink.enable-2pc: true
选择 Routine Load 当：
数据源为 Kafka 且需要持续导入。
希望 Doris 自动管理 消费进度和容错。
需要 低代码维护（无需额外开发导入程序）。

选择 Stream Load 当：
数据源 非 Kafka（如 MySQL CDC、Flink 实时处理后的数据）。
需要 灵活控制 导入时机（如定时触发）。
与外部系统（如 Flink）深度集成，需 端到端精确一次。

### 分区数和并行度
kafka分区数：
# 经验公式（适用于大多数场景）
目标分区数 = max(生产峰值吞吐量/单分区吞吐上限, 消费者组数量)

Flink并行度：
# 基于资源配额的计算
推荐并行度 = min(Kafka 分区数,
    TaskManager 数量 × 每个 TM 的 Slot 数,
    业务需求的最大并行能力
)

KeyBy 后的窗口聚合：并行度需与 Key 的基数匹配，避免数据倾斜。
dataStream.keyBy("user_id")  // 确保user_id分散度高
           .window(TumblingEventTimeWindows.of(Time.minutes(5)))
           .aggregate(new MyAggFunc())
           .setParallelism(32);  // 显式设置

Sink 阶段：
写入数据库时，并行度不超过目标库的连接池上限。

实战：
env.addSource(new FlinkKafkaConsumer<>(
    "orders",
    new JSONKeyValueDeserializationSchema(),
    props))
   .setParallelism(24)  // 1:1匹配分区
   .keyBy("user_id")
   .process(new FraudDetector())
   .setParallelism(48)  // 两倍于Source（计算密集）
   .addSink(new DorisSink())
   .setParallelism(12); // 受限于Doris写入能力


Flink 反压（Backpressure）
现象：Source 延迟上升，Checkpoint 超时。
解决：
增加 parallelism 或 taskmanager.memory。
优化 buffer.timeout（牺牲延迟换吞吐）



Kafka 分区不均衡
现象：部分 Flink 子任务负载过高。
解决：
使用 rebalance() 显式触发重分配。
检查 Kafka 的 partition.assignment.strategy


配置参数	推荐值	说明
taskmanager.numberOfTaskSlots	CPU 核心数 × 0.8	避免超卖导致争抢:
每个 Slot 分配 1~2 个 CPU 核

parallelism.default	Kafka 分区数 × 1.2	预留 20% 缓冲
source.task.max-concurrent-fetches	同分区数	防止 Source 瓶颈

优化链（Operator Chaining）：Flink 会自动将多个算子合并到一个 Slot 中执行（减少线程切换）
env.disableOperatorChaining();

CPU：保留至少 1核 给操作系统
内存：保留 10-20% 给系统进程
磁盘：保留 15% 空间避免HDFS写失败
{% endraw %}
