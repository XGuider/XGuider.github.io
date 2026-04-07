---
layout: "post"
title: "HDFS与Spark技术问题"
subtitle: "大数据 / 离线计算"
date: "2026-03-30 21:05:34"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - 离线计算
categories:
    - 大数据
---

> 来源：`本机相关/03-大数据/02-离线计算/HDFS与Spark技术问题.md`

HDFS：
1.HDFS读写流程
简版：HDFS读写流程是指客户端向HDFS发送读写请求，NameNode接收请求并返回数据块所在DataNode的信息，客户端再向该DataNode发送读写请求，DataNode进行读写操作并返回结果给客户端。
详细：
HDFS（Hadoop分布式文件系统）是Hadoop的核心组件之一，它是一个可扩展的分布式文件系统，用于存储和处理大规模数据集。下面是HDFS的读写流程：

一、写入流程
当一个客户端想要向HDFS写入数据时，它首先需要与NameNode建立联系，请求一个文件名和一些关于文件的元数据信息，比如文件大小和数据块的数量等。如果文件名可用，NameNode会向客户端返回这些元数据信息以及一组DataNode的列表。客户端收到元数据信息和DataNode的列表后，它会按照块大小将文件划分成多个数据块，并按照指定的副本数将数据块复制到DataNode上。客户端首先将数据块的第一份副本写入它所选择的DataNode，然后将其他的副本写入剩下的DataNode上。

二、读取流程
当一个客户端想要从HDFS读取数据时，它需要首先向NameNode发出一个请求，请求指定文件的位置和元数据信息。NameNode向客户端返回文件的元数据信息和一组DataNode的列表，这些DataNode包含了文件的数据块。客户端收到元数据信息和DataNode列表后，它会选择最近的DataNode作为主DataNode，并通过网络连接读取该DataNode上的数据块。如果该DataNode上的数据块无法访问，客户端可以选择备用DataNode进行读取。


2.HDFS 高可用
简版：HDFS 高可用是指在 Hadoop 分布式文件系统中，通过配置 NameNode 和 DataNode 的集群，实现在主节点故障时自动切换到备用节点，保证系统的高可用性。
详细：
NameNode是HDFS的关键组件之一，负责管理文件系统的命名空间和数据块映射表。在HDFS中，如果NameNode发生故障，则整个文件系统将不可用。为了保证NameNode的高可用性，HDFS使用了两种机制：备份和故障切换。
	备份：HDFS中有两个NameNode，一个是主NameNode，另一个是备用NameNode。主NameNode负责处理客户端请求，备用NameNode监控主NameNode的状态，以确保它始终处于运行状态。如果主NameNode发生故障，备用NameNode会立即接管它的职责，从而保证文件系统的高可用性。
	故障切换：HDFS中的故障切换指的是在主NameNode失效时，如何将备用NameNode提升为新的主NameNode。为了实现这一点，备用NameNode需要与主NameNode保持同步，以便在发生故障时能够接管主NameNode的所有职责。在进行故障切换时，备用NameNode会自动接管主NameNode的职责，并向客户端提供服务。
数据块的复制和分布存储：HDFS通过将数据块复制到多个DataNode上来实现高可用性。当客户端写入数据时，HDFS会将数据块复制到多个DataNode上，并将这些DataNode分布在不同的机架上，以确保系统的高可用性和容错性。这样，即使某个DataNode发生故障，数据仍然可以从其他DataNode上恢复。
快速失败：HDFS采用了快速失败机制，可以快速检测到故障并采取措施，以确保数据的可靠性和高可用性。例如，如果客户端请求一个DataNode，但该DataNode未响应，则客户端会立即寻找另一个DataNode，以确保数据能够及时地传输和复制。
总之，HDFS通过备份和故障切换机制、数据块的复制和分布存储、以及快速失败机制等措施，确保了系统的高可用性和容错性。

3.小文件危害(两个方面：存储、计算(mr、spark))
https://zhuanlan.zhihu.com/p/387760165#%E6%A6%82%E8%A7%88
mr：Hadoop 中小文件危害指的是在使用Hadoop时，由于小文件数量过多，导致NameNode存储元数据的内存消耗大，从而影响整个Hadoop集群的性能。
小文件通常指的是文件大小小于HDFS块大小（默认为128MB）的文件。这些小文件会对HDFS和MapReduce作业产生一些危害：
	内存占用：每个小文件都需要一个单独的文件描述符，HDFS的NameNode将这些文件描述符存储在内存中，因此大量小文件会导致NameNode的内存占用增加。当NameNode的内存用尽时，可能会导致整个HDFS集群崩溃。
	块的利用率：在HDFS中，文件会被分割成数据块并存储在不同的DataNode上。小文件可能无法占满整个块，因此可能会浪费存储空间。
MapReduce性能：MapReduce作业通常需要将数据块加载到内存中进行处理，而大量小文件会导致MapReduce作业中出现大量小数据块，从而降低了作业的整体性能。

Hadoop中如何避免产生大量的小文件？

产生大量小文件的原因是在Hadoop分布式文件系统（HDFS）中，如果一个文件的大小小于一个数据块的大小，那么这个文件将被存储为一个数据块，这样就会在HDFS中产生大量的小文件。为了避免产生大量的小文件，可以采用以下几种方法：
合并小文件：将多个小文件合并成一个大文件，可以有效地减少小文件的数量，降低存储开销。在Hadoop中，可以使用Hadoop归档（HAR）将多个小文件合并成一个大文件。
压缩文件：对于一些文本文件，可以使用压缩算法将其压缩成一个文件，从而减少存储开销和小文件的数量。在Hadoop中，可以使用Gzip或Snappy等压缩算法对文件进行压缩。
提高块大小：通过提高数据块的大小，可以减少小文件的数量，并提高HDFS的存储效率。在Hadoop中，默认的块大小为128MB，可以根据实际情况调整块的大小。
使用SequenceFile：SequenceFile是一种Hadoop提供的二进制文件格式，可以将多个小文件合并成一个文件。在Hadoop中，可以使用SequenceFile将多个小文件合并成一个大文件。
使用MapReduce处理小文件：使用MapReduce处理小文件可以将小文件合并成大文件，从而降低小文件的数量。在MapReduce作业中，可以将多个小文件作为输入，然后使用Reduce函数将它们合并成一个大文件。


Spark任务产生小文件
Spark生成的文件数量直接取决于RDD里partition的数量和表分区数量。注意这里的两个分区概念并不相同，RDD的分区与任务并行度相关，而表分区则是Hive的分区数目。生成的文件数目一般是RDD分区数和表分区的乘积。因此，当任务并行度过高或者分区数目很大时，很容易产生很多的小文件。

小文件出现的原因？

1、启用了动态分区，往动态分区表插入数据时，会插入大量小文件
2、reduce的数量设置的较多，到reduce处理时，会分配到不同的reduce中，会产生大量的小文件
3、源数据文件就存在大量的小文件

MR：
1.MR 流程8步
Map阶段:
	第一步: 通过FileInputFormat读取文件, 解析文件成为key, value对, 输出到第二步.
	第二步: 自定义Map逻辑, 处理key1, value1, 将其转换为key2, value2, 输出到第三步.
Shuffle阶段:
	第三步: 对key2, value2进行分区.
	第四步: 对不同分区内的数据按照相同的key进行排序.
	第五步: 分组后的数据进行规约(combine操作)，降低数据的网络拷贝（可选步骤）
	第六步: 对排序后的数据, 将相同的key的value数据放入一个集合中, 作为value2.
Reduce阶段:
	第七步: 对多个map的任务进行合并, 排序. 自定义reduce逻辑, 处理key2, value2, 将其转换为key3, value3, 进行输出.
	第八步: 通过FileOutputFormat输出处理后的数据, 保存到文件.

输入数据的分片（Input Splits）
输入数据会被分成多个大小相等的块，这些块称为输入数据分片（Input Splits），每个分片都会被分配给一个Map任务进行处理。

Map任务（Map Tasks）
Map任务是将输入数据分片（Input Splits）转换为键值对的过程。Map任务接受输入数据分片作为输入，输出键值对作为中间结果。
Map输出（Map Output）
Map任务的输出会被收集并进行排序和分组。这个过程产生的输出称为Map输出（Map Output）。
Combiner
Combiner是一个可选步骤，可以在Map输出进行合并和压缩，以减少网络传输的数据量。
Shuffle
Shuffle是将Map输出按照键进行分组的过程。Shuffle过程将Map任务的输出按照键进行排序，将相同键的值分组并发送到Reducer任务中进行处理。
Reduce任务（Reduce Tasks）
Reduce任务是对Shuffle过程产生的数据进行处理的过程。Reduce任务接受Shuffle输出作为输入，输出最终的结果。
输出数据的合并（Output Merge）
Reduce任务的输出会被分成多个输出数据分片（Output Splits），这些分片会被按照键排序和合并，最终输出到输出目录中。
输出数据的复制（Output Replication）
输出数据的复制是为了提高数据的可靠性，保证数据不会因为节点故障或网络故障而丢失。输出数据会被复制到多个节点上进行存储。

2.MR shuffle过程及调优

YARN:
1.yarn工作流程

spark:
1.MR vs spark (spark为什么快)
2.MR shuffle 与 spark shuffle区别
3.宽窄依赖，job stage task怎么切分
4.executor内存
5.数据倾斜（主要两方面 join产生的、group by产生的）
6.repartition 与 cocalese区别
7.yarn-client与yarn-cluster区别
8.cache checkpoint区别
9.RDD DF DS区别
10.算子调优

hive：
1.内部表 外部表区别
2.order by、sort by、dist by、cluster by区别
3.怎么设计表分区


Doris：
1.3个数据模型
2.上卷与物化视图是什么，有什么区别

数仓：
1.什么是ER模型
2.什么是维度模型（星型、雪花型、星座型）
3.维度表建设过程（4步：选择业务过程-->声明粒度-->确认维度-->确认事实）
4.onedate建设过程（6步）
5.数仓数据的一致性如何保证（每次都问到）
