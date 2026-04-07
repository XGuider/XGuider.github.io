---
layout: "post"
title: "changelog记录"
subtitle: "大数据 / 实时计算 / Flink实时数据仓库"
date: "2025-03-13 15:05:40"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - 实时计算
    - Flink实时数据仓库
categories:
    - 大数据
---

> 来源：`本机相关/03-大数据/01-实时计算/Flink实时数据仓库/changelog记录.md`

import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.table.api.bridge.java.StreamTableEnvironment;

public class FlinkSQLChangelogDemo {
    public static void main(String[] args) throws Exception {
        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        StreamTableEnvironment tableEnv = StreamTableEnvironment.create(env);

        // 启用 Checkpoint 和 Changelog
        env.enableCheckpointing(10000); // 10秒间隔
        env.getCheckpointConfig().setCheckpointingMode(CheckpointingMode.EXACTLY_ONCE);
        env.getCheckpointConfig().enableUnalignedCheckpoints();
        env.setStateBackend(new RocksDBStateBackend("file:///opt/flink/checkpoints", true)); // 增量检查点
        env.getCheckpointConfig().enableChangelogStateBackend(true);

        // 定义 MySQL CDC 源表
        tableEnv.executeSql(
            "CREATE TABLE orders ("
            + "  order_id BIGINT,"
            + "  user_id BIGINT,"
            + "  status STRING,"
            + "  event_time TIMESTAMP(3),"
            + "  PRIMARY KEY (order_id) NOT ENFORCED"
            + ") WITH ("
            + "  'connector' = 'mysql-cdc',"
            + "  'hostname' = 'localhost',"
            + "  'port' = '3306',"
            + "  'username' = 'root',"
            + "  'password' = '123456',"
            + "  'database-name' = 'test',"
            + "  'table-name' = 'orders',"
            + "  'changelog-mode' = 'all'" // 捕获所有变更类型
            + ")"
        );

        // 定义 Kafka Sink 表
        tableEnv.executeSql(
            "CREATE TABLE enriched_orders ("
            + "  order_id BIGINT,"
            + "  user_id BIGINT,"
            + "  status STRING,"
            + "  event_time TIMESTAMP(3),"
            + "  user_name STRING,"
            + "  PRIMARY KEY (order_id) NOT ENFORCED"
            + ") WITH ("
            + "  'connector' = 'kafka',"
            + "  'topic' = 'enriched_orders',"
            + "  'properties.bootstrap.servers' = 'localhost:9092',"
            + "  'format' = 'json',"
            + "  'sink.transactional-id-prefix' = 'tx-'," // 事务性写入
            + "  'sink.delivery-guarantee' = 'exactly-once'"
            + ")"
        );

        // 执行 SQL 查询（Join 用户表）
        tableEnv.executeSql(
            "INSERT INTO enriched_orders "
            + "SELECT o.order_id, o.user_id, o.status, o.event_time, u.user_name "
            + "FROM orders AS o "
            + "LEFT JOIN ("
            + "  SELECT user_id, user_name FROM users" // 假设 users 是另一个 CDC 表
            + ") AS u ON o.user_id = u.user_id"
        );

        env.execute("Flink SQL Changelog Demo");
    }
}
changelog-mode = 'all'：捕获 MySQL 的所有变更操作（INSERT/UPDATE/DELETE）。
enableChangelogStateBackend(true)：启用 Changelog 状态后端。
sink.transactional-id-prefix：Kafka 事务性写入的 ID 前缀，确保 Exactly-Once
