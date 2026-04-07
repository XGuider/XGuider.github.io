---
layout: "post"
title: "基础命令"
subtitle: "编程语言 / SHELL / SHELL"
date: "2026-03-29 14:02:18"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - SHELL
categories:
    - 编程语言
---

> 来源：`本机相关/01-编程语言/04-SHELL/SHELL/基础命令.md`

---
tags: [Shell, Linux命令, Bash, 脚本编程]
created: 2024-01-01
updated: 2026-03-29
status: published
confidence: high
---

# Shell 基础命令速查

> 常用 Shell 命令和脚本编写技巧

## 概述

本文档整理了常用 Shell 命令和 Bash 脚本编写技巧，适合快速查阅。

---

## 文件操作

### 查看文件

```bash
# 查看文件内容
cat filename

# 分页查看
less filename

# 查看文件前几行
head -n 20 filename

# 查看文件后几行
tail -n 50 filename

# 实时查看日志
tail -f filename.log
```

### 文件权限

```bash
# 添加执行权限
chmod +x script.sh

# 修改所有者
chown user:group filename

# 递归修改目录权限
chmod -R 755 directory/
```

### 查找文件

```bash
# 按名称查找
find . -name "*.md"

# 按类型查找
find . -type f

# 按修改时间查找
find . -mtime -7

# 查找并删除
find . -name "*.tmp" -delete
```

---

## 文本处理

### grep 搜索

```bash
# 基本搜索
grep "pattern" file.txt

# 忽略大小写
grep -i "pattern" file.txt

# 显示行号
grep -n "pattern" file.txt

# 递归搜索目录
grep -r "pattern" directory/

# 显示匹配上下文
grep -C 3 "pattern" file.txt
```

### sed 替换

```bash
# 替换所有匹配
sed 's/old/new/g' file.txt

# 原地替换
sed -i 's/old/new/g' file.txt

# 删除匹配行
sed '/pattern/d' file.txt

# 在特定行前插入
sed -i '20i\新内容' file.txt
```

### awk 处理

```bash
# 打印指定列
awk '{print $1, $3}' file.txt

# 按分隔符处理
awk -F',' '{print $2}' file.csv

# 条件筛选
awk '$3 > 100 {print $1}' file.txt

# 求和计算
awk '{sum += $2} END {print sum}' file.txt
```

---

## 系统监控

### 进程管理

```bash
# 查看进程
ps aux | grep nginx

# 实时监控进程
top

# 按内存排序
top -o %MEM

# 杀死进程
kill -9 PID

# 按名称杀死
pkill -f nginx
```

### 磁盘使用

```bash
# 查看磁盘使用
df -h

# 查看目录大小
du -sh directory/

# 查找大文件
find . -type f -size +100M
```

### 内存使用

```bash
# 查看内存使用
free -h

# 详细内存信息
cat /proc/meminfo
```

---

## 网络命令

### 测试连接

```bash
# ping 测试
ping -c 4 example.com

# 检查端口
telnet example.com 80

# 查看网络接口
ifconfig

# 或
ip addr
```

### curl 请求

```bash
# GET 请求
curl https://api.example.com

# POST 请求
curl -X POST -d "data=value" https://api.example.com

# 带 header
curl -H "Authorization: Bearer token" https://api.example.com

# 下载文件
curl -O https://example.com/file.zip
```

---

## 压缩解压

### tar 命令

```bash
# 打包
tar -cvf archive.tar directory/

# 解包
tar -xvf archive.tar

# 压缩
tar -czvf archive.tar.gz directory/

# 解压
tar -xzvf archive.tar.gz
```

### zip 命令

```bash
# 压缩
zip -r archive.zip directory/

# 解压
unzip archive.zip

# 解压到指定目录
unzip archive.zip -d /path/to/directory/
```

---

## 常用快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl + C` | 终止当前命令 |
| `Ctrl + Z` | 挂起当前命令 |
| `Ctrl + D` | 退出当前 shell |
| `Ctrl + L` | 清屏 |
| `Ctrl + A` | 光标移到行首 |
| `Ctrl + E` | 光标移到行尾 |
| `Ctrl + U` | 删除光标前内容 |
| `Ctrl + K` | 删除光标后内容 |
| `Ctrl + R` | 反向搜索历史 |

---

## 脚本模板

### 基础脚本模板

```bash
#!/bin/bash

set -e  # 遇到错误立即退出
set -u  # 使用未定义变量时报错
set -o pipefail  # 管道中任何一个失败则失败

# 变量定义
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# 主逻辑
main() {
    log "开始执行..."
    # 你的代码
    log "执行完成"
}

main "$@"
```

### 参数解析

```bash
#!/bin/bash

while getopts "hvf:" opt; do
    case $opt in
        h)
            echo "帮助信息"
            exit 0
            ;;
        v)
            VERBOSE=1
            ;;
        f)
            FILE="$OPTARG"
            ;;
        \?)
            echo "无效选项: -$OPTARG"
            exit 1
            ;;
    esac
done
```

---

## 参考资源

- [Linux 命令大全](https://zhuanlan.zhihu.com/p/642738162)
- [Bash 脚本教程](https://wangdoc.com/bash/)
