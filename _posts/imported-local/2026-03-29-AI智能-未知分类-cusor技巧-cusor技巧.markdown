---
layout: "post"
title: "cusor技巧"
subtitle: "AI智能 / 未知分类"
date: "2026-03-29 13:55:04"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - 未知分类
categories:
    - AI智能
---

{% raw %}
> 来源：`本机相关/04-AI智能/03-未知分类/cusor技巧.md`

---
tags: [AI工具, Cursor, Claude-Code, MCP, 开发环境]
created: 2024-01-01
updated: 2026-03-29
status: draft
confidence: medium
---

# Cursor 与 Claude Code 使用技巧

> 记录 Cursor IDE 和 Claude Code 的配置、MCP 集成及常用命令技巧

## 概述

本文档整理了 Cursor IDE 和 Claude Code 的使用技巧，包括 API 配置、MCP 安装、常用命令等内容，帮助快速上手 AI 辅助编程工具。

## Claude Code 配置

### API 密钥配置

```bash
# 设置 Anthropic API Key
export ANTHROPIC_API_KEY=sk-HRdHi1vAKnakrX7rYZpKYCv5qc5kG47VUv2FndYmKvwphnhM

# 或使用 Auth Token
export ANTHROPIC_AUTH_TOKEN=sk-HRdHi1vAKnakrX7rYZpKYCv5qc5kG47VUv2FndYmKvwphnhM
export ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic/
```

### Kimi API 配置

```bash
echo -e '\n export ANTHROPIC_BASE_URL=https://api.kimi.com/coding/' >> ~/.zshrc
echo -e '\n export ANTHROPIC_AUTH_TOKEN=sk-kimi-ej1QtdOkWs0KHcyMUate3dN2Pho1uApSZxaq0o5Zez4jbfqigjHqgbF5PlTvOWcl' >> ~/.zshrc
source ~/.zshrc
```

### Moonshot API 配置

```bash
echo -e '\n export ANTHROPIC_AUTH_TOKEN >> ~/.zshrc
echo -e '\n export ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic/' >> ~/.zshrc
source ~/.zshrc
```

## Claude Code 常用命令

| 命令 | 功能说明 |
|------|----------|
| `/help` | 列出所有斜线命令 |
| `/add-dir` | 添加更多工作目录 |
| `/bug` | 向 Anthropic 报告错误 |
| `/clear` | 清除聊天记录 |
| `/compact` | 压缩上下文 |
| `/config` | 配置菜单 |
| `/cost` | Token 花费统计 |
| `/doctor` | 客户端完整性检查 |
| `/exit` | 退出 Claude Code |
| `/init` | 初始化项目，生成 CLAUDE.md 全局记忆 |
| `/mcp` | 查看 MCP 列表和状态 |
| `/memory` | 编辑记忆 |
| `/model` | 更换模型 |
| `/permissions` | 修改工具权限 |
| `/pr_comments` | 查看 PR 评论 |
| `/review` | 请求代码审查 |
| `/sessions` | 列出 sessions 列表 |
| `/status` | 系统/账户状态 |
| `/terminal-setup` | 安装 Shift+Enter 绑定 |
| `/vim` | 切换 vim 模式 |

### 跳过权限检查模式

```bash
claude --dangerously-skip-permissions
```

## MCP (Model Context Protocol) 集成

### 核心 MCP 推荐

| MCP 名称 | 功能说明 |
|----------|----------|
| **context7** | 引入最新的代码库知识 |
| **browsermcp** | 让 Claude Code/Cursor 直接操作浏览器查看内容 |

### 安装 MCP

```bash
# 安装 OpenSkills
openskills install

# 添加 filesystem MCP
#!/bin/bash
echo "add mcp"
echo "add filesystem"
claude mcp add filesystem -s user -- npx -y @modelcontextprotocol/server-filesystem ~/Documents/code
```

## Agent Teams 功能

启用实验性 Agent Teams：

```bash
CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```

### 示例：多 Agent 协作

```
I'm designing a CLI tool that helps developers track TODO comments across
their codebase. Create an agent team to explore this from different angles: one
teammate on UX, one on technical architecture, one playing devil's advocate.
```

## 最佳实践

1. **API 密钥管理**：使用环境变量而非硬编码，定期轮换密钥
2. **MCP 选择**：优先使用官方 MCP，注意版本兼容性
3. **权限控制**：生产环境谨慎使用 `--dangerously-skip-permissions`
4. **上下文管理**：定期使用 `/compact` 压缩上下文，节省 token

## 常见问题

### Q: API 调用失败怎么办？
检查 API Key 是否正确，BASE_URL 是否可访问，网络是否畅通。

### Q: MCP 安装失败？
确保 Node.js 版本兼容，尝试清除 npm 缓存后重新安装。

---

> 🤔 **存疑**：`sk-9uKDgYIb0whVCLoELVopazjiY2fswsAAGbMhqX62y1RetCck` 这个密钥来源不明，建议删除或标注用途
{% endraw %}
