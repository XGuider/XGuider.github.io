---
layout: "post"
title: "Spring 与Springboot区别"
subtitle: "Java开发 / Spring框架 / Spring"
date: "2026-03-26 14:21:44"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - Spring框架
    - Spring
categories:
    - Java开发
---

> 来源：`本机相关/02-Java开发/01-Spring框架/Spring/Spring 与Springboot区别.md`

二者主要区别是：

1、Spring Boot提供极其快速和简化的操作，让 Spring 开发者快速上手。

2、Spring Boot提供了 Spring 运行的默认配置。

3、Spring Boot为通用 Spring项目提供了很多非功能性特性，例如：嵌入式 Serve、Security、统计、健康检查、外部配置等等。



Spring 是一个“引擎” 

Spring MVC 是基于 Spring 的一个 MVC 框架 

Spring Boot 是基于 Spring4 的条件注册的一套快速开发整合包 


Spring 最初利用“工厂模式”（ DI ）和“代理模式”（ AOP ）解耦应用组件。大家觉得挺好用，于是按照这种模式搞了一个 MVC 框架（一些用 Spring 解耦的组件），用开发 web 应用（ SpringMVC ）。然后有发现每次开发都要搞很多依赖，写很多样板代码很麻烦，于是搞了一些懒人整合包（ starter ），这套就是 Spring Boot 。
