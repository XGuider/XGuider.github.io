---
layout: "post"
title: "Doris和Clickhouse"
subtitle: "Java开发 / 数据库"
date: "2025-03-13 09:47:19"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - 数据库
categories:
    - Java开发
---

> 来源：`本机相关/02-Java开发/03-数据库/Doris和Clickhouse.md`

多种产品下如何判别择优？

1、有的用Doris、有的用Ck，还有的用StarRocks
2、是什么因素导致不同使用不同的数据存储服务呢
3、这些因素是否存在集大乘者

三者主要的区别以及场景
技术		ClickHouse	Doris	StarRocks
列式存储		是		是			是
向量化查询	是		是（2.0 后优化）	是
CBO 优化器	无		无			是
多表关联性能	弱		中			强
实时更新	批量导入为主	支持 Upsert	支持 Upsert
适用场景	单表聚合、日志分析	企业级 BI、报表系统	实时分析、复杂查询


为什么 ClickHouse 单表性能好？
列式存储：只读取查询所需的列，减少 I/O 操作，特别适合聚合查询。
向量化查询：利用 SIMD 指令集批量处理数据，提升 CPU 利用率，加快计算速度。
数据预聚合：支持物化视图和预计算，将复杂查询结果预先计算并存储，查询时直接读取结果。
稀疏索引：通过主键索引、跳数索引和数据分区快速定位数据块，减少扫描范围。
LSM Tree 存储结构：写优化数据结构，适合高吞吐写入，通过后台合并操作优化读取性能。

CREATE TABLE [IF NOT EXISTS] [db.]table_name [ON CLUSTER cluster]
(
    name1 [type1] [DEFAULT|MATERIALIZED|ALIAS expr1],
    name2 [type2] [DEFAULT|MATERIALIZED|ALIAS expr2],
    ...
) ENGINE = Distributed(cluster, database, table[, sharding_key[, policy_name]])
[SETTINGS name=value, ...]

sharding_key为分片键， 一般为uuid的


特性			ClickHouse			StarRocks
列式存储		是，压缩效率高			是，压缩效率稍低
向量化引擎	是，SIMD 指令集优化	是，SIMD 指令集优化
数据预聚合	支持 SummingMergeTree、AggregatingMergeTree	支持物化视图，但预聚合机制不如 ClickHouse
索引优化		稀疏索引（主键、跳数索引）	全局索引，适合多表关联
存储结构		LSM Tree，写优化		列式存储，读写均衡
设计哲学		宽表模型，单表查询优先	多表关联优先，分布式优化


稀疏索引-稀疏索引的核心思想是跳过不相关的数据块：
	数据排序：数据按主键或排序键排序，存储在多个数据块（Parts）中。
	构建索引：为每个数据块记录起始键值（如每 8192 行记录一次），形成稀疏索引。
	查询优化：查询时，通过比较查询条件与稀疏索引中的键值，跳过不匹配的数据块，只扫描可能包含目标数据的块

LSM Tree 是一种写优化的数据结构，通过顺序写入和后台合并（Compaction）来提升写入性能。它分为内存中的 MemTable 和磁盘上的 SSTable 两层：
	MemTable：新数据首先写入内存中的 MemTable。
	SSTable：当 MemTable 写满后，数据被刷新到磁盘，形成有序的 SSTable 文件。
	Compaction：后台定期合并 SSTable 文件，去除重复数据，优化读取性能
	写入流程：
		新数据写入 MemTable 和 WAL（Write-Ahead Log，用于故障恢复）。
		当 MemTable 写满后，转换为 Immutable MemTable，并刷新到磁盘生成 SSTable。
		后台线程定期合并 SSTable 文件，生成新的有序文件 
	读取流程：
		首先查询 MemTable。
		如果未找到，则从最新的 SSTable 开始逐层查询，直到找到目标数据

数据预聚合
	ClickHouse 支持在写入阶段对数据进行预聚合，以加速后续查询。主要通过以下表引擎实现：
		SummingMergeTree：将相同主键的数据按指定列求和，减少存储空间并加快聚合查询 
		AggregatingMergeTree：支持更复杂的聚合逻辑，允许定义任意聚合函数


SHOW CATALOGS;
-- 示例输出：
-- | internal | hms   | jdbc_mysql | ...
