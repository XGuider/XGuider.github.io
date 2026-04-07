---
layout: "post"
title: "Hadoop"
subtitle: "系统与运维 / 未知分类"
date: "2023-05-21 20:05:14"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - 未知分类
categories:
    - 系统与运维
---

{% raw %}
> 来源：`本机相关/06-系统与运维/04-未知分类/Hadoop.md`

（1）bin 目录：存放对 Hadoop 相关服务（hdfs，yarn，mapred）进行操作的脚本
（2）etc 目录：Hadoop 的配置文件目录，存放 Hadoop 的配置文件
（3）lib 目录：存放 Hadoop 的本地库（对数据进行压缩解压缩功能）
（4）sbin 目录：存放启动或停止 Hadoop 相关服务的脚本
（5）share 目录：存放 Hadoop 的依赖 jar 包、文档、和官方案例


要获取的默认文件 文件存放在 Hadoop 的 jar 包中的位置
[core-default.xml] hadoop-common-3.1.3.jar/core-default.xml
[hdfs-default.xml] hadoop-hdfs-3.1.3.jar/hdfs-default.xml
[yarn-default.xml] hadoop-yarn-common-3.1.3.jar/yarn-default.xml
[mapred-default.xml] hadoop-mapreduce-client-core-3.1.3.jar/mapred-default.xml


端口名称 	Hadoop2.x 	Hadoop3.x
NameNode内部通信端口 8020/9000 8020/9000/9820
NameNodeHTTPUI		 50070 		9870
MapReduce查看执行任务端口 8088 	8088
历史服务器通信端口 		19888 19888


<configuration>
<!-- 指定 MapReduce 程序运行在 Yarn 上 -->
	<property>
		 <name>yarn.app.mapreduce.am.env</name>
		<value>HADOOP_MAPRED_HOME=/opt/module/hadoop-3.2.0</value>
	</property>
	<property>
		<name>mapreduce.map.env</name>
		<value>HADOOP_MAPRED_HOME=/opt/module/hadoop-3.2.0</value>
	</property>
	<property>
		<name>mapreduce.reduce.env</name>
		<value>HADOOP_MAPRED_HOME=/opt/module/hadoop-3.2.0</value>
	</property>
	<property>
	    <name>mapreduce.framework.name</name>
	    <value>yarn</value>
	</property>

	<property>
		 <name>mapreduce.jobhistory.address</name>
		 <value>hadoop102:10020</value>
	</property>
	<!-- 历史服务器 web 端地址 -->
	<property>
		 <name>mapreduce.jobhistory.webapp.address</name>
		 <value>hadoop102:19888</value>
	</property>
</configuration>
{% endraw %}
