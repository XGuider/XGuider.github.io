---
layout: "post"
title: "underlay和Overlay"
subtitle: "系统与运维 / K8s组件"
date: "2025-06-13 11:22:57"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - K8s组件
categories:
    - 系统与运维
---

{% raw %}
> 来源：`本机相关/06-系统与运维/K8s组件/underlay和Overlay.md`

容器 Underlay 网络是指容器直接使用宿主机的底层物理网络基础设施进行通信的网络模式。
与 Overlay 网络相对，Underlay 网络提供了更直接的网络连接方式。


Underlay 网络是：
	底层物理网络基础设施（包括交换机、路由器、网卡等）
	容器直接使用主机网络栈或物理网络接口
	不经过额外的封装或隧道技术
{% endraw %}
