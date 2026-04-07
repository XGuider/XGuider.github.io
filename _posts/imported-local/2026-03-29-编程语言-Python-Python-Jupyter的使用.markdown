---
layout: "post"
title: "Jupyter的使用"
subtitle: "编程语言 / Python / Python"
date: "2026-03-29 14:08:06"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - Python
categories:
    - 编程语言
---

> 来源：`本机相关/01-编程语言/02-Python/Python/Jupyter的使用.md`

---
tags:
  - Python
  - 编程语言
  - Jupyter
  - 数据科学
created: 2024-01-01
updated: 2026-03-29
status: final
confidence: high
---

python3

echo $SHELL
nano ~/.zprofile
source ~/.zprofile

# 安装Jupyter
pip install jupyterlab
jupyter lab

pip install jupyter_contrib_nbextensions
jupyter contrib nbextension install --user




常用的快捷键包括：
在当前单元格下方新建一个单元格：b
在当前单元格上方新建一个单元格：a
运行当前单元格：shift + enter
删除当前单元格：dd
复制当前单元格：c
粘贴复制了的单元格：v
剪切当前单元格：x
查找与替换当前单元格的内容：f (ps: 这个快捷键在重构代码时非常好用）
设置当前单元格为Markdown：m
查看所有快捷键：H ❗️查看快捷键的快捷键是Jupyter Notebook里一大妙笔，忘记了快捷键就可以查看❗️
