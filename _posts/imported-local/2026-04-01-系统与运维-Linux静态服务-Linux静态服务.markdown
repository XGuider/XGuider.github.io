---
layout: "post"
title: "Linux静态服务"
subtitle: "系统与运维"
date: "2026-04-01 22:01:05"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
categories:
    - 系统与运维
---

{% raw %}
> 来源：`本机相关/06-系统与运维/Linux静态服务.md`

yum install -y net-tools 安装

vi /etc/sysconfig/network-scripts/ifcfg-enp0s3


TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static
NETMAST=255.255.255.0
IPADDR=192.168.18.102
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=enp0s3
UUID=3b2b86a7-2b67-4c22-ae0b-205236df7539
DEVICE=enp0s3
ONBOOT=yes
GATEWAY=192.168.18.1
DNS1=114.114.114.114
DNS2=8.8.8.8

systemctl restart NetworkManager
systemctl restart network
{% endraw %}
