#!/bin/bash
# 设置 Git 预提交钩子

HOOK_FILE=".git/hooks/pre-commit"

# 创建钩子文件
cat > "$HOOK_FILE" << 'EOF'
#!/bin/bash
# 预提交钩子：自动转换文档

echo "检查并转换文档..."

# 检查 pandoc 是否安装
if ! command -v pandoc &> /dev/null; then
    echo "警告: pandoc 未安装，跳过文档转换"
    echo "请安装 pandoc: https://pandoc.org/installing.html"
    exit 0
fi

# 运行转换脚本
if [ -f "scripts/convert_documents.rb" ]; then
    ruby scripts/convert_documents.rb

    # 添加新生成的 markdown 文件
    git add _posts/*.markdown 2>/dev/null || true
fi

exit 0
EOF

# 赋予执行权限
chmod +x "$HOOK_FILE"

echo "Git 预提交钩子已设置完成！"
echo "每次提交前会自动运行转换脚本。"
