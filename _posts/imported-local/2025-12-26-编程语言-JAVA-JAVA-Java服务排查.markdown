---
layout: "post"
title: "Java服务排查"
subtitle: "编程语言 / JAVA / JAVA"
date: "2025-12-26 18:43:39"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - JAVA
categories:
    - 编程语言
---

> 来源：`本机相关/01-编程语言/01-JAVA/JAVA/Java服务排查.md`

内存：
ps -L -o tid,pcpu,comm -p <你的Java进程PID> | sort -nr -k2 | head -10 查看线程前10 CPU的占用
查看当前的内存存活的类： 
jmap -histo:live 12 | grep -i connect：是一个强大的组合命令，专门用于在Java堆内存中精准地查找和分析与“连接”相关的存活对象，会触发一次gc; 
jmap -histo [pid] | head -30：查看占用内存最大的类（前30个）
jstat -gc [pid] ：查看gc统计；
jstat -gcutil [pid] 1000 ：查看实时GC情况（每隔1秒打印一次gc统计信息）
jmap -dump:format=b,file=xxx.hprof [pid]:使用命令导出内存快照 

查看 JVM 启动参数：
jinfo -flags <pid>


什么是内存泄露？
在Java程序运行时，系统会为其分配一块固定的内存空间，用于存储运行时的临时数据。如果程序试图使用超出可用内存范围的资源，就可能导致系统无法为新对象分配内存，从而抛出OutOfMemoryError异常，这种情况通常称为内存溢出（Out of Memory, OOM）。
建议使用jmap生成heap dump文件来分析堆快照；可使用性能分析工具（如VisualVM、JProfiler）来监控程序的内存使用情况。这些工具的核心功能通常相似。
慎用静态集合和单例
静态集合（如ArrayList、HashMap等）和单例模式会持有对象的引用，直到JVM退出，容易导致内存泄露。将不再使用的对象及时从集合中移除，避免长时间引用。
泄漏排查好文：https://developer.aliyun.com/article/1205568

CPU：
I/O等待问题：使用vmstat和iostat检查磁盘I/O和上下文切换情况。若磁盘利用率接近100%且I/O等待时间较长，可能是磁盘性能瓶颈：
bash
vmstat 1  # 每秒刷新一次，观察上下文切换次数和中断次数
iostat -x 1  # 显示设备I/O统计，观察磁盘利用率和等待时间


一次服务CPU变高排查：
 找到占用 CPU 最高的进程： top -c， P使得进程按照 CPU 使用率排序；
 找到占用 CPU 最高的线程： top -Hp [pid] 键入大写 P;
 打印线程堆栈信息printf "%x\n" 95; 
 jstack 85 | grep '0x5f' -C20;
--- 排查 -----
 "waiting to lock"


触发GC：
 jcmd <PID> GC.run


 jstack 命令来获取 Java 进程的完整线程快照
 jstack  12 | grep '^\".*\"' | awk '{print substr($0,1,10)}' | sort | uniq -c | sort -nr; 线程名排序；
 jstack -l pid >> xxx.txt:打印线程当前（当前指的是执行命令的时刻）堆栈信息
# 统计线程状态分布

jstack 6 ｜ grep "java.lang.Thread.State" | sort | uniq -c | sort -nr
jstack 6 | grep -A 50 "RUNNABLE"

# 查看线程执行状态
jstack 6 | grep -A 10 'http-nio" | grep "java.lang.Thread.State" | sort |uniq -c |sort -nr

# 快速排查线程
jstack 13 | grep '^\",*"" |awk "{print substr(0,1,10)}'| sort | uniq -c | sort -nr
pS -L-wW -p 13
jmap -histo:live 12 | grep -i connect
jstack 12 | grep '^\".*"" |awk "{print substr(0,1,10)}'| sort | unig c | sort -nr | head -10



资源泄漏或异常处理
# 查看进程打开文件数
lsof -p <PID> | wc -l

锁竞争加剧
# 查找等待锁的线程
grep -B 5 -A 10 "waiting to lock" jstack_dump.txt
# 查找持有锁的线程  
grep -B 5 -A 10 "locked" jstack_dump.txt

外部依赖变慢
-- MySQL 慢查询日志
SHOW VARIABLES LIKE 'slow_query_log%';
-- 或查询performance_schema
