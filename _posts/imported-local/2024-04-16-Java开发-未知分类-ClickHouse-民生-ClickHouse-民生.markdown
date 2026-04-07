---
layout: "post"
title: "ClickHouse 民生"
subtitle: "Java开发 / 未知分类"
date: "2024-04-16 16:24:49"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - 未知分类
categories:
    - Java开发
---

{% raw %}
> 来源：`本机相关/02-Java开发/04-未知分类/ClickHouse_民生.md`

CREATE TABLE rangers.events_all (
    app_id UInt32,
    app_name String DEFAULT '',
    device_id String DEFAULT '',
    web_id String DEFAULT '',
    server_time UInt64,
    time UInt64,
    event String,
    stat_standard_id String,
    event_date Date,
    ab_version Array(Int32) BLOOM,
    string_params Map(String, LowCardinality(Nullable(String))),
    int_params Map(String, Int64),
    float_params Map(String, Float64),
    string_profiles Map(String, LowCardinality(Nullable(String))),
    int_profiles Map(String, Int64),
    float_profiles Map(String, Float64),
    user_id String DEFAULT 'ssid',
    array_profiles Map(String, Array(String)),
    string_array_params Map(String, Array(String)),
    string_item_profiles Map(String, Array(String)),
    float_item_profiles Map(String, Array(Float32)),
    int_item_profiles Map(String, Array(Int64))
) ENGINE = Distributed(rangers, 'rangers', 'events');


CREATE TABLE rangers.events (
    app_id UInt32,
    app_name String DEFAULT '',
    device_id String DEFAULT '',
    web_id String DEFAULT '',
    server_time UInt64,
    time UInt64,
    event String,
    stat_standard_id String,
    event_date Date,
    ab_version Array(Int32) BLOOM,
    string_params Map(String, LowCardinality(Nullable(String))),
    int_params Map(String, Int64),
    float_params Map(String, Float64),
    string_profiles Map(String, LowCardinality(Nullable(String))),
    int_profiles Map(String, Int64),
    float_profiles Map(String, Float64),
    user_id String DEFAULT 'ssid',
    array_profiles Map(String, Array(String)),
    string_array_params Map(String, Array(String)),
    string_item_profiles Map(String, Array(String)),
    float_item_profiles Map(String, Array(Float32)),
    int_item_profiles Map(String, Array(Int64))) ENGINE =HaMergeTree('/clickhouse/rangers/rangers.events/{shard}','{replica')PARTITION BY (app_id, event_date)
ORDER BY (event, hash_uid, time)
SAMPLE BY hash_uid SETTINGS index_granularity = 8192, storage_policy_name = 'disk_in_order';


// kubectl查看CK的大小
kubectl get pod -nclickhouse -owide|grep clickhouse
#找到 clickhouse 的节点，ssh 登录
cd /data00/clickhouse/data & du -sh *

sql:查的只能统计数据文件的大概大小，一些日志、元数据不在其中
select database,table,min(partition_id),formatReadableSize(sum(bytes_on_disk) as size) as fsize from cluster(rangers, system.parts, (1,2)) where database='rangers' and table='events' and partition_id>='10000000-20240205' and partition_id<='10000000-20240405' group by database,table limit 10


hdfs：
需要经过 kerberos 认证，确认 hdfs 路径，再执行命令：
hdfs dfs -du -s -h /xxxxx
{% endraw %}
