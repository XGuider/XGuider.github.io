---
layout: "post"
title: "Kafka本地环境"
subtitle: "大数据 / 实时计算"
date: "2026-01-13 10:08:22"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - 实时计算
categories:
    - 大数据
---

{% raw %}
> 来源：`本机相关/03-大数据/01-实时计算/Kafka本地环境.md`

brew安装软件后，
1，配置文件在/opt/homebrew/etc中
2，安装文件在/opt/homebrew/Cellar中
3，二进制可执行程序的软连接在/opt/homebrew/bin中

brew deps 可以查看依赖关系；
	--tree 参数以树状显示依赖关系
brew deps --tree kafka 

Zookeeper环境配置
cp /opt/homebrew/Cellar/zookeeper/3.9.1/share/zookeeper/examples/zoo_sample.cfg /opt/homebrew/etc/zookeeper/zoo.cfg
修改zoo.cfg
dataDir=/opt/homebrew/var/run/zookeeper/data
dataLogDir=/opt/homebrew/var/log/zookeeper/zookeeper.log


Kafka环境配置
vi /opt/homebrew/etc/kafka/server.properties
修改erver.properties
broker.id=0
zookeeper.connect=localhost:2181
log.dirs=/opt/homebrew/var/lib/kafka-logs


启动 zookeeper
brew services list: 服务list

启动服务
	在装有 homebrew 的 Mac OS 下，有两种方式启动服务：
	执行 brew services start zookeeper 以服务的方式启动 zookeeper
	执行zkServer start临时启动 zookeeper
查看服务
	brew services info zookeeper查看服务运行状态

启动 kafka
	启动服务
	brew services restart kafka
	brew services start kafka
	brew services stop kafka以服务的方式启动 kafka
	export JMX_PORT=9999
	kafka-server-start /opt/homebrew/etc/kafka/server.properties
查看服务
	brew services info kafka

启动消费客户端
kafka-console-consumer --bootstrap-server localhost:9092 --topic student --from-beginning
#查看消费组 list
kafka-consumer-groups --bootstrap-server localhost:9092 --list
kafka-consumer-groups --bootstrap-server localhost:9092 --group testGrroup --describe
kafka-consumer-groups --bootstrap-server localhost:9092 --describe --all-topics

启动生产者客户端
kafka-console-producer --broker-list 127.0.0.1:9092 --topic test


# 创建topic
bin/kafka-topics.sh --create --topic ods_base_log --bootstrap-server localhost:9092
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic ods_base_log





kafka中的同一条消息，只能被同一个消费者组下的某一个消费者消费。而不属于同一个消费者组的其他消费者，也可以消费到这一条消息
#两个消费者实例属于同一个消费者组
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --consumer-property group.id=testGrroup --topic test
kafka-console-consumer --bootstrap-server localhost:9092 --consumer-property group.id=testGrroup --topic student --from-beginning
kafka-console-consumer --bootstrap-server localhost:9092 --consumer-property group.id=testGrroup --topic student
#这个消费者实例属于不同的消费者组
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --consumer-property group.id=testGrroup2 --topic test

查看patition的数据：
/opt/homebrew/var/lib/kafka-logs

#创建Topic
bin/kafka-topics.sh --create --topic ods_base_log --bootstrap-server localhost:9092
#查看Topic
bin/kafka-topics.sh --describe --topic student --bootstrap-server localhost:9092
#查看Topic list
kafka-topics --bootstrap-server localhost:9092 --list


nc -lk 7777：实时发送数据
服务器端命令：nc -l ip地址 端口号 > 接收的文件名
客户端命令：nc ip地址 端口号 < 发送的文件名


nc -zv -w 1 127.0.0.1 8080：nc (Netcat) 向某个端口发送模拟请求有多种方式





Kafka Broker配置JMX

export KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9999 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"
-Dcom.sun.management.jmxremote: 启用JMX远程管理。
-Dcom.sun.management.jmxremote.port=9999: 设置JMX远程连接端口为9999。
-Dcom.sun.management.jmxremote.authenticate=false: 关闭JMX远程连接的认证机制。
-Dcom.sun.management.jmxremote.ssl=false: 关闭JMX远程连接的SSL。

server.properties 文件中：
log.retention.hours = 168 ，这个属性代表消息保留时间为多少小时。默认为168小时


netstat -an | grep 9999 查看端口是否被使用
lsof -i :9999
{% endraw %}
