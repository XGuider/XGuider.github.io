---
layout: "post"
title: "WEB依赖"
subtitle: "Java开发 / Spring框架 / Spring"
date: "2024-09-10 22:55:01"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - Spring框架
    - Spring
categories:
    - Java开发
---

> 来源：`本机相关/02-Java开发/01-Spring框架/Spring/WEB依赖.md`

<!-- spring-boot相关配置 -->	
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-web</artifactId>
</dependency>

<!-- spring-boot-starter-web相关配置 -->	
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-tomcat</artifactId>
  <version>2.0.7.RELEASE</version>
  <scope>compile</scope>
</dependency>
<dependency>
  <groupId>org.springframework</groupId>
  <artifactId>spring-web</artifactId>
  <version>5.0.11.RELEASE</version>
  <scope>compile</scope>
</dependency>
<dependency>
  <groupId>org.springframework</groupId>
  <artifactId>spring-webmvc</artifactId>
  <version>5.0.11.RELEASE</version>
  <scope>compile</scope>
</dependency>


spring-boot-starter-tomcat 是 Spring Boot 提供的一个启动器，它包含了嵌入式 Tomcat 服务器的依赖。通过引入这个依赖，你可以将 Spring Boot 应用程序打包成一个可执行的 JAR 文件，并使用嵌入式 Tomcat 服务器来运行它。
实现原理：当你运行 Spring Boot 应用程序时，Spring Boot 会自动配置嵌入式 Tomcat 服务器。Tomcat 服务器会在应用程序启动时启动，并监听指定的端口（默认是 8080）。
Spring Boot 通过 SpringApplication 类来启动应用程序，并在内部使用 TomcatEmbeddedServletContainerFactory 来创建和管理嵌入式 Tomcat 实例


<dependency>
  <groupId>org.springframework</groupId>
  <artifactId>spring-web</artifactId>
  <version>5.0.11.RELEASE</version>
  <scope>compile</scope>
</dependency>
spring-web 是 Spring Framework 的核心模块之一，提供了处理 HTTP 请求和响应的基础功能。它包含了 DispatcherServlet、HandlerMapping、HandlerAdapter 等核心组件，用于处理 Web 请求。
实现原理：
DispatcherServlet 是 Spring Web 应用程序的前端控制器，负责将请求分发到相应的处理器（Controller）。
HandlerMapping 负责将请求映射到相应的处理器方法。
HandlerAdapter 负责调用处理器方法并处理返回值。
spring-web 还提供了对 RESTful 服务的支持，包括 @RestController、@RequestMapping 等注解。
<dependency>
  <groupId>org.springframework</groupId>
  <artifactId>spring-webmvc</artifactId>
  <version>5.0.11.RELEASE</version>
  <scope>compile</scope>
</dependency>
使用：

spring-webmvc 是 Spring Web MVC 框架的核心模块，提供了构建 Web 应用程序的完整功能。它包含了 @Controller、@RequestMapping、ViewResolver 等组件，用于处理 Web 请求和响应。
实现原理：
spring-webmvc 扩展了 spring-web 的功能，提供了更高级的 Web 应用程序支持。
@Controller 注解用于标记控制器类，@RequestMapping 注解用于映射请求路径到控制器方法。
ViewResolver 用于解析视图名称并返回相应的视图对象。
spring-webmvc 还支持多种视图技术，如 JSP、Thymeleaf、Freemarker 等。



`spring-boot-starter-tomcat` 和单独的 Tomcat 服务器在功能和使用方式上有显著的区别。以下是它们的主要区别：
### 1. `spring-boot-starter-tomcat`

#### 功能和使用方式
- **嵌入式服务器**：`spring-boot-starter-tomcat` 是 Spring Boot 提供的一个启动器，它包含了嵌入式 Tomcat 服务器的依赖。通过引入这个依赖，你可以将 Spring Boot 应用程序打包成一个可执行的 JAR 文件，并使用嵌入式 Tomcat 服务器来运行它。
- **自动配置**：Spring Boot 会自动配置嵌入式 Tomcat 服务器，你不需要手动配置服务器参数。
- **简化部署**：由于是嵌入式的，你可以将应用程序打包成一个 JAR 文件，并直接运行，无需单独部署到外部 Tomcat 服务器。

#### 实现原理
- **Spring Boot 自动配置**：Spring Boot 通过 `SpringApplication` 类来启动应用程序，并在内部使用 `TomcatEmbeddedServletContainerFactory` 来创建和管理嵌入式 Tomcat 实例。
- **依赖管理**：Spring Boot 会自动管理 Tomcat 的版本和依赖，确保它们与 Spring Boot 版本兼容。

### 2. 单独的 Tomcat 服务器
#### 功能和使用方式
- **独立服务器**：单独的 Tomcat 服务器是一个独立的 Java Web 服务器，通常用于部署多个 Web 应用程序。你需要手动下载、安装和配置 Tomcat 服务器。
- **手动配置**：你需要手动配置 Tomcat 的参数，如端口、上下文路径、日志等。
- **部署方式**：你需要将你的应用程序打包成 WAR 文件，并将其部署到 Tomcat 的 `webapps` 目录下。
#### 实现原理
- **独立运行**：Tomcat 作为一个独立的 Java 进程运行，可以同时托管多个 Web 应用程序。
- **配置文件**：Tomcat 的配置主要通过 `server.xml`、`web.xml` 等配置文件进行管理。

### 主要区别
1. **部署方式**：
   - **嵌入式 Tomcat**：应用程序打包成 JAR 文件，直接运行。
   - **单独 Tomcat**：应用程序打包成 WAR 文件，部署到 Tomcat 的 `webapps` 目录。
2. **配置方式**：
   - **嵌入式 Tomcat**：Spring Boot 自动配置，无需手动配置。
   - **单独 Tomcat**：需要手动配置 Tomcat 的参数和配置文件。
3. **依赖管理**：
   - **嵌入式 Tomcat**：Spring Boot 自动管理 Tomcat 的版本和依赖。
   - **单独 Tomcat**：需要手动管理 Tomcat 的版本和依赖。
4. **运行环境**：
   - **嵌入式 Tomcat**：应用程序和 Tomcat 服务器打包在一起，运行在一个 Java 进程中。
   - **单独 Tomcat**：Tomcat 服务器作为一个独立的 Java 进程运行，可以托管多个应用程序。

### 总结

- **`spring-boot-starter-tomcat`**：适用于开发和部署单个 Spring Boot 应用程序，简化了部署和配置过程，适合快速开发和原型设计。
- **单独的 Tomcat 服务器**：适用于需要托管多个 Web 应用程序的场景，提供了更灵活的配置和管理选项，适合生产环境中的复杂部署需求。

根据你的需求和项目规模，你可以选择合适的部署方式。如果你只需要运行一个简单的 Spring Boot 应用程序，嵌入式 Tomcat 是一个很好的选择；如果你需要托管多个应用程序或需要更复杂的配置，单独的 Tomcat 服务器可能更适合。
