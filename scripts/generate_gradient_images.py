#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
生成符合网站风格的渐变背景图片
使用 PIL/Pillow 库生成渐变背景
"""

import os
import sys
from PIL import Image, ImageDraw

# 网站配色方案
COLORS = {
    'primary': '#3498db',      # 主蓝色
    'secondary': '#2c3e50',    # 深灰蓝
    'accent': '#ecf0f1',       # 浅灰
    'dark': '#34495e',         # 深灰
    'light': '#ffffff'         # 白色
}

# 需要生成的图片配置
IMAGES = [
    {
        'name': 'home-bg-art.jpg',
        'width': 1920,
        'height': 1080,
        'gradient': ['#3498db', '#2c3e50'],
        'direction': 'vertical',  # vertical 或 horizontal
        'description': '首页背景 - 蓝色渐变'
    },
    {
        'name': 'post-bg.jpg',
        'width': 1920,
        'height': 1080,
        'gradient': ['#ecf0f1', '#bdc3c7'],
        'direction': 'vertical',
        'description': '文章默认背景 - 浅灰渐变'
    },
    {
        'name': '404-bg.jpg',
        'width': 1920,
        'height': 1080,
        'gradient': ['#95a5a6', '#7f8c8d'],
        'direction': 'vertical',
        'description': '404页面背景 - 灰色渐变'
    },
    {
        'name': 'post-bg-alitrip.jpg',
        'width': 1920,
        'height': 1080,
        'gradient': ['#3498db', '#2980b9'],
        'direction': 'vertical',
        'description': '关于页面背景 - 深蓝渐变'
    }
]


def hex_to_rgb(hex_color):
    """将十六进制颜色转换为RGB元组"""
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))


def create_gradient_image(width, height, color1, color2, direction='vertical'):
    """创建渐变图片"""
    # 创建新图片
    img = Image.new('RGB', (width, height))
    draw = ImageDraw.Draw(img)
    
    # 转换颜色
    rgb1 = hex_to_rgb(color1)
    rgb2 = hex_to_rgb(color2)
    
    if direction == 'vertical':
        # 垂直渐变
        for y in range(height):
            # 计算当前行的颜色
            ratio = y / height
            r = int(rgb1[0] * (1 - ratio) + rgb2[0] * ratio)
            g = int(rgb1[1] * (1 - ratio) + rgb2[1] * ratio)
            b = int(rgb1[2] * (1 - ratio) + rgb2[2] * ratio)
            color = (r, g, b)
            # 绘制一行
            draw.line([(0, y), (width, y)], fill=color)
    else:
        # 水平渐变
        for x in range(width):
            # 计算当前列的颜色
            ratio = x / width
            r = int(rgb1[0] * (1 - ratio) + rgb2[0] * ratio)
            g = int(rgb1[1] * (1 - ratio) + rgb2[1] * ratio)
            b = int(rgb1[2] * (1 - ratio) + rgb2[2] * ratio)
            color = (r, g, b)
            # 绘制一列
            draw.line([(x, 0), (x, height)], fill=color)
    
    return img


def main():
    """主函数"""
    print("=" * 60)
    print("生成符合网站风格的渐变背景图片")
    print("=" * 60)
    print("\n网站风格: 现代、简洁、高级、蓝色系")
    print(f"配色方案: {COLORS['primary']} (主色), {COLORS['secondary']} (辅色)\n")
    
    # 检查 Pillow 是否安装
    try:
        from PIL import Image, ImageDraw
    except ImportError:
        print("错误: Pillow 未安装")
        print("请安装 Pillow:")
        print("  pip3 install Pillow")
        print("  或")
        print("  pip install Pillow")
        sys.exit(1)
    
    # 创建输出目录
    img_dir = 'img'
    if not os.path.exists(img_dir):
        os.makedirs(img_dir)
    
    generated = []
    failed = []
    
    for img_config in IMAGES:
        print(f"\n生成: {img_config['name']} ({img_config['description']})...")
        
        try:
            # 创建渐变图片
            img = create_gradient_image(
                img_config['width'],
                img_config['height'],
                img_config['gradient'][0],
                img_config['gradient'][1],
                img_config['direction']
            )
            
            # 保存图片
            file_path = os.path.join(img_dir, img_config['name'])
            img.save(file_path, 'JPEG', quality=90, optimize=True)
            
            file_size = os.path.getsize(file_path)
            print(f"  ✓ 成功 ({(file_size / 1024.0):.2f} KB)")
            generated.append(img_config['name'])
            
        except Exception as e:
            print(f"  ✗ 错误: {e}")
            failed.append(img_config['name'])
    
    print("\n" + "=" * 60)
    print("生成完成!")
    print("=" * 60)
    print(f"成功: {len(generated)}")
    print(f"失败: {len(failed)}")
    
    if failed:
        print("\n失败的图片:")
        for img in failed:
            print(f"  - {img}")


if __name__ == '__main__':
    main()
