---
layout: "post"
title: "MySQL的问题排查"
subtitle: "编程语言 / MySQL"
date: "2026-03-29 14:06:45"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - MySQL
categories:
    - 编程语言
---

{% raw %}
> 来源：`本机相关/01-编程语言/08-MySQL/MySQL的问题排查.md`

---
tags:
  - MySQL
  - 数据库
  - 问题排查
  - 性能优化
created: 2024-01-01
updated: 2026-03-29
status: final
confidence: high
---

大表删除是一个高并发压力的操作。
原理： DELETE 操作会获取行锁（Row Lock）和间隙锁（Gap Lock），同时需要写入大量的 Undo Log（回滚日志）和 Redo Log（重做日志）。
为什么越删越慢？
锁等待： 如果你的删除操作是在业务高峰期进行，或者有长事务阻塞，后面的删除语句会处于 Waiting for meta data lock 或行锁等待状态。
日志压力： 随着删除数据量的累积，事务日志文件变得巨大，刷脏页（Flush）的压力越来越大，拖慢了整体的处理速度。

1. 分批删除 (Batch Delete)
不要试图一次性删完，也不要依赖 LIMIT 在循环中无脑执行（这可能导致扫描范围越来越大）。
推荐做法： 利用主键 ID 进行分页。
先查出满足条件的 ID 范围。
然后 DELETE FROM table WHERE id BETWEEN min_id AND max_id AND updated_at < 'xxx';
这样利用了主键索引，速度极快，且能避免偏移量过大（OFFSET）带来的性能损耗。


## 核心机制
客户端 → 连接器 → 查询缓存（8.0已移除） → 分析器 → 优化器 → 执行器 → 存储引擎（InnoDB）

事务（ACID）
A（原子性）：要么全成功，要么全失败。
C（一致性）：数据始终满足约束（如余额不能为负）。
I（隔离性）：多个事务互不干扰（通过隔离级别控制）。
D（持久性）：提交后数据永久保存。


隔离级别（InnoDB 默认是 可重复读）： （InnoDB 用 MVCC + 间隙锁解决）， 解决幻读
T1: BEGIN; SELECT balance FROM account WHERE id=1; -- 读到 100
T2: UPDATE account SET balance = 200 WHERE id=1; COMMIT;
T1: SELECT balance FROM account WHERE id=1; -- 仍然读到 100（快照）
T1: COMMIT;
T3: SELECT balance... -- 读到 200

## 锁机制
共享锁（S锁）：读操作加锁，允许多个读。
排他锁（X锁）：写操作加锁，独占。
行锁 vs 表锁：InnoDB 默认行锁（基于索引），MyISAM 是表锁。
间隙锁（Gap Lock）：防止幻读，在范围之间加锁。

## 日志	作用
Redo Log（重做日志）	记录“物理修改”，用于崩溃恢复（WAL 机制）
Undo Log（回滚日志）	记录旧值，用于事务回滚和 MVCC
Binlog（二进制日志）	逻辑日志，用于主从复制、数据恢复

## 常用 SQL 语句
-- 创建数据库
CREATE DATABASE myapp;

-- 使用数据库
USE myapp;

-- 创建表
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email)
);

-- 插入
INSERT INTO users (name, email) VALUES ('Alice', 'alice@example.com');

-- 查询（带索引）
SELECT * FROM users WHERE email = 'alice@example.com';

-- 更新
UPDATE users SET name = 'Alice Smith' WHERE id = 1;

-- 删除（慎用！）
DELETE FROM users WHERE created_at < '2020-01-01';



## 索引最佳实践
✅ 在 WHERE、JOIN、ORDER BY 字段上建索引。
✅ 复合索引注意顺序（最左前缀原则）。
❌ 不要给低区分度字段建索引（如性别只有男/女）。
❌ 避免在索引列上使用函数（如 WHERE YEAR(created_at) = 2023）。
-- ❌ 慢（OFFSET 越大越慢）
SELECT * FROM orders ORDER BY id LIMIT 100000, 20;

-- ✅ 快（基于主键游标）
SELECT * FROM orders WHERE id > 100000 ORDER BY id LIMIT 20;


 InnoDB 存储引擎 : 内存结构  \ 磁盘结构 \ 后台线程
{% endraw %}
