---
layout: "post"
title: "Flink中SQL使用"
subtitle: "大数据 / 实时计算 / Flink实时数据仓库"
date: "2025-03-13 15:37:01"
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
> 来源：`本机相关/03-大数据/01-实时计算/Flink实时数据仓库/Flink中SQL使用.md`

CREATE TABLE topic_db (
  `database` string,
  `table` string,
  `type` string,
  `ts` bigint,
  `data` MAP<string, string>,
  `old` MAP<string, string>,
  pt as proctime(),
  et as to_timestamp_ltz(ts, 0),
  watermark for et as et - interval '3' second
) WITH (
  'connector' = 'kafka',
  'topic' = 'my_topic',
  'properties.bootstrap.servers' = 'hadoop102:9092',
  'properties.group.id' = 'my_group',
  'scan.startup.mode' = 'latest-offset',
  'format' = 'json'
);

1、该表用于从 Kafka 主题消费 JSON 格式的消息。
2、watermark 策略支持事件时间处理，水位线比事件时间延迟 3 秒。
3、pt 和 et 是计算字段，分别表示处理时间和事件时间。

Kafka 连接器属性：
connector: 指定连接器类型为 kafka。
topic: 指定 Kafka 主题名称，动态传入 topic 变量。
properties.bootstrap.servers: 指定 Kafka 的 broker 地址（hadoop102:9092）。
properties.group.id: 指定 Kafka 消费者组 ID，动态传入 groupId 变量。
scan.startup.mode: 指定启动模式为 latest-offset，表示从最新的偏移量开始消费。
format: 指定数据格式为 json
{% endraw %}
