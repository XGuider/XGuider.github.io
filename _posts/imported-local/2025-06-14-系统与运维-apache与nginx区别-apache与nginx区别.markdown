---
layout: "post"
title: "apache与nginx区别"
subtitle: "系统与运维"
date: "2025-06-14 22:29:18"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
categories:
    - 系统与运维
---

{% raw %}
> 来源：`本机相关/06-系统与运维/apache与nginx区别.md`

架构设计：
	Apache 使用多进程/多线程模型，适合动态内容处理，但高并发性能较弱。
	Nginx 使用事件驱动模型，适合高并发和静态内容处理，资源占用低。
性能：
	Apache 在动态内容处理（如 PHP）上表现更好。
	Nginx 在静态内容处理和高并发场景下性能更优。
配置方式：
	Apache 支持 .htaccess，灵活性高，但配置复杂。
	Nginx 配置简洁，但不支持 .htaccess，需重启生效。
功能支持：
	Apache 的功能依赖模块（如 mod_proxy、mod_cache），配置复杂。
	Nginx 内置负载均衡、缓存等功能，配置简单且性能优异

Apache：
日志：
LogFormat "%{X-Forwarded-For}i %l %u %t \"%r\" %>s %b %{ms}T %{Foobar}C" common
CustomLog /dev/stdout common
ErrorLog /dev/stdout 
但是apache日志出现the timeout specified has expired:[client 197.0.0.1:8080] AH01095:prefertch request body failed to 197.0.0.2:30800 from 197.0.0.1(), referer:https://xxx/xx/t.sh   。 https://xxx/xx/t.sh中的可能含有敏感词，如何修改apache的日志配置, 截断每行日志保留前100字段


配置文件：
使用 .htaccess 文件实现目录级配置，灵活性高。
主配置文件通常为 httpd.conf 或 apache2.conf
<VirtualHost *:80>
    ServerName example.com
    ProxyPass / http://backend_server/
    ProxyPassReverse / http://backend_server/
</VirtualHost>





Nginx：
其中 /v1，与/v1相关都可以代理
/v1/，只能代理/v1/下path

http {
    # 定义 User-Agent 路由规则 $backend // 指后端变量
    map $http_user_agent $backend {
        default          http://web_server;
        ~*SmartTV        http://tv_api;
        ~*Mobile         http://mobile_api;
        ~*IoT-Device     http://iot_gateway;
    }

    # 自定义日志格式
    log_format proxy_log '$remote_addr - $upstream_addr [$time_local] '
                         '"$request" $status $body_bytes_sent "$http_user_agent"';
    access_log /var/log/nginx/proxy.log proxy_log;

    server {
        listen 80;
        server_tokens off;
        large_client_header_buffers 4 16k;

        location / {
            resolver 8.8.8.8;
            proxy_set_header X-Device-Type $http_user_agent;
            proxy_pass $backend;

            # 超时配置
            proxy_connect_timeout 2s;
            proxy_read_timeout 60s;
            proxy_send_timeout 60s;

            # 故障回退机制
            proxy_next_upstream error timeout invalid_header;
        }
    }
}

动态 upstream 选择 转发路径
upstream backend_v1 {
    server 192.168.1.10:8080;
}

upstream backend_v2 {
    server 192.168.1.20:8080;
}

server {
    listen 80;

    # 匹配 /v1/ 开头的路径
    location /v1/ {
        proxy_pass http://backend_v1;
        proxy_connect_timeout 2s;
    }

    # 匹配 /v2/ 开头的路径
    location /v2/ {
        proxy_pass http://backend_v2;
        proxy_connect_timeout 2s;
    }

    # 默认路由
    location / {
        proxy_pass http://backend_v1;
        proxy_connect_timeout 2s;
    }
}
或者
http {
    # 定义 upstream
    upstream backend_v1 {
        server 192.168.1.10:8080;
    }

    upstream backend_v2 {
        server 192.168.1.20:8080;
    }

    # 根据 URL 路径动态选择 upstream
    map $uri $backend {
        default        backend_v1;
        ~^/v1/         backend_v1;
        ~^/v2/         backend_v2;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://$backend;
            proxy_connect_timeout 2s;
        }
    }
}
// 支持高效的静态内容缓存和反向代理缓存
proxy_cache_path /data/nginx/cache levels=1:2 keys_zone=my_cache:10m;
server {
    location / {
        proxy_cache my_cache;
        proxy_pass http://backend_server;
    }
}
{% endraw %}
