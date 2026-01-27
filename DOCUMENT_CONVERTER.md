# 文档转换功能说明

本博客支持自动将 PDF 和 Word 文档转换为 Markdown 格式，方便在博客中展示。

## 📋 功能特性

- ✅ 支持 PDF 文件（`.pdf`）
- ✅ 支持 Word 文档（`.docx`, `.doc`）
- ✅ 自动提取文档元数据
- ✅ 自动生成 Jekyll Front Matter
- ✅ 智能跳过已转换的文件（如果源文件未更新）

## 🚀 快速开始

### 1. 安装 Pandoc

文档转换功能依赖 [Pandoc](https://pandoc.org/) 工具。

#### macOS
```bash
brew install pandoc
```

#### Linux (Ubuntu/Debian)
```bash
sudo apt-get install pandoc
```

#### Windows
从 [Pandoc 官网](https://pandoc.org/installing.html) 下载安装程序。

### 2. 使用方式

#### 方式一：自动转换（推荐）

将 PDF 或 Word 文件放在 `_posts` 目录下，Jekyll 构建时会自动转换：

```bash
# 启动 Jekyll 服务器，插件会自动转换文档
bundle exec jekyll serve
```

#### 方式二：手动转换

使用转换脚本手动转换文档：

```bash
# 转换所有文档
ruby scripts/convert_documents.rb

# 或指定目录
ruby scripts/convert_documents.rb _posts
```

## 📝 文件命名规范

为了正确提取元数据，建议使用以下命名格式：

```
YYYY-MM-DD-文章标题.pdf
YYYY-MM-DD-文章标题.docx
```

例如：
- `2024-01-15-单点登录原理.pdf`
- `2024-01-15-单点登录原理.docx`

如果不使用日期前缀，系统会使用当前日期。

## 📄 转换后的文件格式

转换后的 Markdown 文件会自动包含 Jekyll Front Matter：

```markdown
---
layout: post
title: "文章标题"
date: 2024-01-15 00:00:00
author: XGuider
header-img: img/post-bg.jpg
tags: []
---

转换后的文档内容...
```

## ⚙️ 自定义配置

### 修改默认元数据

编辑 `_plugins/document_converter.rb` 或 `scripts/convert_documents.rb` 中的 `extract_metadata` 方法：

```ruby
def extract_metadata(file_path, file_name)
  metadata = {
    'layout' => 'post',
    'title' => file_name,
    'date' => Time.now.strftime('%Y-%m-%d %H:%M:%S'),
    'author' => 'XGuider',  # 修改默认作者
    'header-img' => 'img/post-bg.jpg',  # 修改默认头图
    'tags' => []  # 添加默认标签
  }
  # ...
end
```

### 添加标签

在文件名中包含标签信息，或手动编辑转换后的 Markdown 文件添加标签。

## 🔧 高级用法

### 批量转换

```bash
# 转换所有 PDF 文件
find _posts -name "*.pdf" -exec ruby scripts/convert_documents.rb {} \;

# 转换所有 Word 文件
find _posts -name "*.docx" -exec ruby scripts/convert_documents.rb {} \;
```

### 强制重新转换

删除对应的 `.markdown` 文件，然后重新运行转换：

```bash
# 删除所有转换后的文件
find _posts -name "*.markdown" -delete

# 重新转换
ruby scripts/convert_documents.rb
```

## ⚠️ 注意事项

1. **GitHub Pages 限制**：GitHub Pages 不支持自定义 Jekyll 插件，因此：
   - 本地开发时可以使用自动转换插件
   - 部署到 GitHub Pages 前，需要先手动转换文档
   - 建议将转换后的 `.markdown` 文件提交到 Git

2. **PDF 转换质量**：PDF 转换质量可能不如 Word 文档，因为：
   - PDF 是固定格式，提取文本可能不完整
   - 复杂的 PDF 布局可能无法完美转换
   - 建议优先使用 Word 文档

3. **文件大小**：大文件转换可能需要较长时间，请耐心等待。

4. **编码问题**：如果文档包含特殊字符，确保文档使用 UTF-8 编码。

## 🐛 故障排除

### Pandoc 未找到

```
错误: pandoc 未安装
```

**解决方案**：按照上述说明安装 Pandoc。

### 转换失败

```
错误: 转换失败
```

**可能原因**：
- 文件损坏或格式不支持
- Pandoc 版本过低
- 文件路径包含特殊字符

**解决方案**：
- 检查文件是否完整
- 更新 Pandoc 到最新版本
- 使用简单的文件名（避免特殊字符）

### 转换后内容为空

**可能原因**：
- PDF 是扫描版（图片格式）
- 文档受密码保护
- Pandoc 无法识别文档格式

**解决方案**：
- 使用 OCR 工具提取文本
- 移除文档密码
- 尝试使用其他转换工具

## 📚 相关资源

- [Pandoc 官方文档](https://pandoc.org/)
- [Jekyll 文档](https://jekyllrb.com/)
- [Markdown 语法指南](https://www.markdownguide.org/)

## 💡 最佳实践

1. **使用 Word 文档**：Word 文档转换质量更好
2. **规范命名**：使用日期前缀便于管理
3. **手动检查**：转换后检查内容是否正确
4. **添加标签**：转换后手动添加合适的标签
5. **版本控制**：将转换后的 Markdown 文件提交到 Git

---

**提示**：如果遇到问题，请查看 Jekyll 构建日志获取详细错误信息。
