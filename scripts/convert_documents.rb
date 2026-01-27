#!/usr/bin/env ruby
# frozen_string_literal: true

# 独立的文档转换脚本
# 使用方法: ruby scripts/convert_documents.rb

require 'fileutils'
require 'tempfile'

class DocumentConverter
  def initialize(posts_dir = '_posts')
    @posts_dir = posts_dir
    @converted_count = 0
    @skipped_count = 0
    @error_count = 0
  end

  def convert_all
    unless Dir.exist?(@posts_dir)
      puts "错误: 目录 #{@posts_dir} 不存在"
      return
    end

    # 检查 pandoc
    unless system('which pandoc > /dev/null 2>&1')
      puts "错误: pandoc 未安装"
      puts "请安装 pandoc:"
      puts "  macOS: brew install pandoc"
      puts "  Linux: sudo apt-get install pandoc"
      puts "  Windows: 从 https://pandoc.org/installing.html 下载安装"
      return
    end

    puts "开始转换文档..."
    puts "=" * 50

    # 查找所有 PDF 和 Word 文件
    pdf_files = Dir.glob(File.join(@posts_dir, '*.pdf'))
    word_files = Dir.glob(File.join(@posts_dir, '*.docx')) + 
                 Dir.glob(File.join(@posts_dir, '*.doc'))

    pdf_files.each { |f| convert_document(f, 'pdf') }
    word_files.each { |f| convert_document(f, 'word') }

    puts "=" * 50
    puts "转换完成!"
    puts "  成功: #{@converted_count}"
    puts "  跳过: #{@skipped_count}"
    puts "  错误: #{@error_count}"
  end

  private

  def convert_document(file_path, type)
    file_name = File.basename(file_path, File.extname(file_path))
    markdown_path = File.join(@posts_dir, "#{file_name}.markdown")
    
    # 如果 Markdown 文件已存在且比源文件新，跳过
    if File.exist?(markdown_path) && File.mtime(markdown_path) > File.mtime(file_path)
      puts "跳过: #{file_name} (Markdown 文件已是最新)"
      @skipped_count += 1
      return
    end
    
    puts "转换: #{file_name}..."
    
    # 提取元数据
    metadata = extract_metadata(file_path, file_name)
    
    # 使用 pandoc 转换
    temp_md = Tempfile.new(['converted', '.md'])
    success = false
    
    begin
      if type == 'pdf'
        # PDF 转换
        success = system("pandoc -f pdf -t markdown \"#{file_path}\" -o \"#{temp_md.path}\" 2>/dev/null") ||
                  system("pandoc -f pdf+raw_html -t markdown \"#{file_path}\" -o \"#{temp_md.path}\" 2>/dev/null")
      else
        # Word 转换
        success = system("pandoc -f docx -t markdown \"#{file_path}\" -o \"#{temp_md.path}\"")
      end
      
      unless success && File.exist?(temp_md.path) && File.size(temp_md.path) > 0
        puts "  错误: 转换失败"
        @error_count += 1
        return
      end
      
      # 读取内容
      content = File.read(temp_md.path)
      
      # 创建 Jekyll 格式的 Markdown
      front_matter = build_front_matter(metadata, file_path)
      markdown_content = front_matter + "\n\n" + content
      
      # 写入文件
      File.write(markdown_path, markdown_content)
      puts "  成功: #{file_name}.markdown"
      @converted_count += 1
      
    rescue => e
      puts "  错误: #{e.message}"
      @error_count += 1
    ensure
      temp_md.close
      temp_md.unlink
    end
  end

  def extract_metadata(file_path, file_name)
    # 从文件名提取日期、分类和标题
    # 格式: YYYY-MM-DD-CATEGORY-title.pdf
    # 例如: 2024-01-15-JAVA-Spring实战.docx
    #      2026-01-07-JAVA-Spring实战.docx
    date_match = file_name.match(/^(\d{4}-\d{2}-\d{2})-(.+)$/)
    
    metadata = {
      'layout' => 'post',
      'title' => file_name,
      'date' => Time.now.strftime('%Y-%m-%d %H:%M:%S'),
      'author' => 'XGuider',
      'header-img' => 'img/post-bg.jpg',
      'tags' => [],
      'categories' => []
    }
    
    if date_match
      date_str = date_match[1]
      rest = date_match[2]
      
      # 尝试提取分类（格式：CATEGORY-标题）
      # 分类通常是全大写的单词，如 JAVA, SPRING, PYTHON, SPRING-BOOT 等
      # 支持连字符分隔的分类，如 SPRING-BOOT, JAVA-SPRING 等
      # 匹配模式：一个或多个大写字母/数字/连字符的组合，后面跟连字符和标题
      category_match = rest.match(/^([A-Z0-9]+(?:-[A-Z0-9]+)*?)-(.+)$/)
      
      if category_match
        category = category_match[1]
        title = category_match[2]
        
        metadata['date'] = "#{date_str} 00:00:00"
        metadata['categories'] = [category]
        # 标题处理：将连字符替换为空格，保留中文
        metadata['title'] = title.gsub(/-/u, ' ').strip
      else
        # 没有分类，只有标题
        metadata['date'] = "#{date_str} 00:00:00"
        # 标题处理：将连字符替换为空格
        metadata['title'] = rest.gsub(/-/u, ' ').strip
      end
    end
    
    metadata
  end

  def build_front_matter(metadata, file_path)
    front_matter = "---\n"
    metadata.each do |key, value|
      if value.is_a?(Array)
        front_matter += "#{key}:\n"
        value.each { |v| front_matter += "    - #{v}\n" }
      else
        front_matter += "#{key}: #{value.inspect}\n"
      end
    end
    front_matter += "---"
    front_matter
  end
end

# 运行转换
if __FILE__ == $0
  converter = DocumentConverter.new(ARGV[0] || '_posts')
  converter.convert_all
end
