#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'

class LocalNotesImporter
    DEFAULT_AUTHOR = 'XGuider'
    DEFAULT_HEADER_IMG = 'img/post-bg.jpg'

    def initialize(source_dir:, posts_dir: '_posts', output_subdir: 'imported-local')
        @source_dir = File.expand_path(source_dir)
        @posts_dir = posts_dir
        @output_dir = File.join(@posts_dir, output_subdir)
        @imported_count = 0
        @skipped_count = 0
        @error_count = 0
    end

    def import_all
        unless Dir.exist?(@source_dir)
            puts "错误: 源目录不存在: #{@source_dir}"
            return
        end
        unless Dir.exist?(@posts_dir)
            puts "错误: 目标目录不存在: #{@posts_dir}"
            return
        end

        FileUtils.mkdir_p(@output_dir)

        files = Dir.glob(File.join(@source_dir, '**', '*.md')).sort
        puts "开始导入本机笔记..."
        puts "源目录: #{@source_dir}"
        puts "输出目录: #{@output_dir}"
        puts "文件数量: #{files.size}"
        puts '=' * 50

        files.each { |path| import_one(path) }

        puts '=' * 50
        puts "导入完成!"
        puts "  成功: #{@imported_count}"
        puts "  跳过: #{@skipped_count}"
        puts "  错误: #{@error_count}"
    end

    private

    def import_one(path)
        rel_path = path.sub(@source_dir + File::SEPARATOR, '')
        return skip(rel_path, '空文件名') if rel_path.strip.empty?

        begin
            content = File.read(path)
        rescue => e
            @error_count += 1
            puts "错误: 读取失败: #{rel_path} (#{e.message})"
            return
        end

        if content.strip.empty?
            return skip(rel_path, '内容为空')
        end

        metadata = build_metadata(path, rel_path)
        file_basename = build_output_basename(metadata, rel_path)
        out_path = unique_path(File.join(@output_dir, file_basename))

        # 如果目标文件已经存在且比源文件新，跳过
        if File.exist?(out_path) && File.mtime(out_path) >= File.mtime(path)
            return skip(rel_path, '已是最新')
        end

        front_matter = build_front_matter(metadata)
        body = build_body(rel_path, content)

        File.write(out_path, front_matter + "\n\n" + body)
        @imported_count += 1
        puts "导入: #{rel_path} -> #{File.basename(out_path)}"
    rescue => e
        @error_count += 1
        puts "错误: 导入失败: #{rel_path} (#{e.class}: #{e.message})"
    end

    def skip(rel_path, reason)
        @skipped_count += 1
        puts "跳过: #{rel_path} (#{reason})"
    end

    def build_metadata(abs_path, rel_path)
        parts = rel_path.split(File::SEPARATOR)
        category_raw = parts[0] || '未分类'
        category = normalize_name(category_raw)

        tags = parts[1..-2].to_a.map { |p| normalize_name(p) }.reject(&:empty?).uniq

        title = normalize_title(File.basename(rel_path, '.md'))
        subtitle = parts[0..-2].to_a.map { |p| normalize_name(p) }.reject(&:empty?).join(' / ')

        time = File.mtime(abs_path)

        {
            'layout' => 'post',
            'title' => title,
            'subtitle' => subtitle.empty? ? nil : subtitle,
            'date' => time.strftime('%Y-%m-%d %H:%M:%S'),
            'author' => DEFAULT_AUTHOR,
            'header-img' => DEFAULT_HEADER_IMG,
            'catalog' => true,
            'tags' => tags,
            'categories' => [category]
        }
    end

    def build_output_basename(metadata, rel_path)
        date_prefix = metadata['date'][0, 10]
        slug = build_slug(rel_path, metadata['title'])
        "#{date_prefix}-#{slug}.markdown"
    end

    def build_slug(rel_path, title)
        parts = rel_path.split(File::SEPARATOR).map { |p| File.basename(p, File.extname(p)) }
        cleaned_parts = parts.map { |p| normalize_name(p) }.reject(&:empty?)
        slug_source = (cleaned_parts[0..2] + [title]).compact.join('-')
        slug = slug_source.gsub(/[^\p{Han}\p{L}\p{N}\- _]+/u, '').strip
        slug = slug.gsub(/\s+/u, '-').gsub(/-+/u, '-')
        slug.empty? ? 'untitled' : slug
    end

    def unique_path(path)
        return path unless File.exist?(path)

        base = path.sub(/\.markdown\z/u, '')
        idx = 2
        loop do
            candidate = "#{base}-#{idx}.markdown"
            return candidate unless File.exist?(candidate)
            idx += 1
        end
    end

    def build_front_matter(metadata)
        fm = +"---\n"
        ordered_keys = %w[layout title subtitle date author header-img catalog tags categories]
        ordered_keys.each do |key|
            value = metadata[key]
            next if value.nil?

            if value.is_a?(Array)
                fm << "#{key}:\n"
                value.each { |v| fm << "    - #{v}\n" }
            elsif value == true || value == false
                fm << "#{key}: #{value}\n"
            else
                fm << "#{key}: #{value.inspect}\n"
            end
        end
        fm << "---"
        fm
    end

    def build_body(rel_path, content)
        header = "> 来源：`本机相关/#{rel_path}`\n\n"
        header + content.strip + "\n"
    end

    def normalize_title(name)
        t = normalize_name(name)
        t.empty? ? '未命名笔记' : t
    end

    def normalize_name(name)
        s = name.to_s.dup
        s = s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
        # 去掉前缀序号：01-xxx / 01_xxx / 01.xxx
        s = s.sub(/\A\d{1,3}[\-_.、\s]+/u, '')
        # 常见分隔符统一为空格，便于标题显示
        s = s.tr('_', ' ')
        s = s.gsub(/\s+/u, ' ').strip
        s
    end
end

if __FILE__ == $0
    source_dir = ARGV[0] || '/Users/faqingxiong/Documents/workspace/本机相关'
    posts_dir = ARGV[1] || '_posts'
    importer = LocalNotesImporter.new(source_dir: source_dir, posts_dir: posts_dir)
    importer.import_all
end

