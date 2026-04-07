---
layout: "post"
title: "Catalog使用指南"
subtitle: "Java开发 / 数据库"
date: "2026-03-25 18:12:56"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - 数据库
categories:
    - Java开发
---

> 来源：`本机相关/02-Java开发/03-数据库/Catalog使用指南.md`

# Catalog 使用指南

> 跨 Catalog 数据查询 - 连接多种数据源

## 📋 前提条件

需将以下配置文件放到 FE/BE 的 conf 目录：
- `core-site.xml`
- `hdfs-site.xml`
- `hive-site.xml`

---

## 🔧 创建 Catalog

### Hive Catalog

```sql
CREATE CATALOG hive PROPERTIES (
    "type" = "hms",
    "hive.metastore.uris" = "thrift://172.0.0.1:9083",
    "hadoop.username" = "hive"
);
```

---

## 📖 使用 Catalog

### 切换 Catalog

```sql
SWITCH jdbc_mysql;  -- 切换到 JDBC Catalog
```

### 查看数据库和表

```sql
SHOW DATABASES;     -- 查看该 Catalog 下的数据库
USE demo;           -- 使用具体数据库
SHOW TABLES;        -- 查看表
```

### 查询数据

```sql
-- 查询 MySQL 表数据
SELECT * FROM jdbc_mysql.demo.orders LIMIT 10;
```

---

## 🔗 跨 Catalog 联合查询

```sql
-- Hive 与 Doris 内表关联
SELECT h.orders.order_id, d.users.name 
FROM hive.warehouse.orders h 
JOIN internal.db.users d ON h.user_id = d.id;
```

---

## 📝 常用 Catalog 类型

| 类型 | 说明 |
|------|------|
| hms | Hive Metastore |
| jdbc | JDBC 连接（MySQL、PostgreSQL 等） |
| iceberg | Iceberg 表 |
| hudi | Hudi 表 |
