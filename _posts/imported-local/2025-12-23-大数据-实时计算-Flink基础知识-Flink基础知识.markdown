---
layout: "post"
title: "Flink基础知识"
subtitle: "大数据 / 实时计算"
date: "2025-12-23 13:23:15"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - 实时计算
categories:
    - 大数据
---

> 来源：`本机相关/03-大数据/01-实时计算/Flink基础知识.md`

四大数据处理模块：TGwu
T：map、flatMap、filter、；转换
G：keyBy、reduce、aggregate： 聚合
W：window、apply ：窗口
U：union、connect、 ：链接


map、filter、flatMap：算子都是这种one-to-one的对应关系。这种关系类似于Spark中的窄依赖
keyBy/window：这一过程类似于Spark中的shuffle

TaskManager->subtask
当所有算子并行度相同时，容易看出source和flatmap可以合并算子链,算为一个slot
算子链（Operator Chaining） 是 Flink 的一种优化技术，将多个算子（Operator）合并到同一个线程中执行，形成一个物理执行任务（Task），以减少线程切换、序列化/反序列化开销，从而提升作业性能


Flink执行流程图：
DataStream API编写的代码生成的最初的DAG图：逻辑流图
StreamGraph经过优化后生成的就是作业图（JobGraph）：作业图
JobMaster收到JobGraph后，会根据它来生成执行图：执行图
JobMaster生成执行图后，会将它分发给TaskManager：物理图
