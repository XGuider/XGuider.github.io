---
layout: "post"
title: "Spark内存配置"
subtitle: "大数据 / 调整优化"
date: "2026-01-22 21:31:00"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - 调整优化
categories:
    - 大数据
---

{% raw %}
> 来源：`本机相关/03-大数据/08-调整优化/Spark内存配置.md`

动态资源分配（Dynamic Allocation）是 Spark 的一项强大功能，能根据任务负载自动 增加或释放 Executor。

如果你的作业满足以下任一条件，建议关闭动态分配：
1、运行时间 < 2 分钟
2、存在大量 Shuffle 或 Broadcast 操作，有复杂 shuffle 且未启用 spark.shuffle.service.enabled=true
3、对延迟敏感（SLA 严格）
4、使用了 Executor 本地状态（连接池、缓存等）
5、在资源紧张的共享集群运行
6、正在调试或做性能 benchmark



YARN Container Total Memory----内存模型（YARN 容器总内存）
│
├── JVM Heap Memory          ← spark.executor.memory
├── Off-heap Memory          ← spark.memory.offHeap.size
├── Memory Overhead          ← spark.executor.memoryOverhead 高 Shuffle / Broadcast	executor.memory * 0.3 ~ 0.4
│    ├── Metaspace, Thread stacks
│    ├── Direct Buffers (Netty, Shuffle)
│    └── Native Libraries
└── External Shuffle Service ← **独立进程，不占用 Executor 内存！**



默认情况下，Shuffle 数据由 Executor 自己管理。一旦 Executor 退出（如动态分配释放、OOM 被 kill），其他任务就无法读取它的 Shuffle 数据 → 报错 FetchFailedException: Connection reset by peer


# 必须启用 ESS（YARN 模式）
--conf spark.shuffle.service.enabled=true
# 合理分配堆内存
--conf spark.executor.memory=20g
# 通常建议关闭 Off-heap（除非明确需要）
--conf spark.memory.offHeap.enabled=false
# 关键！设置足够 memoryOverhead（至少 20% of executor.memory）
--conf spark.executor.memoryOverhead=6144  # 6GB
# 优化 Shuffle
--conf spark.sql.adaptive.enabled=true
--conf spark.sql.adaptive.coalescePartitions.enabled=true
--conf spark.dynamicAllocation.minExecutors=2 \
--conf spark.dynamicAllocation.maxExecutors=50 \
--conf spark.dynamicAllocation.initialExecutors=5 \
--conf spark.dynamicAllocation.executorIdleTimeout=60s
# 延长Executor空闲超时时间（避免过早释放）
--conf spark.dynamicAllocation.executorIdleTimeout=300s
# 降低动态分配的频率
--conf spark.dynamicAllocation.sustainedSchedulerBacklogTimeout=5s
--conf spark.sql.shuffle.partitions=2000


1、Driver调整
set spark.driver.cores=2;
spark.driver.memory=4g;
2、Executor配置
spark.executor.instances=100;
spark.executor.cores=2;
spark.executor.memory=4g;
spark.executor.memoryOverhead=5g
spark.memory.offHeap.enabled=true;
spark.memory.offHeap.size=4g;
spark.memory.fraction=0.75;  -- 统一内存占比
spark.memory.storageFraction=0.4 -- storage内存占比
3、Shuffle设置
set spark.sql.shuffle.partitions=600;  -- task/core 的3倍
set spark.sql.adaptive.enabled=true;  -- 是否开启分区调整功能
set spark.sql.adaptive.shuffle.targetPostShuffleInputSize=128m;  -- Shuffle Reducer读取的数据量
set spark.shuffle.io.maxRetries=10;  
set spark.shuffle.io.retryWait=120s;   
4、其他设置
set spark.sql.adaptiveBroadcastJoinThreshold=10m;  -- 自动广播join阈值
set spark.network.timeout=600s;    -- 增大Executor心跳时间
set spark.executor.heartbeatInterval=300s;  -- 心跳发送时间间隔
set spark.sql.broadcastTimeout=300s;
set spark.files.fetchTimeout=300s;
set spark.serializer=org.apache.spark.serializer.KryoSerializer;



常见问题：

1、Executor丢失
产生原因：资源不足导致Executor心跳超时，Driver就判定其丢失，就去连其他的executor，但其他的因为配置都一样，所以也连不上。重试多次之后，就会报错失败
常见报错： org.apache.spark.shuffle.FetchFailedException: The relative remote executor(Id: xxx), which maintains the block data to fetch is dead.
处理措施：增大spark.network.timeout，从而允许有更多时间去等待心跳响应

1、Driver端OOM
产生原因：Driver端主要职责是任务调度，以及需要拉取结果集到Driver端的操作，比如广播变量。广播变量在创建的过程中，需要先把分布在所有Executor的数据分片拉取到Drive 端，然后在Driver端构建广播变量，最后Driver端把封装好的广播变量再分发给各个Executor。当广播变量超过Driver端内存上限，会报OOM。
常见报错：java.lang.OutOfMemoryError: Not enough memory to build and broadcast
处理措施： 评估广播变量大小，调整Driver端内存spark.driver.memory


2、Executor端Other内存溢出
产生原因：Other内存主要用于存储用户自定义数据结构和表Schema信息，这些数据结构的总大小超出了Other内存区域的上限，会报OOM。
常见报错：java.lang.OutOfMemoryError: Java heap space at java.util.xxx
处理措施：调整Other内存大小，Other内存 = spark.executor.memory * （ 1 - spark.memory.fraction）


3、Executor端Execution内存溢出
产生原因：Execution内存主要保存Shuffle中间结果，大部分OOM是这部分导致
常见报错1：java.lang.OutOfMemoryError
常见报错2：ExecutorLostFailure
常见报错3：FetchFailedException
常见报错4：shuffle file lost
常见报错5：executor exit code is 143
处理措施：Execution内存不足，首先排查是否发生数据倾斜。调整资源配比：增大Execution内存、增大Shuffle并行度、打散数据
{% endraw %}
