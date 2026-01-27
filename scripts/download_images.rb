#!/usr/bin/env ruby
# frozen_string_literal: true

# 下载符合网站风格的图片脚本
# 使用 Unsplash Source API (无需API密钥)

require 'net/http'
require 'uri'
require 'fileutils'

class ImageDownloader
  # 根据网站风格定义的图片主题
  IMAGE_THEMES = {
    'home-bg-art.jpg' => 'minimalist abstract art, blue gradient, modern, clean',
    'home-bg.jpg' => 'minimalist workspace, modern office, clean design',
    'post-bg.jpg' => 'abstract technology, blue tones, modern, professional',
    '404-bg.jpg' => 'minimalist error, simple design, blue gray tones',
    'post-bg-alitrip.jpg' => 'travel, modern, clean, professional',
    'favicon.ico' => 'keep existing' # 保留现有favicon
  }.freeze

  # Unsplash Source URLs (无需API密钥)
  UNSPLASH_BASE = 'https://source.unsplash.com'.freeze

  def initialize
    @img_dir = 'img'
    @downloaded = []
    @failed = []
  end

  def download_all
    puts "=" * 60
    puts "下载符合网站风格的图片"
    puts "=" * 60
    puts "\n网站风格: 现代、简洁、高级、蓝色系\n"

    # 需要下载的图片列表（基于实际使用情况）
    images_to_download = [
      { name: 'home-bg-art.jpg', width: 1920, height: 1080, keywords: 'minimalist abstract blue gradient modern' },
      { name: 'post-bg.jpg', width: 1920, height: 1080, keywords: 'abstract technology blue professional modern' },
      { name: '404-bg.jpg', width: 1920, height: 1080, keywords: 'minimalist simple gray blue' },
      { name: 'post-bg-alitrip.jpg', width: 1920, height: 1080, keywords: 'modern workspace clean professional' }
    ]

    images_to_download.each do |img|
      download_image(img[:name], img[:width], img[:height], img[:keywords])
    end

    puts "\n" + "=" * 60
    puts "下载完成!"
    puts "=" * 60
    puts "成功: #{@downloaded.size}"
    puts "失败: #{@failed.size}"
    
    if @failed.size > 0
      puts "\n失败的图片:"
      @failed.each { |img| puts "  - #{img}" }
    end
  end

  private

  def download_image(filename, width, height, keywords)
    puts "\n下载: #{filename}..."
    
    # 使用 Unsplash Source API
    # 格式: https://source.unsplash.com/WIDTHxHEIGHT/?KEYWORDS
    keywords_param = keywords.gsub(' ', ',')
    url = "#{UNSPLASH_BASE}/#{width}x#{height}/?#{keywords_param}"
    
    begin
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.read_timeout = 30
      
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      
      if response.code == '200'
        file_path = File.join(@img_dir, filename)
        FileUtils.mkdir_p(@img_dir) unless Dir.exist?(@img_dir)
        
        File.open(file_path, 'wb') do |file|
          file.write(response.body)
        end
        
        file_size = File.size(file_path)
        puts "  ✓ 成功 (#{(file_size / 1024.0).round(2)} KB)"
        @downloaded << filename
      else
        puts "  ✗ 失败: HTTP #{response.code}"
        @failed << filename
      end
    rescue => e
      puts "  ✗ 错误: #{e.message}"
      @failed << filename
    end
  end
end

# 运行下载
if __FILE__ == $0
  downloader = ImageDownloader.new
  downloader.download_all
end
