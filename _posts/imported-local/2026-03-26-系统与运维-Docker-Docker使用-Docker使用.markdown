---
layout: "post"
title: "Docker使用"
subtitle: "系统与运维 / Docker"
date: "2026-03-26 14:09:46"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - Docker
categories:
    - 系统与运维
---

{% raw %}
> 来源：`本机相关/06-系统与运维/02-Docker/Docker使用.md`

[https://www.runoob.com/docker/docker-hello-world.html](https://www.runoob.com/docker/docker-hello-world.html)

```plain
拉取获取镜像
$ docker pull ubuntu
启动容器，进入交互模式
$ docker run -it ubuntu /bin/bash
退出终端
exit
查看所有的容器
docker ps -a
启动已停止运行的容器
docker start b750bbbcfd88 
后台运行
docker run -itd --name ubuntu-test ubuntu /bin/bash
停止一个容器
docker stop <容器 ID>
后台进入容器
docker attach 《id》
exit不会关闭容器
docker exec -it 《id》 /bin/bash 
导入容器快照
cat docker/ubuntu.tar | docker import - test/ubuntu:v1
导出容器快照
docker export 《id》 > ubuntu.tar
删除容器
docker rm -f 《id》
列出镜像列表
docker images 
```
{% endraw %}
