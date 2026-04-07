---
layout: "post"
title: "Java反射的使用"
subtitle: "编程语言 / JAVA / JAVA"
date: "2026-03-29 14:08:06"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - JAVA
categories:
    - 编程语言
---

> 来源：`本机相关/01-编程语言/01-JAVA/JAVA/Java反射的使用.md`

---
tags:
  - Java
  - 编程语言
  - 反射机制
created: 2024-01-01
updated: 2026-03-29
status: final
confidence: high
---

配置文件（processors.config）
processor.classname=ConcreteProcessorB

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Properties;

public class ReflectionUtil {
    public static void main(String[] args) throws Exception {
        // 从配置文件中读取要使用的处理器类名
        Properties props = new Properties();
        props.load(Files.newInputStream(Paths.get("processors.config")));

        String className = props.getProperty("processor.classname");
        
        // 使用反射加载类
        Class<?> processorClass = Class.forName(className);
        
        // 创建类的实例
        Processor processor = (Processor) processorClass.getDeclaredConstructor().newInstance();
        
        // 调用方法
        processor.process(); // 根据配置调用相应的 process 方法
    }
}
