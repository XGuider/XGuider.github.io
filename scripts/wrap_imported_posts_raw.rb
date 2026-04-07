#!/usr/bin/env ruby
# frozen_string_literal: true

class ImportedPostsRawWrapper
    def initialize(dir)
        @dir = dir
        @changed = 0
        @skipped = 0
    end

    def run
        files = Dir.glob(File.join(@dir, '**', '*.markdown')).sort
        files.each { |p| wrap_one(p) }
        puts "changed=#{@changed} skipped=#{@skipped} total=#{files.size}"
    end

    private

    def wrap_one(path)
        text = File.read(path, mode: 'r:BOM|UTF-8')
        return skip unless text.start_with?("---\n") || text.start_with?("---\r\n")

        normalized = text.gsub("\r\n", "\n")
        parts = normalized.split(/^---\s*$/u, 3)
        return skip if parts.length < 3

        fm = parts[0] + "---\n" + parts[1].to_s.strip + "\n---\n"
        body = parts[2].to_s.sub(/\A\n+/u, '')

        # 已经包过 raw 就跳过
        if body.lstrip.start_with?("{% raw %}")
            return skip
        end

        wrapped = fm + "\n{% raw %}\n" + body.rstrip + "\n{% endraw %}\n"
        File.write(path, wrapped)
        @changed += 1
    rescue
        skip
    end

    def skip
        @skipped += 1
    end
end

if __FILE__ == $0
    dir = ARGV[0] || File.join(Dir.pwd, '_posts', 'imported-local')
    ImportedPostsRawWrapper.new(dir).run
end

