#!/usr/bin/env python3
"""
生成极客风格的背景图片
符合新的深色主题和代码编辑器风格
"""

from PIL import Image, ImageDraw, ImageFont
import os
import math

# 颜色定义（与设计文件中的颜色一致）
COLORS = {
    'bg_dark': '#0D1117',      # 主背景色
    'bg_darker': '#161B22',    # 代码块背景
    'border': '#21262D',        # 边框色
    'accent_blue': '#58A6FF',   # 蓝色强调
    'accent_purple': '#7C3AED', # 紫色强调
    'accent_red': '#DC2626',   # 红色（错误页）
    'text_muted': '#6E7681',    # 灰色文本
}

def hex_to_rgb(hex_color):
    """将十六进制颜色转换为RGB元组"""
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def create_geek_gradient(width, height, color1, color2, direction='vertical'):
    """创建渐变背景"""
    img = Image.new('RGB', (width, height), hex_to_rgb(color1))
    draw = ImageDraw.Draw(img)
    
    steps = height if direction == 'vertical' else width
    rgb1 = hex_to_rgb(color1)
    rgb2 = hex_to_rgb(color2)
    
    for i in range(steps):
        ratio = i / steps
        r = int(rgb1[0] * (1 - ratio) + rgb2[0] * ratio)
        g = int(rgb1[1] * (1 - ratio) + rgb2[1] * ratio)
        b = int(rgb1[2] * (1 - ratio) + rgb2[2] * ratio)
        
        if direction == 'vertical':
            draw.rectangle([(0, i), (width, i+1)], fill=(r, g, b))
        else:
            draw.rectangle([(i, 0), (i+1, height)], fill=(r, g, b))
    
    return img, draw

def add_code_pattern(img, draw, color, opacity=0.1):
    """添加代码风格的图案"""
    width, height = img.size
    pattern_color = (*hex_to_rgb(color), int(255 * opacity))
    
    # 创建临时图像用于图案
    pattern_img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pattern_draw = ImageDraw.Draw(pattern_img)
    
    # 添加网格线
    grid_spacing = 40
    for x in range(0, width, grid_spacing):
        pattern_draw.line([(x, 0), (x, height)], fill=pattern_color, width=1)
    for y in range(0, height, grid_spacing):
        pattern_draw.line([(0, y), (width, y)], fill=pattern_color, width=1)
    
    # 添加一些随机的代码行效果
    line_spacing = 20
    for y in range(0, height, line_spacing):
        if y % 60 == 0:  # 每3行一条长线
            pattern_draw.line([(50, y), (width - 50, y)], fill=pattern_color, width=1)
        elif y % 40 == 0:  # 每2行一条中线
            pattern_draw.line([(100, y), (width - 100, y)], fill=pattern_color, width=1)
    
    # 添加一些点状图案（模拟代码中的点）
    dot_spacing = 60
    for x in range(100, width - 100, dot_spacing):
        for y in range(100, height - 100, dot_spacing):
            if (x + y) % 120 == 0:  # 随机分布
                pattern_draw.ellipse([x-1, y-1, x+1, y+1], fill=pattern_color)
    
    # 合并图案到主图像
    img.paste(pattern_img, (0, 0), pattern_img)
    return img, draw

def add_geometric_shapes(img, draw, accent_color, opacity=0.15):
    """添加几何形状装饰"""
    width, height = img.size
    shape_color = (*hex_to_rgb(accent_color), int(255 * opacity))
    
    # 创建临时图像用于形状
    shape_img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    shape_draw = ImageDraw.Draw(shape_img)
    
    # 添加一些矩形框（模拟代码块）
    box_width = 200
    box_height = 30
    spacing = 150
    
    for y in range(100, height - 100, spacing):
        x_offset = (y % (spacing * 2)) * 0.3
        x = int(50 + x_offset)
        shape_draw.rectangle(
            [x, y, x + box_width, y + box_height],
            outline=shape_color,
            width=2
        )
    
    # 添加一些三角形（模拟箭头）
    triangle_size = 20
    for x in range(200, width - 200, 300):
        for y in range(150, height - 150, 200):
            if (x + y) % 400 == 0:
                points = [
                    (x, y),
                    (x + triangle_size, y),
                    (x + triangle_size // 2, y - triangle_size)
                ]
                shape_draw.polygon(points, outline=shape_color, width=2)
    
    # 合并形状到主图像
    img.paste(shape_img, (0, 0), shape_img)
    return img, draw

def generate_home_bg():
    """生成主页背景图"""
    width, height = 1920, 600
    img, draw = create_geek_gradient(width, height, COLORS['bg_dark'], COLORS['bg_darker'])
    img, draw = add_code_pattern(img, draw, COLORS['accent_blue'], opacity=0.08)
    img, draw = add_geometric_shapes(img, draw, COLORS['accent_blue'], opacity=0.12)
    return img

def generate_about_bg():
    """生成关于页背景图"""
    width, height = 1920, 600
    img, draw = create_geek_gradient(width, height, COLORS['accent_purple'], COLORS['bg_dark'])
    img, draw = add_code_pattern(img, draw, COLORS['accent_purple'], opacity=0.1)
    img, draw = add_geometric_shapes(img, draw, COLORS['accent_purple'], opacity=0.15)
    return img

def generate_post_bg():
    """生成文章页背景图"""
    width, height = 1920, 600
    img, draw = create_geek_gradient(width, height, COLORS['bg_darker'], COLORS['bg_dark'])
    img, draw = add_code_pattern(img, draw, COLORS['text_muted'], opacity=0.06)
    img, draw = add_geometric_shapes(img, draw, COLORS['text_muted'], opacity=0.1)
    return img

def generate_404_bg():
    """生成404页背景图"""
    width, height = 1920, 600
    img, draw = create_geek_gradient(width, height, COLORS['accent_red'], COLORS['bg_dark'])
    img, draw = add_code_pattern(img, draw, COLORS['accent_red'], opacity=0.12)
    img, draw = add_geometric_shapes(img, draw, COLORS['accent_red'], opacity=0.18)
    return img

def generate_favicon():
    """生成网站图标"""
    size = 64
    img = Image.new('RGB', (size, size), hex_to_rgb(COLORS['bg_dark']))
    draw = ImageDraw.Draw(img)
    
    # 绘制一个简单的终端提示符 ">"
    try:
        # 尝试使用系统字体
        font_size = 40
        font = ImageFont.truetype("/System/Library/Fonts/Menlo.ttc", font_size)
    except:
        try:
            font = ImageFont.truetype("/System/Library/Fonts/Courier New.ttf", font_size)
        except:
            font = ImageFont.load_default()
    
    # 绘制 ">" 符号
    text = ">"
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    x = (size - text_width) // 2
    y = (size - text_height) // 2 - 2
    
    draw.text((x, y), text, fill=hex_to_rgb(COLORS['accent_blue']), font=font)
    
    return img

def main():
    """主函数"""
    # 获取脚本所在目录的父目录（项目根目录）
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)
    img_dir = os.path.join(project_root, 'img')
    
    # 确保 img 目录存在
    os.makedirs(img_dir, exist_ok=True)
    
    print("正在生成极客风格背景图片...")
    
    # 生成各种背景图
    print("1. 生成主页背景图 (home-bg-art.jpg)...")
    home_bg = generate_home_bg()
    home_bg.save(os.path.join(img_dir, 'home-bg-art.jpg'), 'JPEG', quality=85)
    print("   ✓ 完成")
    
    print("2. 生成关于页背景图 (post-bg-alitrip.jpg)...")
    about_bg = generate_about_bg()
    about_bg.save(os.path.join(img_dir, 'post-bg-alitrip.jpg'), 'JPEG', quality=85)
    print("   ✓ 完成")
    
    print("3. 生成文章页背景图 (post-bg.jpg)...")
    post_bg = generate_post_bg()
    post_bg.save(os.path.join(img_dir, 'post-bg.jpg'), 'JPEG', quality=85)
    print("   ✓ 完成")
    
    print("4. 生成404页背景图 (404-bg.jpg)...")
    error_bg = generate_404_bg()
    error_bg.save(os.path.join(img_dir, '404-bg.jpg'), 'JPEG', quality=85)
    print("   ✓ 完成")
    
    print("5. 生成网站图标 (favicon.ico)...")
    favicon = generate_favicon()
    # 保存为 PNG 然后转换为 ICO（PIL 不直接支持 ICO，先保存为 PNG）
    favicon_png = os.path.join(img_dir, 'favicon.png')
    favicon.save(favicon_png, 'PNG')
    
    # 尝试创建 ICO 文件（需要安装 pillow 的额外支持）
    try:
        # 创建多个尺寸的图标
        sizes = [(16, 16), (32, 32), (48, 48), (64, 64)]
        favicon_ico = Image.new('RGBA', (64, 64), (0, 0, 0, 0))
        favicon_ico.paste(favicon, (0, 0))
        favicon_ico.save(os.path.join(img_dir, 'favicon.ico'), format='ICO', sizes=sizes)
        os.remove(favicon_png)  # 删除临时 PNG 文件
        print("   ✓ 完成")
    except Exception as e:
        print(f"   ⚠ ICO 生成失败，已保存为 PNG: {e}")
        print(f"   请手动将 {favicon_png} 转换为 favicon.ico")
    
    print("\n所有图片生成完成！")
    print(f"图片保存在: {img_dir}")

if __name__ == '__main__':
    main()
