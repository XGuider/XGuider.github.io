# XGuider Blog

基于 Jekyll 的个人博客，支持 GitHub Pages 自动部署。

## 📖 项目简介

这是一个基于 Jekyll 的现代化个人博客模板，具有以下特性：

- 📝 支持 Markdown 写作
- 📄 **支持 PDF/Word 文档自动转换为 Markdown**
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
- Git

### 本地开发环境搭建

#### 1. 安装 Ruby

**macOS (使用 Homebrew):**
```bash
brew install ruby
```

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install ruby-full build-essential zlib1g-dev
```

**Windows:**
- 下载并安装 [RubyInstaller](https://rubyinstaller.org/)
- 安装时勾选 "Add Ruby executables to your PATH"

#### 2. 安装 Bundler

```bash
gem install bundler
```

#### 3. 克隆项目

```bash
git clone https://github.com/XGuider/XGuider.github.io.git
cd XGuider.github.io
```

#### 4. 安装依赖

```bash
bundle install
```

如果遇到依赖问题，可以尝试：
```bash
bundle update
```

#### 5. 启动本地服务器

```bash
bundle exec jekyll serve
```

或者使用以下命令启动（带实时重载和详细输出）：
```bash
bundle exec jekyll serve --livereload --verbose
```

访问 `http://localhost:4000` 查看博客。

#### 6. 本地开发常见问题

**问题1: 端口被占用**
```bash
# 指定其他端口
bundle exec jekyll serve --port 4001
```

**问题2: 依赖安装失败**
```bash
# 清理并重新安装
bundle clean --force
bundle install
```

**问题3: Jekyll 版本不兼容**
```bash
# 更新 Jekyll 和所有依赖
bundle update
```

**问题4: 构建错误**
```bash
# 清理缓存并重新构建
bundle exec jekyll clean
bundle exec jekyll build
```

## 📦 部署到 GitHub Pages

### 方法一：GitHub Pages 自动部署（推荐）

这是最简单的方法，GitHub 会自动构建和部署你的网站。

#### 步骤 1: 创建仓库

1. 登录 GitHub
2. 点击右上角的 "+" 号，选择 "New repository"
3. 仓库名必须为：`你的用户名.github.io`（例如：`XGuider.github.io`）
4. 设置为 Public（GitHub Pages 免费版需要公开仓库）
5. 点击 "Create repository"

#### 步骤 2: 推送代码

```bash
# 初始化 Git（如果还没有）
git init

# 添加远程仓库（替换为你的仓库地址）
git remote add origin https://github.com/XGuider/XGuider.github.io.git

# 添加所有文件
git add .

# 提交更改
git commit -m "Initial commit"

# 推送到 GitHub
git branch -M main
git push -u origin main
```

#### 步骤 3: 启用 GitHub Pages

1. 进入仓库页面
2. 点击 "Settings"（设置）
3. 在左侧菜单找到 "Pages"
4. 在 "Source" 部分，选择 "Deploy from a branch"
5. 选择分支：`main` 或 `master`
6. 选择文件夹：`/ (root)`
7. 点击 "Save"

#### 步骤 4: 等待部署

- GitHub 会在每次推送代码后自动构建和部署
- 通常需要 1-2 分钟完成部署
- 部署完成后，访问 `https://你的用户名.github.io` 即可看到网站

#### 步骤 5: 配置自定义域名（可选）

1. 在仓库根目录创建 `CNAME` 文件，内容为你的域名：
   ```
   example.com
   ```

2. 在域名 DNS 设置中添加 CNAME 记录：
   - 类型：CNAME
   - 主机记录：@ 或 www
   - 记录值：你的用户名.github.io

3. 在 GitHub Pages 设置中启用 "Enforce HTTPS"

### 方法二：使用 GitHub Actions 自动部署

如果需要更灵活的控制，可以使用 GitHub Actions：

1. 在项目根目录创建 `.github/workflows/jekyll.yml`：

```yaml
name: Jekyll site CI

on:
  push:
    branches:
      - main
  pull_request:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-ruby@v1
        with:
          ruby-version: '3.1'
      - name: Install dependencies
        run: |
          gem install bundler
          bundle install
      - name: Build site
        run: bundle exec jekyll build
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        if: github.ref == 'refs/heads/main'
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./_site
```

### 方法三：本地构建后手动部署

如果你需要本地构建后再部署：

```bash
# 1. 构建网站
bundle exec jekyll build

# 2. 进入构建目录
cd _site

# 3. 初始化 Git（如果还没有）
git init

# 4. 添加文件并提交
git add .
git commit -m "Deploy site"

# 5. 推送到 gh-pages 分支
git branch -M gh-pages
git remote add origin https://github.com/XGuider/XGuider.github.io.git
git push -u origin gh-pages
```

### GitHub Pages 部署常见问题

**问题1: 构建失败**
- 检查 `_config.yml` 中的插件是否在 GitHub Pages 支持列表中
- 查看 GitHub Actions 日志了解具体错误

**问题2: 样式或资源加载失败**
- 确保 `_config.yml` 中的 `baseurl` 配置正确
- 检查资源路径是否使用 `{{ site.baseurl }}`

**问题3: 更新后网站没有变化**
- 清除浏览器缓存
- 检查 GitHub Actions 是否成功完成
- 等待几分钟让 CDN 更新

**问题4: 自定义域名不生效**
- 检查 DNS 配置是否正确
- 确保 CNAME 文件在根目录
- 等待 DNS 传播（可能需要几小时）

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
```

### 评论系统

支持多种评论系统，在 `_config.yml` 中配置：

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

### 📄 使用 PDF/Word 文档

博客支持自动将 PDF 和 Word 文档转换为 Markdown 格式！

#### 快速开始

1. **安装 Pandoc**（如果尚未安装）：
   ```bash
   # macOS
   brew install pandoc
   
   # Linux
   sudo apt-get install pandoc
   ```

2. **放置文档**：
   将 PDF 或 Word 文件放在 `_posts/` 目录下：
   ```
   _posts/
     ├── 2024-01-15-文章标题.pdf
     └── 2024-01-15-文章标题.docx
   ```

3. **自动转换**：
   - 启动 Jekyll 服务器时，插件会自动转换文档
   - 或手动运行：`ruby scripts/convert_documents.rb`

4. **检查结果**：
   转换后会生成对应的 `.markdown` 文件，可以直接使用。

#### 详细说明

更多信息请查看 [文档转换功能说明](DOCUMENT_CONVERTER.md)

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

### 本地开发命令

```bash
# 启动本地服务器（默认端口 4000）
bundle exec jekyll serve

# 启动服务器并启用实时重载
bundle exec jekyll serve --livereload

# 指定端口启动
bundle exec jekyll serve --port 4001

# 在局域网中可访问（0.0.0.0）
bundle exec jekyll serve --host 0.0.0.0

# 显示详细输出
bundle exec jekyll serve --verbose
```

### 构建命令

```bash
# 构建网站到 _site 目录
bundle exec jekyll build

# 构建并显示详细输出
bundle exec jekyll build --verbose

# 构建时包含草稿
bundle exec jekyll build --drafts

# 构建时包含未来日期的文章
bundle exec jekyll build --future
```

### 清理和维护

```bash
# 清理 _site 目录和缓存
bundle exec jekyll clean

# 清理并重新构建
bundle exec jekyll clean && bundle exec jekyll build

# 更新所有依赖
bundle update

# 检查依赖
bundle check
```

### Git 相关命令

```bash
# 添加所有更改
git add .

# 提交更改
git commit -m "更新内容描述"

# 推送到 GitHub
git push origin main

# 查看状态
git status

# 查看提交历史
git log --oneline
```

## ⚡ 快速参考

### 首次部署检查清单

- [ ] 安装 Ruby 和 Bundler
- [ ] 克隆或下载项目
- [ ] 运行 `bundle install` 安装依赖
- [ ] 修改 `_config.yml` 中的个人信息
- [ ] 本地测试：`bundle exec jekyll serve`
- [ ] 创建 GitHub 仓库（用户名.github.io）
- [ ] 推送代码到 GitHub
- [ ] 在仓库设置中启用 GitHub Pages
- [ ] 等待部署完成，访问网站

### 日常更新流程

```bash
# 1. 创建新文章或修改内容
# 编辑 _posts/ 目录下的文件

# 2. 本地预览
bundle exec jekyll serve --livereload

# 3. 提交更改
git add .
git commit -m "更新：文章标题"
git push origin main

# 4. GitHub 自动部署（等待 1-2 分钟）
```

### 重要文件说明

- `_config.yml` - 网站配置文件，修改后需要重启服务器
- `_posts/` - 博客文章目录，文件名格式：`YYYY-MM-DD-title.markdown`
- `index.html` - 首页文件
- `about.html` - 关于页面
- `404.html` - 404 错误页面
- `Gemfile` - Ruby 依赖管理文件

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
