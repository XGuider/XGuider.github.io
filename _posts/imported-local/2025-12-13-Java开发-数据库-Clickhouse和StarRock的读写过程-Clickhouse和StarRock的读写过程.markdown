---
layout: "post"
title: "Clickhouse和StarRock的读写过程"
subtitle: "Java开发 / 数据库"
date: "2025-12-13 20:02:31"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - 数据库
categories:
    - Java开发
---

> 来源：`本机相关/02-Java开发/03-数据库/Clickhouse和StarRock的读写过程.md`

ClickHouse 的读写流程：
1. 接收 INSERT 请求	客户端执行 INSERT INTO table VALUES (...)
2. 分区计算	ClickHouse 根据 PARTITION BY 表达式，计算目标分区键值
| 3. 分区查找 / 创建 | - 如果该分区已存在 → 选择该分区目录（如 202406_1_1_0）- 如果是新分区 → 动态创建新分区目录（名称如 202406_2_2_0） |
| 4. 数据写入临时文件 | 数据被缓冲写入 .tmp 临时文件（不是立即落盘） |
| 5. 索引构建 | 根据 ORDER BY 构建主索引（稀疏索引），每 index_granularity=8192 行记一个索引点
同时，为新数据生成二级索引元信息（如果已定义） |
| 6. 数据合并元信息 | 生成 checksums.txt、marks.mrk3、primary.idx、idx_name.mrk3（二级索引标记）等元数据 |
| 7. 提交原子切换 | 用 mv 操作将 .tmp 文件重命名为最终 .bin、.mrk3、.idx 等文件 → 原子可见 |
| 8. 更新 system.parts 表 | ClickHouse 的元数据服务记录新加的 partition/part |




读取流程-向量化读取
查询时，ClickHouse根据索引快速定位所需数据块，跳过无关部分，显著降低 I/O 开销 
对于分布式表，协调节点会将查询任务拆解并发至各节点执行，结果汇总后再返回给用户

使用ClickHouse的分布式表查询，大体流程如下：
	集群多副本时根据负载均衡选择一个副本，也就是说副本是可以承担查询功能的
	将分布式查询语句转换为本地查询语句
	将本地查询语句发送到各个分片节点执行查询
	再将返回的结果执行合并

StarRocks 的读写流程
写入流程
StarRocks 基于 MPP 架构，采用 Shared-Nothing 模式，计算与存储分离，支持高并发写入 
数据导入：通过 Stream Load 接口或 Transactional Stream Load（版本 >= 2.4）实现高效数据加载 
写入语义：提供 At-Least-Once 和 Exactly-Once 两种模式，后者确保数据准确写入且无重复 

读取流程
查询请求由 FE（Frontend）解析生成执行计划，调度至 BE（Backend）节点并行处理 
结果经汇总后返回客户端，整个过程充分利用分布式架构优势，提供亚秒级响应

Doris 的元数据管理主要分为以下几个部分：
Frontend（FE）节点：
	FE 节点是 Doris 的元数据管理核心，负责存储和管理所有元数据，包括表结构、分区信息、副本位置等。
	FE 节点之间通过选举机制实现高可用性，主节点（Leader）负责元数据的写入和同步，从节点（Follower）负责读取和备份。
Backend（BE）节点：
	BE 节点负责实际的数据存储和查询执行，但不直接管理元数据。
	BE 节点根据 FE 节点提供的元数据信息，定位数据并进行查询或写入操作。
	元数据存储：

Doris 的元数据存储在 FE 节点的本地磁盘中，通常以文件形式保存。
为了确保高可用性，元数据会通过日志（如 BDBJE）在多个 FE 节点之间同步。 

事务处理
两阶段提交协议：在 Exactly-Once 模式下使用，分为准备阶段和提交阶段。
准备阶段：各节点将数据写入临时存储并锁定资源，确认是否可以进行提交。
提交阶段：如果所有节点都准备好，则正式提交数据；否则回滚整个事务，避免不一致状态

CBO 通过评估不同操作符的成本来选择最优路径，从而提升查询性能
工作原理
	统计信息收集： StarRocks 在数据导入时自动收集表级别的统计信息，包括行数、列分布等，为后续成本估算提供依据。
	代价模型构建： 基于收集到的统计信息，CBO 构建出一个反映各操作符运行开销的数学模型。该模型考虑了 CPU 使用率、I/O 次数和网络传输量等因素。
	执行计划生成： 当接收到 SQL 查询请求后，StarRocks 的解析器会将其转换成逻辑执行计划树。随后，CBO 对这棵树进行遍历，并根据代价模型计算每种可能组合下的总成本。
	最优路径选择： 经过一系列比较分析之后，CBO 最终选定一条预计耗时最短且资源消耗最少的物理执行计划作为输出结果

实现细节
	动态规划算法：为了在有限时间内找到全局最优解，StarRocks 引入了动态规划思想。它将复杂问题分解成若干子问题求解，并利用记忆化技术避免重复计算。
	并行处理能力：考虑到现代硬件多核架构的特点，StarRocks 的 CBO 支持并行执行多个候选方案以加速搜索过程。
	自适应调整机制：随着系统负载变化或新数据不断涌入，原有的统计信息可能会变得陈旧甚至失效。因此，StarRocks 设计了一套自适应调整策略，在必要时刻重新采集样本并更新内部参数设置


性能优化：

SQL 语句在 StarRocks 中的生命周期可以分为查询解析（Query Parsing）、规划（Query Plan）、执行（Query Execution）三个阶段。通常对于 StarRocks 而言，查询解析不会成为查询性能的瓶颈，因为分析型需求的 QPS 普遍不高。

决定 StarRocks 中查询性能的关键就在于查询规划（Query Plan）和查询执行（Query Execution），二者的关系可以描述为 Query Plan 负责组织算子（Join/Order/Aggregation）之间的关系，Query Execution 负责执行具体算子

查看 Query Plan
Query Plan 可以分为逻辑执行计划（Logical Query Plan），和物理执行计划（Physical Query Plan），本章节所讲述的 Query Plan 默认指代的都是逻辑执行计划。
通过 EXPLAIN 命令查看 Query Plan： EXPLAIN sql_statement;



您可以在 fe/log/fe.audit.log 中看到所有查询和慢查询信息，每个查询对应一个 QueryID

Join hint：https://docs.starrocks.io/zh/docs/administration/Query_planning/#query-hint
针对多表关联查询，优化器一般会主动选择最优的 Join 执行方式。在特殊情况下，您也可以使用 Join hint 显式地向优化器建议 Join 执行方式、以及禁用 Join Reorder。目前 Join hint 支持的 Join 执行方式有 Shuffle Join、Broadcast Join、Bucket Shuffle Join 和 Colocate Join。

当您使用 Join hint 建议 Join 的执行方式后，优化器不会进行 Join Reorder，因此您需要确保右表为较小的表。并且当您所建议的 Join 执行方式为 Colocate Join 或者 Bucket Shuffle Join 时，您需要确保表的数据分布情况满足这两种 Join 执行方式的要求，否则所建议的 Join 执行方式不生效。
