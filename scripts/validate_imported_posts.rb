#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'
require 'json'
require 'digest'
require 'date'

class ImportedPostsValidator
    LOG_PATH = '/Users/faqingxiong/Documents/code/XGuider.github.io/.cursor/debug-04b6b4.log'
    SESSION_ID = '04b6b4'

    def initialize(dir)
        @dir = dir
        @checked = 0
        @ok = 0
        @bad = 0
    end

    def run
        files = Dir.glob(File.join(@dir, '**', '*.markdown')).sort
        log('A', 'start', { dir: @dir, fileCount: files.size })

        files.each do |path|
            validate_one(path)
        end

        log('A', 'done', { checked: @checked, ok: @ok, bad: @bad })
        puts "checked=#{@checked} ok=#{@ok} bad=#{@bad}"
    end

    private

    def log(hypothesis_id, message, data)
        payload = {
            sessionId: SESSION_ID,
            runId: 'pre-fix',
            hypothesisId: hypothesis_id,
            location: 'scripts/validate_imported_posts.rb',
            message: message,
            data: data,
            timestamp: (Time.now.to_f * 1000).to_i
        }
        File.open(LOG_PATH, 'a') { |f| f.puts(JSON.generate(payload)) }
    rescue
        # ignore logging failures
    end

    def validate_one(path)
        @checked += 1
        path_for_io = path.to_s
        path_for_display = safe_utf8(path_for_io)
        rel = path_for_display.sub(%r{\A.*/_posts/}u, '_posts/')

        raw = File.binread(path_for_io)
        unless raw.valid_encoding?
            @bad += 1
            log('B', 'invalid-encoding', { file: rel })
            puts "BAD encoding: #{rel}"
            return
        end

        text = raw.force_encoding('UTF-8')
        fm, body = split_front_matter(text)
        if fm.nil?
            @bad += 1
            log('C', 'missing-front-matter', { file: rel })
            puts "BAD front-matter missing: #{rel}"
            return
        end

        begin
            data = YAML.safe_load(fm, permitted_classes: [Date, Time], aliases: true) || {}
        rescue => e
            @bad += 1
            log('D', 'front-matter-yaml-error', { file: rel, error: "#{e.class}: #{e.message}" })
            puts "BAD yaml: #{rel} -> #{e.class}: #{e.message}"
            return
        end

        # 常见 Jekyll 约束：title/date/layout 必须存在且可解析
        layout = data['layout']
        title = data['title']
        date = data['date']

        issues = []
        issues << 'missing-layout' if layout.nil? || layout.to_s.strip.empty?
        issues << 'missing-title' if title.nil? || title.to_s.strip.empty?
        issues << 'missing-date' if date.nil? || date.to_s.strip.empty?

        if issues.any?
            @bad += 1
            log('E', 'front-matter-missing-keys', { file: rel, issues: issues, keys: data.keys })
            puts "BAD keys: #{rel} -> #{issues.join(',')}"
            return
        end

        # 一些文件内容可能包含极端长行/非法控制字符，先做粗筛
        if text.match?(/[\u0000-\u0008\u000B\u000C\u000E-\u001F]/u)
            @bad += 1
            log('F', 'control-chars', { file: rel })
            puts "BAD control chars: #{rel}"
            return
        end

        @ok += 1
        if (@checked % 50).zero?
            log('A', 'progress', { checked: @checked, ok: @ok, bad: @bad })
        end
    rescue => e
        @bad += 1
        log('Z', 'unexpected-error', { file: rel, error: "#{e.class}: #{e.message}" })
        puts "BAD unexpected: #{rel} -> #{e.class}: #{e.message}"
    end

    def split_front_matter(text)
        # expects:
        # ---
        # yaml...
        # ---
        return nil if text.nil?
        return nil unless text.start_with?("---\n") || text.start_with?("---\r\n")

        # normalize newlines for split
        normalized = text.gsub("\r\n", "\n")
        parts = normalized.split(/^---\s*$/u, 3)
        # split result: ["", "\nyaml...\n", "\nbody..."]
        return nil if parts.length < 3

        fm = parts[1].to_s.strip
        body = parts[2].to_s
        [fm, body]
    end

    def force_utf8(s)
        return '' if s.nil?
        str = s.to_s
        str = str.dup if str.frozen?
        return str if str.encoding.name == 'UTF-8'
        str.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
    rescue
        s.to_s.force_encoding('UTF-8')
    end

    def safe_utf8(s)
        return '' if s.nil?
        str = s.to_s
        if str.encoding.name == 'ASCII-8BIT'
            forced = str.dup.force_encoding('UTF-8')
            return forced if forced.valid_encoding?
        end
        return str if str.encoding.name == 'UTF-8' && str.valid_encoding?
        str.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
    rescue
        s.to_s
    end
end

if __FILE__ == $0
    dir = ARGV[0] || File.join(Dir.pwd, '_posts', 'imported-local')
    ImportedPostsValidator.new(dir).run
end

