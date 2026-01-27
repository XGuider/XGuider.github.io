#!/usr/bin/env ruby
# frozen_string_literal: true

# 分析图片使用情况的脚本

require 'find'
require 'set'

class ImageAnalyzer
  def initialize
    @img_dir = 'img'
    @used_images = Set.new
    @all_images = Set.new
  end

  def analyze
    # 收集所有图片文件
    Find.find(@img_dir) do |path|
      next unless File.file?(path)
      ext = File.extname(path).downcase
      if ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.ico'].include?(ext)
        @all_images.add(path)
      end
    end

    # 在代码中查找图片引用
    search_directories = ['_posts', '_layouts', '_includes', '_videos', '.', '_config.yml']
    
    search_directories.each do |dir|
      next unless Dir.exist?(dir) || File.exist?(dir)
      
      if File.directory?(dir)
        Find.find(dir) do |path|
          next unless File.file?(path)
          next if path.include?('.git')
          next if path.include?('node_modules')
          
          analyze_file(path)
        end
      else
        analyze_file(dir)
      end
    end

    # 输出结果
    puts "=" * 60
    puts "图片使用情况分析"
    puts "=" * 60
    puts "\n使用的图片 (#{@used_images.size}):"
    @used_images.sort.each do |img|
      puts "  ✓ #{img}"
    end

    unused = @all_images - @used_images
    puts "\n未使用的图片 (#{unused.size}):"
    unused.sort.each do |img|
      puts "  ✗ #{img}"
    end

    puts "\n总计: #{@all_images.size} 张图片"
    puts "  使用中: #{@used_images.size}"
    puts "  未使用: #{unused.size}"
    
    # 生成清理脚本
    if unused.size > 0
      puts "\n生成清理脚本..."
      generate_cleanup_script(unused)
    end
  end

  private

  def analyze_file(file_path)
    return unless File.readable?(file_path)
    
    content = File.read(file_path)
    
    # 查找图片引用 - 改进的正则表达式
    patterns = [
      # header-img: "img/xxx.jpg" 或 header-img: img/xxx.jpg
      /header-img:\s*["']?([^"'\s\n]+\.(jpg|jpeg|png|gif|webp|ico))/i,
      # background-image: url('img/xxx.jpg')
      /background-image:\s*url\(['"]?([^'")]+\.(jpg|jpeg|png|gif|webp|ico))/i,
      # src="img/xxx.jpg" 或 src='/img/xxx.jpg'
      /src=["']([^"']+\.(jpg|jpeg|png|gif|webp|ico))/i,
      # img/xxx.jpg 直接引用
      /img\/[^\s"'\n<>]+\.(jpg|jpeg|png|gif|webp|ico)/i,
      # /img/xxx.jpg 绝对路径
      /\/img\/[^\s"'\n<>]+\.(jpg|jpeg|png|gif|webp|ico)/i
    ]
    
    patterns.each do |pattern|
      content.scan(pattern) do |match|
        img_path = match.is_a?(Array) ? match[0] : match
        next unless img_path
        img_path = img_path.strip
        
        # 标准化路径
        normalized_path = nil
        if img_path.start_with?('img/')
          normalized_path = img_path
        elsif img_path.start_with?('/img/')
          normalized_path = img_path[1..-1]
        elsif img_path.start_with?('./img/')
          normalized_path = img_path[2..-1]
        elsif img_path.include?('img/')
          # 提取 img/ 之后的部分
          normalized_path = img_path[img_path.index('img/')..-1]
        end
        
        if normalized_path
          @used_images.add(normalized_path)
        end
        
        # 通过文件名匹配现有图片
        filename = File.basename(img_path)
        @all_images.each do |img|
          if File.basename(img) == filename
            @used_images.add(img)
          end
        end
      end
    end
  rescue => e
    # 忽略无法读取的文件
    # puts "Warning: Could not read #{file_path}: #{e.message}"
  end

  def generate_cleanup_script(unused_images)
    script_content = "#!/bin/bash\n# 自动生成的图片清理脚本\n\n"
    script_content += "echo '开始清理未使用的图片...'\n\n"
    
    unused_images.each do |img|
      script_content += "rm -f \"#{img}\"\n"
      script_content += "echo '删除: #{img}'\n"
    end
    
    script_content += "\necho '清理完成!'\n"
    
    File.write('scripts/cleanup_unused_images.sh', script_content)
    File.chmod(0755, 'scripts/cleanup_unused_images.sh')
    puts "清理脚本已生成: scripts/cleanup_unused_images.sh"
  end
end

# 运行分析
if __FILE__ == $0
  analyzer = ImageAnalyzer.new
  analyzer.analyze
end
