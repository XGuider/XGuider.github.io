---
layout: "post"
title: "Dockerfile模版"
subtitle: "系统与运维 / Docker"
date: "2025-06-14 22:37:26"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - Docker
categories:
    - 系统与运维
---

{% raw %}
> 来源：`本机相关/06-系统与运维/02-Docker/Dockerfile模版.md`

# 使用官方 Maven 镜像作为构建阶段
FROM maven:3.8.6-openjdk-11 AS build
WORKDIR /app

# 复制 pom.xml 和源代码
COPY pom.xml .
COPY src ./src

# 构建项目
RUN mvn clean package

# 使用轻量级 JRE 镜像作为运行阶段
FROM openjdk:11-jre-slim
WORKDIR /app

# 从构建阶段复制构建好的 jar 文件
COPY --from=build /app/target/*.jar app.jar

# 暴露端口（根据你的应用调整）
EXPOSE 8080

# 启动应用
ENTRYPOINT ["java", "-jar", "app.jar"]
{% endraw %}
