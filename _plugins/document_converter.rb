# frozen_string_literal: true

# Jekyll 插件：自动将 PDF 和 Word 文档转换为 Markdown
# 使用方法：将 PDF 或 Word 文件放在 _posts 目录下，插件会自动转换

module Jekyll
  class DocumentConverter < Generator
    safe true
    priority :low

    def generate(site)
      @site = site
      @posts_dir = File.join(site.source, '_posts')
      
      return unless Dir.exist?(@posts_dir)
      
      # 查找所有 PDF 和 Word 文件
      pdf_files = Dir.glob(File.join(@posts_dir, '*.pdf'))
      word_files = Dir.glob(File.join(@posts_dir, '*.docx')) + 
                   Dir.glob(File.join(@posts_dir, '*.doc'))
      
      # 处理 PDF 文件
      pdf_files.each do |pdf_file|
        convert_document(pdf_file, 'pdf')
      end
      
      # 处理 Word 文件
      word_files.each do |word_file|
        convert_document(word_file, 'word')
      end
    end

    private

    def convert_document(file_path, type)
      file_name = File.basename(file_path, File.extname(file_path))
      markdown_path = File.join(@posts_dir, "#{file_name}.markdown")
      
      # 如果对应的 Markdown 文件已存在且比源文件新，跳过转换
      if File.exist?(markdown_path) && File.mtime(markdown_path) > File.mtime(file_path)
        Jekyll.logger.info "DocumentConverter:", "跳过 #{file_name}（Markdown 文件已是最新）"
        return
      end
      
      # 检查是否安装了 pandoc
      unless system('which pandoc > /dev/null 2>&1')
        Jekyll.logger.warn "DocumentConverter:", "pandoc 未安装，无法转换 #{file_name}"
        Jekyll.logger.warn "DocumentConverter:", "请安装 pandoc: brew install pandoc (macOS) 或 apt-get install pandoc (Linux)"
        return
      end
      
      # 提取元数据（从文件名或文件属性）
      metadata = extract_metadata(file_path, file_name)
      
      # 使用 pandoc 转换为 Markdown
      temp_md = Tempfile.new(['converted', '.md'])
      begin
        if type == 'pdf'
          # PDF 转换（需要 pandoc 和 pdftotext 或类似工具）
          # 注意：PDF 转换质量可能不如 Word
          system("pandoc -f pdf -t markdown \"#{file_path}\" -o \"#{temp_md.path}\" 2>/dev/null") ||
          system("pandoc -f pdf+raw_html -t markdown \"#{file_path}\" -o \"#{temp_md.path}\" 2>/dev/null")
        else
          # Word 转换
          system("pandoc -f docx -t markdown \"#{file_path}\" -o \"#{temp_md.path}\"")
        end
        
        unless File.exist?(temp_md.path) && File.size(temp_md.path) > 0
          Jekyll.logger.error "DocumentConverter:", "转换失败: #{file_name}"
          return
        end
        
        # 读取转换后的内容
        content = File.read(temp_md.path)
        
        # 创建 Jekyll 格式的 Markdown 文件
        front_matter = build_front_matter(metadata, file_path)
        markdown_content = front_matter + "\n\n" + content
        
        # 写入文件
        File.write(markdown_path, markdown_content)
        Jekyll.logger.info "DocumentConverter:", "成功转换: #{file_name} -> #{file_name}.markdown"
        
      ensure
        temp_md.close
        temp_md.unlink
      end
    end

    def extract_metadata(file_path, file_name)
      # 尝试从文件名提取日期、分类和标题
      # 格式: YYYY-MM-DD-CATEGORY-title.pdf 或 YYYY-MM-DD-CATEGORY-title.docx
      # 例如: 2024-01-15-JAVA-Spring实战.docx
      #      2026-01-07-JAVA-Spring实战.docx
      date_match = file_name.match(/^(\d{4}-\d{2}-\d{2})-(.+)$/)
      
      metadata = {
        'layout' => 'post',
        'title' => file_name,
        'date' => Time.now.strftime('%Y-%m-%d %H:%M:%S'),
        'author' => @site.config['author'] || 'XGuider',
        'header-img' => @site.config['header-img'] || 'img/post-bg.jpg',
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
end
