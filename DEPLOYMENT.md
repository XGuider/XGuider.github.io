# 生产环境部署指南

## 快速部署

### GitHub Pages (推荐)
1. 将所有更改提交到 `main` 分支
2. 确保 `_config.yml` 中的 `url` 设置为您的 GitHub Pages URL
3. 推送到 GitHub，GitHub Actions 将自动构建和部署

### Netlify
1. 连接 GitHub 仓库到 Netlify
2. 构建命令：`npm install && npm run build && bundle install && bundle exec jekyll build --future`
3. 发布目录：`_site`
4. 环境变量：参考 `netlify.toml`

### 本地部署
```bash
# 安装依赖
npm install
bundle install

# 构建生产版本
npm run build

# 运行 Jekyll 构建
JEKYLL_ENV=production bundle exec jekyll build

# 生成的站点在 _site/ 目录
```

## 环境要求

### Node.js (版本 18+)
- 用于构建 JavaScript 和 CSS 文件
- Webpack 打包现代 ES6+ 代码
- PostCSS 处理 CSS

### Ruby (版本 3.0+)
- Jekyll 静态站点生成器
- 相关 gem 依赖（见 `Gemfile`）

## 构建步骤

### 1. 构建前端资源
```bash
npm run build
```

### 2. 优化图像
```bash
npm run build:img
```

### 3. 运行 Jekyll
```bash
bundle exec jekyll build
```

### 4. 质量检查
```bash
# 运行 ESLint 和 Stylelint
npm run lint

# 运行 Lighthouse CI
npm run test
```

## 性能优化

### 已优化项目
- ✅ 移除 jQuery/Bootstrap 依赖 (减少 ~200KB)
- ✅ 模块化 JavaScript (ES6+) 代码
- ✅ 现代 CSS 特性 (CSS Grid, Flexbox, 变量)
- ✅ Service Worker 缓存策略
- ✅ 图像 WebP 格式支持
- ✅ 代码分割和懒加载
- ✅ Critical CSS 内联

### 部署后建议
1. 运行 Google PageSpeed Insights
2. 检查 Web Vitals 指标
3. 验证 PWA 分数
4. 测试不同设备的性能

## 安全设置

### Content Security Policy
已在 `head-modern-css.html` 中配置：
```
default-src 'self';
script-src 'self' 'unsafe-inline' www.googletagmanager.com www.google-analytics.com;
style-src 'self' 'unsafe-inline' fonts.googleapis.com;
img-src 'self' data: www.google-analytics.com;
```

### 安全头部
Netlify 已配置：
- X-Frame-Options: DENY
- X-Content-Type-Options: nosniff
- X-XSS-Protection: 1; mode=block
- Referrer-Policy: strict-origin-when-cross-origin

## 环境配置

### 生产环境变量
```bash
JEKYLL_ENV=production
NODE_ENV=production
```

### 分析工具配置
确保在 `_config.yml` 中配置了您的分析跟踪ID：
```yaml
analytics:
  google:
    tag_id: "G-XXXXXXXXXX"  # GA4 测量ID
  plausible:
    domain: "your-domain.com"
```

## 验证部署

### 1. Lighthouse 审计
使用 Chrome DevTools 的 Lighthouse 标签页：
- 性能分数 > 90
- 可访问性分数 > 90
- 最佳实践分数 > 90
- SEO 分数 > 90
- PWA 功能完整

### 2. 功能测试清单
- [ ] 导航菜单 (移动端和桌面端)
- [ ] 搜索功能
- [ ] 社交分享按钮
- [ ] RSS 订阅
- [ ] 404 页面
- [ ] 高速滚动性能
- [ ] 离线功能 (PWA)

### 3. 跨浏览器测试
- Chrome/Chromium (最新版本)
- Firefox (最新版本)
- Safari (最新版本)
- Edge (最新版本, Chromium 版本)

### 4. 响应式设计检查
- 320px (小屏手机)
- 768px (平板)
- 1024px (笔记本)
- 1920px (桌面显示器)

## 监控和维护

### 1. 性能监控
建议集成 Real User Monitoring (RUM)：
- Google Analytics 网站速度追踪
- Web Vitals 库监控核心指标

### 2. 误差监控
- 404 错误追踪 (已内置)
- JavaScript 错误收集
- Service Worker 错误日志

### 3. 定期更新
建议每季度检查：
- Node.js 和 Ruby 版本更新
- 依赖包安全更新
- Jekyll 版本更新
- Netlify/GitHub Actions 配置更新

## 故障排除

### 常见问题

1. 构建失败：
   - 检查 Node.js 和 Ruby 版本
   - 清除 node_modules 和 package-lock.json
   - 使用 `npm ci` 重新安装依赖

2. 样式丢失：
   - 确认 `css/main.min.css` 已生成
   - 检查静态文件路径是否正确

3. PWA 功能异常：
   - 验证 `manifest.json` 路径
   - 检查 Service Worker 注册状态
   - 测试离线访问

### 紧急回滚
如果需要回滚到上一个稳定版本：
```bash
git revert HEAD
# 或
git checkout HEAD~1
```

## 后续优化建议

1. **搜索增强**：实现全文搜索功能
2. **结构化数据**：添加更丰富的 Schema.org 标记
3. **国际化**：准备多语言支持
4. **暗色模式**：用户可控的主题切换
5. **文章评分**：添加读者评分系统

## 恭喜！🎉
您已成功迁移到现代化博客系统！
新的技术栈将为您提供：
- ⚡ 更快的加载速度
- 🔒 更强的安全防护
- 📱 更好的移动体验
- 🎯 更高的SEO排名
- 🚀 更轻松的维护

享受您的新博客吧！