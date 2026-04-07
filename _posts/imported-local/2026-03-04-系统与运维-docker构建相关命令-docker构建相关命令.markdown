---
layout: "post"
title: "docker构建相关命令"
subtitle: "系统与运维"
date: "2026-03-04 11:25:22"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
categories:
    - 系统与运维
---

{% raw %}
> 来源：`本机相关/06-系统与运维/docker构建相关命令.md`

构建镜像：
docker build -t welcome-to-docker .
docker build: 这是构建 Docker 镜像的命令。
-t welcome-to-docker: 这个参数指定了构建的镜像的名称（welcome-to-docker）。-t 是 tag 的缩写，用于给镜像打标签，使得它易于识别和使用。
.: 这表示 Docker 构建的上下文路径。Docker 在这个路径下查找 Dockerfile 文件，并根据 Dockerfile 中的指令来构建镜像。

运行镜像：
docker compose up -d
docker compose: 这是 Docker Compose 工具的命令行接口，用于管理多个 Docker 容器的应用程序。
up: 这是 Docker Compose 的一个子命令，用于启动指定的服务。
-d: 这个参数是指在“后台”模式下运行服务，也就是说，服务会在后台运行而不会阻塞命令行。
执行 docker compose up -d 命令时，Docker Compose 会在当前目录中查找 docker-compose.yml 文件，并根据该文件中定义的服务配置来启动相应的容器。这些容器会以后台模式启动，你可以在启动后立即返回到命令行提示符。


构建自己的Dockfile
docker buildx build -t my-image:latest .
docker init
docker compose up
或者
Dockerfile文件这个目录下执行命令：
docker build -t mytes
docker images
docker run -p 127.0.0.1:8111:80 -d --name myubuntu_test myubuntu:v8



#实时查看日志
docker-compose logs -f 

#启动服务：
docker-compose start


#查看镜像、容器、网络及卷：
[root@localhost counter-app-master]# docker images
REPOSITORY                  TAG       IMAGE ID       CREATED          SIZE
counter-app-master-web-fe   latest    da547efce15a   52 minutes ago   55.1MB
redis                       alpine    3900abf41552   2 years ago      32.4MB
[root@localhost counter-app-master]# docker ps
CONTAINER ID   IMAGE                       COMMAND                  CREATED          STATUS         PORTS                                       NAMES
775de272840c   counter-app-master-web-fe   "python app.py"          52 minutes ago   Up 2 minutes   0.0.0.0:5000->5000/tcp, :::5000->5000/tcp   counter-app-master-web-fe-1
60badb2d9db4   redis:alpine                "docker-entrypoint.s…"   52 minutes ago   Up 2 minutes   6379/tcp                                    counter-app-master-redis-1
[root@localhost counter-app-master]# docker network ls
NETWORK ID     NAME                             DRIVER    SCOPE
2d11a73f849e   bridge                           bridge    local
7bc0ef96bf07   counter-app-master_counter-net   bridge    local
303bac79a650   host                             host      local
f08b7d46c61e   none                             null      local
[root@localhost counter-app-master]# docker volume ls
DRIVER    VOLUME NAME
local     counter-app-master_counter-vol


#构建Dockerfile文件
redis[root@localhost counter-app-master]# cat Dockerfile
FROM python:3.6-alpine
ADD . /code
WORKDIR /code
RUN pip install -r requirements.txt
CMD ["python", "app.py"]
{% endraw %}
