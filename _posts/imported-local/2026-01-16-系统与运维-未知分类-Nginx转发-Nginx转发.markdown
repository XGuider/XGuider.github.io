---
layout: "post"
title: "Nginx转发"
subtitle: "系统与运维 / 未知分类"
date: "2026-01-16 17:20:12"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - 未知分类
categories:
    - 系统与运维
---

> 来源：`本机相关/06-系统与运维/04-未知分类/Nginx转发.md`

# ----------------------------
# 高并发容器优化版 nginx.conf
# 适配 4～8 CPU 容器环境
# ----------------------------

user nginx;
worker_processes auto;               # 自动匹配容器 CPU 核心数
worker_rlimit_nofile 65536;          # 提升文件描述符上限（需容器 ulimit 允许）

error_log /dev/stderr warn;
pid /var/run/nginx.pid;

events {
    worker_connections 16384;        # 提升单 worker 并发能力
    use epoll;                       # Linux 高性能 I/O
    multi_accept on;                 # 一次 accept 尽可能多接收
    accept_mutex off;                # 容器单实例，关闭锁竞争
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    # --- 安全 ---
    server_tokens off;               # 隐藏 Nginx 版本号
    reset_timedout_connection on;    # 主动关闭慢连接，释放资源

    # --- 性能优化 ---
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;

    # --- Keep-Alive 优化（平衡性能与资源）---
    keepalive_timeout 15;            # 从 65 降至 15 秒（更合理）
    keepalive_requests 1000;

    # --- 日志（含性能指标）---
    log_format main_json escape=json '{'
        '"time":"$time_iso8601",'
        '"client":"$remote_addr",'
        '"host":"$host",'
        '"request":"$request",'
        '"status":$status,'
        '"body_bytes":$body_bytes_sent,'
        '"rt":$request_time,'
        '"uct":"$upstream_connect_time",'
        '"urt":"$upstream_response_time",'
        '"ua":"$http_user_agent"'
    '}';
    access_log /dev/stdout main_json;
    error_log /dev/stderr warn;

    # --- 压缩 ---
    gzip on;
    gzip_vary on;
    gzip_min_length 1k;
    gzip_types
        text/plain
        text/css
        application/json
        application/javascript
        application/xml
        text/xml
        text/javascript;

    # --- 限流（防突发流量）---
    limit_req_zone $binary_remote_addr zone=api_limit:10m rate=50r/s;

    # --- 后端熔断池 ---
    upstream backend_servers {
        # 更激进的故障检测与恢复
        server 172.17.0.2:8080 max_fails=2 fail_timeout=10s;
        server 172.17.0.3:8080 max_fails=2 fail_timeout=10s;

        # 负载均衡算法：推荐 least_conn（高并发更均衡）
        least_conn;

        # 后端连接池（关键！减少 TCP 握手）
        keepalive 32;
    }

    server {
        listen 80 reuseport;         # 启用 SO_REUSEPORT（Linux 3.9+）

        location / {
            # 限流：允许突发 20，不延迟处理
            limit_req zone=api_limit burst=20 nodelay;

            # 代理到后端
            proxy_pass http://backend_servers;
            proxy_http_version 1.1;           # 启用 HTTP/1.1
            proxy_set_header Connection "";   # 清除 Connection 头，启用 keepalive

            # 透传客户端信息
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;

            # 超时设置（根据业务调整）
            proxy_connect_timeout 3s;         # 连接后端超时
            proxy_send_timeout 60s;           # 发送请求超时（覆盖默认 60s）
            proxy_read_timeout 60s;           # 读取响应超时（关键！避免误判）

            # 熔断增强：自动重试健康节点
            proxy_next_upstream error timeout http_502 http_503 http_504;
            proxy_next_upstream_timeout 5s;   # 重试总时间上限
            proxy_next_upstream_tries 3;      # 最多重试 3 次（含首次）

            # 缓冲优化（提升吞吐）
            proxy_buffering on;
            proxy_buffer_size 16k;
            proxy_buffers 8 32k;
        }

        # 健康检查端点（供 K8s 使用）
        location = /healthz {
            access_log off;
            internal;                         # 仅内部访问
            return 200 "OK\n";
        }

        # 安全：限制请求体大小（防 DOS）
        client_max_body_size 10m;
    }
}
