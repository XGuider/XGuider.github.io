# 脚本说明

## convert_documents.rb

文档转换脚本，用于将 PDF 和 Word 文档转换为 Markdown 格式。

### 使用方法

```bash
# 转换 _posts 目录下的所有文档
ruby scripts/convert_documents.rb

# 转换指定目录下的文档
ruby scripts/convert_documents.rb /path/to/documents
```

### 功能

- 自动检测 PDF 和 Word 文件（`.pdf`, `.docx`, `.doc`）
- 使用 Pandoc 进行格式转换
- 自动生成 Jekyll Front Matter
- 智能跳过已转换的文件（如果源文件未更新）
- 从文件名提取日期和标题信息

### 输出

转换后的文件会保存在同一目录下，文件名格式：`原文件名.markdown`

### 注意事项

- 需要安装 Pandoc
- 文件名建议使用格式：`YYYY-MM-DD-标题.pdf`
- 转换后的文件需要手动检查并调整
