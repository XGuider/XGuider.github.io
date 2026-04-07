---
layout: "post"
title: "kafka消费者的几种消费方式"
subtitle: "大数据 / 实时计算 / Kafka"
date: "2025-05-23 10:40:52"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - 实时计算
    - Kafka
categories:
    - 大数据
---

{% raw %}
> 来源：`本机相关/03-大数据/01-实时计算/Kafka/kafka消费者的几种消费方式.md`

一、消息分批消费
Properties props = new Properties();
props.put("fetch.min.bytes", 1024);      // 等待至少 1KB 数据
props.put("max.poll.records", 200);      // 每次最多拉取 200 条
props.put("max.partition.fetch.bytes", 1048576); // 每个分区最多 1MB

KafkaConsumer<String, String> consumer = new KafkaConsumer<>(props);
consumer.subscribe(Collections.singletonList("topic"));

while (true) {
    ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(100));
    if (!records.isEmpty()) {
        // 批量处理逻辑（如写入数据库或批量计算）
        processBatch(records);
    }
}

// 示例：批量写入数据库或发送到外部服务
void processBatch(ConsumerRecords<String, String> records) {
    List<Data> batchData = new ArrayList<>();
    for (ConsumerRecord<String, String> record : records) {
        Data data = parseRecord(record); // 解析单条消息
        batchData.add(data);
    }
    database.batchInsert(batchData); // 批量插入数据库（减少I/O次数）
    // 或调用外部 API 批量发送（如 HTTP 批量接口）
}

二、分时间段消费按固定时间窗口（如每隔 5 分钟）处理累积的消息，适用于延迟不敏感的场景
ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
scheduler.scheduleAtFixedRate(() -> {
    ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(100));
    if (!records.isEmpty()) {
        processBatch(records); // 定时处理
    }
}, 0, 5, TimeUnit.MINUTES); // 每 5 分钟执行一次




三、实时消费
Properties props = new Properties();
props.put("fetch.min.bytes", 1);         // 有数据就拉取
props.put("fetch.max.wait.ms", 10);      // 最多等待 10ms

KafkaConsumer<String, String> consumer = new KafkaConsumer<>(props);
consumer.subscribe(Collections.singletonList("topic"));

while (true) {
    ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(10));
    for (ConsumerRecord<String, String> record : records) {
        processSingle(record); // 实时逐条处理
    }
}

// 示例：实时处理单条消息
void processSingle(ConsumerRecord<String, String> record) {
    String message = record.value();
    if (isFraud(message)) {  // 实时风控检测
        alertSystem.triggerAlert(message); // 立即触发告警
    }
    // 或逐条写入数据库（如 Elasticsearch 实时索引）
    database.insert(parseRecord(record));
}
{% endraw %}
