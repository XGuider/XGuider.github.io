---
layout: "post"
title: "CoreDNS"
subtitle: "系统与运维 / K8s组件"
date: "2026-02-26 17:34:05"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - K8s组件
categories:
    - 系统与运维
---

{% raw %}
> 来源：`本机相关/06-系统与运维/K8s组件/CoreDNS.md`

当服务 A 的 Pod 中执行 curl http://svc-b:80 时，背后发生了以下故事：

第一步：发起请求（服务 A 说：“我要找 svc-b”）
服务 A 不知道服务 B 的具体 IP，只知道它的名字 svc-b（或者全名 svc-b.default.svc.cluster.local）。它首先需要把这个名字变成 IP 地址。
第二步：DNS 解析（CoreDNS 说：“它在 10.96.123.45”）这是 CoreDNS 的职责。
服务 A 的容器内有一个配置文件 /etc/resolv.conf，里面写着 DNS 服务器的地址是集群内部的 kube-dns Service（通常是 10.96.0.10）。
服务 A 向 CoreDNS 发起查询请求：“svc-b.default.svc.cluster.local 的 IP 是多少？”
CoreDNS 查看它的记录表，发现 svc-b 对应的 ClusterIP 是 10.96.123.45。
CoreDNS 将这个 IP 地址返回给服务 A。

第三步：虚拟 IP 转发（Service + kube-proxy 说：“把包给我”）
这是 Service 和 kube-proxy 的职责。此时服务 A 拿到了 IP，它会尝试向 10.96.123.45:80 发送 TCP/HTTP 请求。
数据包离开服务 A 的 Pod，进入宿主机网络。
由于目标 IP 10.96.123.45 是一个虚拟 IP（ClusterIP），宿主机的网络协议栈不认识它。
kube-proxy（运行在每个节点上的代理组件）拦截到了这个包。它在节点上维护了一套规则（iptables 或 IPVS），记录了“访问 10.96.123.45:80 应该转发到后端 Pod 的真实 IP”。
kube-proxy 将数据包的目标 IP 地址修改为服务 B 的某个真实 Pod IP（例如 10.32.1.5:80）。这个过程叫做 DNAT（目标网络地址转换）。


第四步：物理网络传输（CNI 说：“我送你过去”）
这是底层网络插件（如 Calico, Flannel）的职责。
数据包现在的目标地址变成了真实的 Pod IP 10.32.1.5。
底层 CNI 插件根据路由表，将数据包通过物理网络（Overlay 或 Underlay）转发到运行着服务 B Pod 的那台物理机（Node）。
数据包最终到达服务 B 的 Pod，服务 B 处理请求并返回结果（回程路径类似，经过反向代理和 NAT）。


问题排查：

服务 A 调用服务 B 失败，可以按这个顺序排查：
查 DNS：进入服务 A 的 Pod，执行 nslookup svc-b。如果解析不出来，是 CoreDNS 或 Service 名称的问题。
查 Service：在节点上执行 kubectl get endpoints svc-b。如果列表为空，说明 Service 的标签选择器（selector）没有匹配到任何 Pod。
查连通性：如果解析和端点都正常，尝试在服务 A 中直接 curl http://<Pod-IP-of-B>。如果能通但通过 Service 不通，通常是 kube-proxy 或防火墙问题。
{% endraw %}
