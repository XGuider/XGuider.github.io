---
layout: "post"
title: "Kafka相关命令"
subtitle: "大数据 / 实时计算"
date: "2025-05-23 10:19:24"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - 实时计算
categories:
    - 大数据
---

{% raw %}
> 来源：`本机相关/03-大数据/01-实时计算/Kafka相关命令.md`

检查Topic和分区状态
bin/kafka-topics.sh --describe --topic <your_topic> --bootstrap-server <broker_host:port>
检查Broker状态
bin/kafka-broker-api-versions.sh --bootstrap-server <broker_host:port>
检查Zookeeper状态
bin/zookeeper-shell.sh <zookeeper_host:port> ls /

bin/kafka-reassign-partitions.sh --zookeeper <zookeeper_host:port> --reassignment-json-file reassign.json --execute
手动触发Leader选举
{
  "version": 1,
  "partitions": [
    {
      "topic": "<your_topic>",
      "partition": <partition_id>,
      "replicas": [<broker_id1>, <broker_id2>, ...]
    }
  ]
}
增加副本
bin/kafka-topics.sh --alter --topic <your_topic> --partitions <num_partitions> --replication-factor <num_replicas> --bootstrap-server <broker_host:port>
检查ISR列表
bin/kafka-topics.sh --describe --topic <your_topic> --bootstrap-server <broker_host:port>

重启Kafka Broker
sudo systemctl restart kafka

查看topic情况：
/kafka-topic.sh --bootstrap-server <broker_host:port> --describe --topic 'topic'
查看堆积情况
/kafka-consumer-groups.sh --bootstrap-server <broker_host:port> --describe --group 'topic'
{% endraw %}
