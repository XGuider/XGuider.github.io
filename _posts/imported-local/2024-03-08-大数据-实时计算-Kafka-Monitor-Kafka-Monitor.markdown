---
layout: "post"
title: "Kafka Monitor"
subtitle: "大数据 / 实时计算"
date: "2024-03-08 15:36:21"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - 实时计算
categories:
    - 大数据
---

> 来源：`本机相关/03-大数据/01-实时计算/Kafka Monitor.md`

1. Broker级别指标
kafka.server:type=BrokerTopicMetrics,name=MessagesInPerSec
描述：每秒接收的消息数量。
kafka.server:type=BrokerTopicMetrics,name=BytesInPerSec
描述：每秒接收的字节数。
kafka.server:type=BrokerTopicMetrics,name=BytesOutPerSec
描述：每秒发送的字节数。
kafka.network:type=RequestMetrics,name=RequestsPerSec,request={Produce|FetchConsumer|FetchFollower}
描述：生产者请求、消费者请求和从属副本请求的处理速率。

2. Topic级别指标
对于特定的Topic，指标的命名规则是在指标名称后加上,topic=<topicName>。
kafka.server:type=BrokerTopicMetrics,name=BytesInPerSec,topic=<topicName>
描述：特定Topic每秒接收的字节数。
kafka.server:type=BrokerTopicMetrics,name=BytesOutPerSec,topic=<topicName>
描述：特定Topic每秒发送的字节数。
kafka.server:type=BrokerTopicMetrics,name=MessagesInPerSec,topic=<topicName>
描述：特定Topic每秒接收的消息数量。


3. Consumer Group级别指标
kafka.coordinator.group:type=GroupMetrics,name=NumOffsets
描述：管理的offset数量。
kafka.coordinator.group:type=GroupCoordinatorMetrics,name=HeartbeatRate
描述：消费者心跳的处理率。
kafka.consumer:type=consumer-fetch-manager-metrics,client-id=<clientId>
描述：消费者客户端的各种抓取指标。

4. JVM指标
java.lang:type=Memory
描述：JVM内存使用情况，包括堆内存和非堆内存。
java.lang:type=GarbageCollector,name=*
描述：垃圾回收器的性能指标，如回收次数和回收时间。
