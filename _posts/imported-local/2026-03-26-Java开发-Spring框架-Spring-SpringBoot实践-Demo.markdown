---
layout: "post"
title: "SpringBoot实践-Demo"
subtitle: "Java开发 / Spring框架 / Spring"
date: "2026-03-26 14:31:12"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - Spring框架
    - Spring
categories:
    - Java开发
---

{% raw %}
> 来源：`本机相关/02-Java开发/01-Spring框架/Spring/SpringBoot实践-Demo.md`

```plain
@ServletComponentScan：
Servlet、Filter、Listener可以直接通过
@WebServlet、@WebFilter、@WebListener注解自动注册，无需其他代码。

参考：https://blog.csdn.net/m0_37739193/article/details/85097477
参考重写servlet：https://juejin.cn/post/6844904003885596680#heading-5
```


```plain
非web项目启动，禁用tomcat，https://www.1024sou.com/article/36576.html
```


```plain
设置活动配置文件'server'和默认属性'properties'以设置应用程序的环境：
SpringApplicationBuilder(Application.class).profiles("server")
                .properties("transport=local").run(args)
                
```
{% endraw %}
