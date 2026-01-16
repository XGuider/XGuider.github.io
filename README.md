# XGuider Blog

基于 Jekyll 的个人博客，支持 GitHub Pages 自动部署。

## 📖 项目简介

这是一个基于 Jekyll 的现代化个人博客模板，具有以下特性：

- 📝 支持 Markdown 写作
- 🎨 响应式设计，适配各种设备
- 🔍 SEO 优化
- 💬 支持多评论系统（多说、Disqus、LiveRe）
- 📊 集成 Google Analytics
- 🏷️ 标签分类系统
- 📱 支持 PWA（Progressive Web App）
- 🎬 视频博客支持

## 🚀 快速开始

### 前置要求

- Ruby >= 2.5.0
- RubyGems
- Bundler

### 本地开发

1. **克隆项目**

```bash
git clone https://github.com/XGuider/XGuider.github.io.git
cd XGuider.github.io
```

2. **安装依赖**

```bash
bundle install
```

3. **启动本地服务器**

```bash
bundle exec jekyll serve
```

访问 `http://localhost:4000` 查看博客。

## 📦 部署到 GitHub Pages

### 方法一：自动部署（推荐）

1. Fork 或创建名为 `XGuider.github.io` 的仓库
2. 将代码推送到 GitHub
3. 在仓库设置中启用 GitHub Pages
4. GitHub 会自动构建和部署

### 方法二：本地构建后部署

```bash
# 构建网站
bundle exec jekyll build

# 将 _site 目录内容推送到 gh-pages 分支
# 或使用 GitHub Actions 自动部署
```

## 📁 项目结构

```
.
├── _config.yml          # Jekyll 配置文件
├── _includes/           # 可重用组件
│   ├── footer.html      # 页脚
│   ├── head.html        # HTML head 部分
│   └── nav.html         # 导航栏
├── _layouts/            # 页面模板
│   ├── default.html     # 默认布局
│   ├── post.html        # 文章布局
│   └── page.html        # 页面布局
├── _posts/              # 博客文章（Markdown格式）
├── _videos/             # 视频博客
├── css/                 # 样式文件
├── img/                 # 图片资源
├── js/                  # JavaScript 文件
├── about.html           # 关于页面
├── index.html           # 首页
└── 404.html             # 404 页面
```

## ⚙️ 配置说明

主要配置在 `_config.yml` 文件中：

### 站点设置

```yaml
title: XGuider Blog                    # 博客标题
SEOTitle: XGuider的博客 | XGuider Blog  # SEO 标题
url: "https://XGuider.github.io/"      # 网站 URL
baseurl: ""                            # 基础路径
email: your-email@example.com          # 联系邮箱
description: "博客描述"                # 网站描述
keyword: "关键词"                      # SEO 关键词
```

### 社交网络

```yaml
github_username: XGuider
weibo_username: XGuider
twitter_username: XGuider
```

### 评论系统

支持多种评论系统，在 `_config.yml` 中配置：

- **多说评论**：`duoshuo_username: XGuiderBlog`
- **Disqus**：`disqus_username: your_disqus_short_name`
- **LiveRe**：`livere_uid: your_livere_uid`

### Google Analytics

```yaml
ga_track_id: 'UA-xxxxxx-xx'    # 替换为你的 Google Analytics ID
ga_domain: XGuider.github.io    # 你的域名
```

## ✍️ 写作指南

### 创建新文章

在 `_posts/` 目录下创建文件，命名格式：`YYYY-MM-DD-title.markdown`

文章 Front Matter 示例：

```markdown
---
layout: post
title: "文章标题"
subtitle: "副标题（可选）"
author: "XGuider"
tags:
  - 标签1
  - 标签2
header-img: "img/post-bg-xxx.jpg"
---

文章内容...
```

### 创建新页面

在根目录创建 `.html` 或 `.md` 文件，Front Matter：

```markdown
---
layout: page
title: "页面标题"
description: "页面描述"
header-img: "img/page-bg.jpg"
---
```

### 创建视频博客

在 `_videos/` 目录下创建 `.md` 文件：

```markdown
---
layout: video
title: "视频标题"
iframe: "视频嵌入链接"
tags:
  - 标签
---
```

## 🎨 自定义样式

- 主要样式文件：`css/hux-blog.css`
- 代码高亮样式：`css/syntax.css`
- 视频样式：`css/videos.css`

## 🔧 常用命令

```bash
# 启动本地服务器（带实时重载）
bundle exec jekyll serve

# 构建网站
bundle exec jekyll build

# 构建并查看
bundle exec jekyll build --watch

# 清理缓存并重建
bundle exec jekyll clean && bundle exec jekyll build
```

## 📝 更新日志

### v1.0.0
- ✅ 初始版本
- ✅ 支持 GitHub Pages 部署
- ✅ 集成评论系统
- ✅ SEO 优化
- ✅ 响应式设计

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

本项目基于 [Hux Blog](https://github.com/Huxpro/huxpro.github.io) 模板修改，感谢原作者的优秀工作。

## 📮 联系方式

- GitHub: [@XGuider](https://github.com/XGuider)
- 博客: [https://XGuider.github.io](https://XGuider.github.io)
- 邮箱: 973279990@qq.com

---

**福祸相依_学以致用！**
