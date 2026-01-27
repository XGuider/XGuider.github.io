#!/usr/bin/env ruby
# frozen_string_literal: true

# Jekyll 语法验证脚本
# 检查 Liquid 模板语法错误

require 'fileutils'

class SyntaxValidator
  def initialize
    @errors = []
    @warnings = []
  end

  def validate
    puts "=" * 60
    puts "Jekyll 语法验证"
    puts "=" * 60
    puts ""

    # 检查 Liquid 语法错误
    check_liquid_syntax
    check_config_file
    check_excluded_files

    puts ""
    puts "=" * 60
    puts "验证完成"
    puts "=" * 60
    puts "错误: #{@errors.size}"
    puts "警告: #{@warnings.size}"

    if @errors.size > 0
      puts "\n发现的错误:"
      @errors.each { |e| puts "  ✗ #{e}" }
      exit 1
    end

    if @warnings.size > 0
      puts "\n警告:"
      @warnings.each { |w| puts "  ⚠ #{w}" }
    end

    puts "\n✓ 语法检查通过！"
    exit 0
  end

  private

  def check_liquid_syntax
    puts "检查 Liquid 模板语法..."

    # 检查常见的 Liquid 语法错误
    files_to_check = [
      'index.html',
      '_layouts/page.html',
      '_layouts/post.html',
      '_layouts/keynote.html',
      '_layouts/default.html',
      '_layouts/video.html'
    ]

    files_to_check.each do |file|
      next unless File.exist?(file)
      
      content = File.read(file, encoding: 'UTF-8')
      
      # 检查错误的 {{ }} 嵌套（在 {% if %} 标签内）
      # 正确的应该是: {% if tag[1].size > site.featured-condition-size %}
      # 错误的应该是: {% if tag[1].size > {{site.featured-condition-size}} %}
      if content =~ /\{\%\s+if\s+[^%]*\{\{.*site\.featured-condition-size.*\}\}.*\%\}/
        @errors << "#{file}: 在 {% if %} 标签中错误地使用了 {{ site.featured-condition-size }}"
      end
      
      # 检查 where_exp 的 contains 使用
      if content =~ /where_exp.*contains/
        @warnings << "#{file}: 使用了 where_exp contains，某些 Jekyll 版本可能不支持"
      end
    end
  end

  def check_config_file
    puts "检查配置文件..."
    
    unless File.exist?('_config.yml')
      @errors << "_config.yml 文件不存在"
      return
    end

    content = File.read('_config.yml')
    
    # 检查 exclude 配置
    unless content.include?('exclude:')
      @warnings << "_config.yml: 未找到 exclude 配置"
    end
  end

  def check_excluded_files
    puts "检查排除的文件..."
    
    # 检查 _posts 目录中的 Word/PDF 文件
    if Dir.exist?('_posts')
      doc_files = Dir.glob('_posts/*.{docx,doc,pdf}')
      if doc_files.size > 0
        @warnings << "发现 #{doc_files.size} 个 Word/PDF 文件在 _posts 目录中，这些文件应该被排除或转换为 Markdown"
        doc_files.each { |f| puts "  - #{f}" }
      end
    end
  end
end

# 运行验证
if __FILE__ == $0
  validator = SyntaxValidator.new
  validator.validate
end
