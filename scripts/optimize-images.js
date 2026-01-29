#!/usr/bin/env node

const fs = require('fs').promises
const path = require('path')
const sharp = require('sharp')

/**
 * Modern image optimization script for XGuider Blog
 * Optimizes images for web delivery with multiple formats
 */

const CONFIG = {
  input: 'img/original',
  output: 'img',
  quality: 85,
  formats: ['webp', 'jpeg'],
  resizeOptions: [
    { width: 1920, suffix: '_lg' },
    { width: 1024, suffix: '_md' },
    { width: 640, suffix: '_sm' }
  ]
}

class ImageOptimizer {
  constructor(config) {
    this.config = { ...CONFIG, ...config }
  }

  async init() {
    console.log('🎨 Starting image optimization...')

    try {
      await this.ensureOutputDirectories()
      const files = await this.getImageFiles()

      console.log(`Found ${files.length} images to optimize`)

      for (const file of files) {
        await this.optimizeImage(file)
      }

      console.log('✅ Image optimization complete!')
    } catch (error) {
      console.error('❌ Image optimization failed:', error)
      process.exit(1)
    }
  }

  async ensureOutputDirectories() {
    for (const format of this.config.formats) {
      const dir = path.join(this.config.output, format)
      await fs.mkdir(dir, { recursive: true })
    }
  }

  async getImageFiles() {
    const files = []
    const items = await fs.readdir(this.config.input, { withFileTypes: true })

    for (const item of items) {
      if (item.isFile()) {
        const ext = path.extname(item.name).toLowerCase()
        if (['.jpg', '.jpeg', '.png', '.gif', '.webp', '.tiff'].includes(ext)) {
          files.push(item.name)
        }
      }
    }

    return files
  }

  async optimizeImage(filename) {
    const inputPath = path.join(this.config.input, filename)
    const baseName = path.parse(filename).name

    console.log(`Optimizing: ${filename}`)

    try {
      const image = sharp(inputPath)
      const metadata = await image.metadata()

      // Generate different sizes
      for (const size of this.config.resizeOptions) {
        const shouldResize = metadata.width > size.width
        const resizedImage = shouldResize
          ? image.clone().resize(size.width, null, { withoutEnlargement: true })
          : image.clone()

        // Generate WebP format
        if (this.config.formats.includes('webp')) {
          const webpPath = path.join(
            this.config.output,
            'webp',
            `${baseName}${size.suffix}.webp`
          )

          await resizedImage
            .clone()
            .webp({ quality: this.config.quality })
            .toFile(webpPath)

          console.log(`  Generated WebP ${size.suffix}: ${webpPath}`)
        }

        // Generate JPEG format
        if (this.config.formats.includes('jpeg') && metadata.format !== 'jpeg') {
          const jpegPath = path.join(
            this.config.output,
            'jpeg',
            `${baseName}${size.suffix}.jpg`
          )

          await resizedImage
            .clone()
            .jpeg({ quality: this.config.quality })
            .toFile(jpegPath)

          console.log(`  Generated JPEG ${size.suffix}: ${jpegPath}`)
        }
      }

      // Generate progressive JPEG version
      if (metadata.format === 'jpeg') {
        const progressivePath = path.join(
          this.config.output,
          'jpeg',
          `${baseName}.jpg`
        )

        await image
          .clone()
          .jpeg({
            quality: this.config.quality,
            progressive: true,
            mozjpeg: true
          })
          .toFile(progressivePath)

        console.log(`  Generated progressive JPEG: ${progressivePath}`)
      }

      console.log(`  ✅ Optimized ${filename}`)

    } catch (error) {
      console.error(`  ❌ Failed to optimize ${filename}:`, error)
    }
  }

  async generateManifest() {
    console.log('📋 Generating image manifest...')

    const manifest = {
      version: 1,
      images: [],
      formats: this.config.formats,
      sizes: this.config.resizeOptions.map(size => ({
        suffix: size.suffix,
        width: size.width
      }))
    }

    const files = await this.getImageFiles()

    for (const filename of files) {
      const baseName = path.parse(filename).name

      manifest.images.push({
        name: baseName,
        original: filename,
        formats: this.config.formats.map(format => ({
          format,
          sizes: this.config.resizeOptions.map(size => ({
            size: size.suffix,
            file: `${baseName}${size.suffix}.${format === 'jpeg' ? 'jpg' : format}`
          }))
        }))
      })
    }

    await fs.writeFile(
      path.join(this.config.output, 'manifest.json'),
      JSON.stringify(manifest, null, 2)
    )

    console.log('✅ Image manifest generated')
  }
}

// Image optimization with AVIF support
class ModernImageOptimizer extends ImageOptimizer {
  async optimizeImage(filename) {
    const inputPath = path.join(this.config.input, filename)
    const baseName = path.parse(filename).name

    console.log(`Optimizing with modern formats: ${filename}`)

    try {
      const image = sharp(inputPath)
      const metadata = await image.metadata()

      // 生成 AVIF 格式 (现代格式)
      const avifPath = path.join(
        this.config.output,
        'avif',
        `${baseName}.avif`
      )

      await image
        .clone()
        .avif({
          quality: this.config.quality,
          effort: 3
        })
        .toFile(avifPath)

      console.log(`  Generated AVIF: ${avifPath}`)

      // 调用父类的优化方法 (生成 WebP 和 JPEG)
      await super.optimizeImage(filename)

    } catch (error) {
      console.error(`  ❌ Failed to optimize with modern formats:`, error)
      // 回退到标准优化
      await super.optimizeImage(filename)
    }
  }
}

// 主程序
async function main() {
  console.log('🚀 Modern Image Optimizer')
  console.log('========================')

  const isAVIFSupported = await checkAVIFSupport()
  const Optimizer = isAVIFSupported ? ModernImageOptimizer : ImageOptimizer

  const optimizer = new Optimizer(CONFIG)

  // 检查原始图片目录是否存在
  try {
    await fs.access(CONFIG.input)
  } catch {
    console.log('📁 Creating original image directory...')
    await fs.mkdir(CONFIG.input, { recursive: true })
    console.log(`📝 Place original images in: ${CONFIG.input}`)
    return
  }

  await optimizer.init()
  await optimizer.generateManifest()
}

async function checkAVIFSupport() {
  try {
    return sharp.format.avif.input.file && sharp.format.avif.output.file
  } catch {
    return false
  }
}

// 如果直接运行此脚本
if (require.main === module) {
  main().catch(console.error)
}

module.exports = { ImageOptimizer, ModernImageOptimizer }