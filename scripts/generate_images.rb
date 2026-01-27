#!/usr/bin/env ruby
# frozen_string_literal: true

# 生成符合网站风格的图片脚本
# 使用 ImageMagick 生成渐变背景图片

require 'fileutils'

class ImageGenerator
  # 网站配色方案
  COLORS = {
    primary: '#3498db',      # 主蓝色
    secondary: '#2c3e50',    # 深灰蓝
    accent: '#ecf0f1',       # 浅灰
    dark: '#34495e',         # 深灰
    light: '#ffffff'         # 白色
  }.freeze

  IMAGES = [
    {
      name: 'home-bg-art.jpg',
      width: 1920,
      height: 1080,
      gradient: ['#3498db', '#2c3e50'],
      description: '首页背景 - 蓝色渐变'
    },
    {
      name: 'post-bg.jpg',
      width: 1920,
      height: 1080,
      gradient: ['#ecf0f1', '#bdc3c7'],
      description: '文章默认背景 - 浅灰渐变'
    },
    {
      name: '404-bg.jpg',
      width: 1920,
      height: 1080,
      gradient: ['#95a5a6', '#7f8c8d'],
      description: '404页面背景 - 灰色渐变'
    },
    {
      name: 'post-bg-alitrip.jpg',
      width: 1920,
      height: 1080,
      gradient: ['#3498db', '#2980b9'],
      description: '关于页面背景 - 深蓝渐变'
    }
  ].freeze

  def initialize
    @img_dir = 'img'
    @generated = []
    @failed = []
  end

  def generate_all
    puts "=" * 60
    puts "生成符合网站风格的图片"
    puts "=" * 60
    puts "\n网站风格: 现代、简洁、高级、蓝色系"
    puts "配色方案: #{COLORS[:primary]} (主色), #{COLORS[:secondary]} (辅色)\n"

    # 检查 ImageMagick 是否安装
    unless system('which convert > /dev/null 2>&1')
      puts "错误: ImageMagick 未安装"
      puts "请安装 ImageMagick:"
      puts "  macOS: brew install imagemagick"
      puts "  Linux: sudo apt-get install imagemagick"
      puts "\n或者使用在线工具生成图片后手动替换。"
      return
    end

    FileUtils.mkdir_p(@img_dir) unless Dir.exist?(@img_dir)

    IMAGES.each do |img|
      generate_image(img)
    end

    puts "\n" + "=" * 60
    puts "生成完成!"
    puts "=" * 60
    puts "成功: #{@generated.size}"
    puts "失败: #{@failed.size}"
    
    if @failed.size > 0
      puts "\n失败的图片:"
      @failed.each { |img| puts "  - #{img}" }
    end
  end

  private

  def generate_image(img_config)
    puts "\n生成: #{img_config[:name]} (#{img_config[:description]})..."
    
    file_path = File.join(@img_dir, img_config[:name])
    width = img_config[:width]
    height = img_config[:height]
    colors = img_config[:gradient]
    
    # ImageMagick 命令: 创建渐变背景
    # convert -size WxH gradient:color1-color2 output.jpg
    cmd = "convert -size #{width}x#{height} gradient:#{colors[0]}-#{colors[1]} \"#{file_path}\""
    
    if system(cmd)
      file_size = File.size(file_path)
      puts "  ✓ 成功 (#{(file_size / 1024.0).round(2)} KB)"
      @generated << img_config[:name]
    else
      puts "  ✗ 失败: ImageMagick 命令执行失败"
      @failed << img_config[:name]
    end
  rescue => e
    puts "  ✗ 错误: #{e.message}"
    @failed << img_config[:name]
  end
end

# 运行生成
if __FILE__ == $0
  generator = ImageGenerator.new
  generator.generate_all
end
