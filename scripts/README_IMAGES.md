# 图片管理脚本说明

## 📋 可用脚本

### 1. `analyze_images.rb` - 分析图片使用情况

分析代码中引用的图片，找出未使用的图片。

```bash
ruby scripts/analyze_images.rb
```

**输出**:
- 使用的图片列表
- 未使用的图片列表
- 自动生成清理脚本

### 2. `generate_gradient_images.py` - 生成渐变背景图片

使用 Python 和 Pillow 库生成符合网站风格的渐变背景图片。

**前置要求**:
```bash
pip3 install Pillow
```

**使用方法**:
```bash
python3 scripts/generate_gradient_images.py
```

**生成的文件**:
- `img/home-bg-art.jpg` - 首页背景（蓝色渐变）
- `img/post-bg.jpg` - 文章默认背景（浅灰渐变）
- `img/404-bg.jpg` - 404页面背景（灰色渐变）
- `img/post-bg-alitrip.jpg` - 关于页面背景（深蓝渐变）

### 3. `cleanup_images.sh` - 清理未使用的图片

删除代码中未引用的图片文件。

**使用方法**:
```bash
./scripts/cleanup_images.sh
```

**注意**: 脚本会询问确认，确认后才会删除文件。

### 4. `generate_images.rb` - 使用 ImageMagick 生成图片

使用 ImageMagick 生成渐变背景（需要安装 ImageMagick）。

**前置要求**:
```bash
# macOS
brew install imagemagick

# Linux
sudo apt-get install imagemagick
```

**使用方法**:
```bash
ruby scripts/generate_images.rb
```

## 🎨 图片风格

所有生成的图片都符合网站的设计风格：

- **配色**: 蓝色系（#3498db, #2c3e50）
- **风格**: 现代、简洁、高级
- **尺寸**: 1920x1080
- **格式**: JPG
- **大小**: < 30KB（优化后）

## 📝 使用流程

### 快速开始

1. **生成新图片**:
   ```bash
   python3 scripts/generate_gradient_images.py
   ```

2. **清理旧图片**（可选）:
   ```bash
   ./scripts/cleanup_images.sh
   ```

3. **测试网站**:
   ```bash
   bundle exec jekyll serve
   ```

### 完整流程

1. **分析当前图片使用情况**:
   ```bash
   ruby scripts/analyze_images.rb
   ```

2. **备份现有图片**（可选）:
   ```bash
   cp -r img img_backup
   ```

3. **生成新图片**:
   ```bash
   python3 scripts/generate_gradient_images.py
   ```

4. **清理未使用的图片**:
   ```bash
   ./scripts/cleanup_images.sh
   ```

5. **测试网站**:
   ```bash
   bundle exec jekyll serve
   ```

## ⚠️ 注意事项

1. **备份**: 删除图片前建议先备份
2. **测试**: 替换图片后务必测试所有页面
3. **版权**: 如果使用外部图片，确保有使用许可
4. **优化**: 生成后可以使用在线工具进一步压缩

## 🔧 故障排除

### Pillow 未安装

```bash
pip3 install Pillow
# 或
pip install Pillow
```

### ImageMagick 未安装

```bash
# macOS
brew install imagemagick

# Linux
sudo apt-get install imagemagick
```

### 图片生成失败

1. 检查 Python 版本（需要 Python 3.6+）
2. 确认 Pillow 已正确安装
3. 检查 img 目录权限

## 📚 相关文档

- [图片管理指南](IMAGE_GUIDE.md) - 详细的图片管理说明
- [网站风格说明](../README.md) - 网站整体设计风格
