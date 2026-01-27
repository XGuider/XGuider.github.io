#!/bin/bash
# 清理未使用的图片脚本
# 基于实际代码分析，以下图片未被使用

echo "开始清理未使用的图片..."
echo ""

# 根据代码分析，以下图片被使用，需要保留：
# - img/home-bg-art.jpg (首页背景)
# - img/post-bg-alitrip.jpg (关于页面)
# - img/404-bg.jpg (404页面)
# - img/icon_wechat1.png (微信图标)
# - img/favicon.ico (网站图标)

# 未使用的图片（可以安全删除）
UNUSED_IMAGES=(
  "img/post-bg-kuaidi.jpg"
  "img/post-bg-js-module.jpg"
  "img/post-bg-js-version.jpg"
  "img/post-bg-e2e-ux.jpg"
  "img/post-bg-ios9-web.jpg"
  "img/post-bg-apple-event-2015.jpg"
  "img/post-bg-digital-native.jpg"
  "img/post-bg-android.jpg"
  "img/post-bg-alibaba.jpg"
  "img/post-bg-2015.jpg"
  "img/home-bg-geek.jpg"
  "img/home-bg-o.jpg"
  "img/home-bg.jpg"
)

echo "将删除以下未使用的图片:"
for img in "${UNUSED_IMAGES[@]}"; do
  if [ -f "$img" ]; then
    echo "  - $img"
  fi
done

echo ""
read -p "确认删除? (y/N): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
  deleted=0
  for img in "${UNUSED_IMAGES[@]}"; do
    if [ -f "$img" ]; then
      rm -f "$img"
      echo "删除: $img"
      ((deleted++))
    fi
  done
  echo ""
  echo "清理完成! 共删除 $deleted 个文件"
else
  echo "取消操作"
fi
