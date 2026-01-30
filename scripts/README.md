# 文档转换工具

自动将 PDF 和 Word 文档转换为 Jekyll Markdown 格式。

## 功能

- 支持 `.pdf`、`.docx`、`.doc` 格式
- 自动提取文件名中的日期和分类
- 生成 Jekyll 格式的 YAML Front Matter
- 智能跳过已是最新的文件

## 自动转换方式

### 方式一：GitHub Actions 自动转换（推荐）

已配置在 `.github/workflows/jekyll.yml`，推送代码时自动：
1. 安装 pandoc
2. 运行转换脚本
3. 构建 Jekyll 站点
4. 部署到 GitHub Pages

### 方式二：本地 Git 钩子

设置预提交钩子，每次提交前自动转换：

```bash
./scripts/setup-git-hooks.sh
```

### 方式三：手动转换

```bash
ruby scripts/convert_documents.rb
```

## 文件名格式

转换脚本从文件名提取元数据：

```
YYYY-MM-DD-CATEGORY-标题.pdf
```

示例：
- `2026-01-07-JAVA-Spring实战.docx`
  - 日期：2026-01-07
  - 分类：JAVA
  - 标题：Spring实战

## 依赖

- Ruby 2.6+
- [Pandoc](https://pandoc.org/installing.html)

安装 pandoc：
```bash
# macOS
brew install pandoc

# Ubuntu/Debian
sudo apt-get install pandoc

# Windows
# 下载安装包：https://github.com/jgm/pandoc/releases
```

## 配置

在 `_config.yml` 中排除原始文档：

```yaml
exclude:
  - "_posts/*.docx"
  - "_posts/*.doc"
  - "_posts/*.pdf"
```

这样 GitHub Pages 不会处理原始文档，只使用转换后的 `.markdown` 文件。
