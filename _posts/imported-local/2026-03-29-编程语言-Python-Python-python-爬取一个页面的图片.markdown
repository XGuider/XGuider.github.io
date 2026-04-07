---
layout: "post"
title: "python----爬取一个页面的图片"
subtitle: "编程语言 / Python / Python"
date: "2026-03-29 14:08:07"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - Python
categories:
    - 编程语言
---

> 来源：`本机相关/01-编程语言/02-Python/Python/python----爬取一个页面的图片.md`

---
tags:
  - Python
  - 编程语言
  - 爬虫
  - pyspider
created: 2024-01-01
updated: 2026-03-29
status: final
confidence: high
---

```python
####手工爬取
import requests, re
response = requests.get('http://www.imooc.com/course/list')
html = response.content.decode("utf-8")
print(html)
listurl = re.findall(r'src=.+\.jpg', html)
listurls = []
for each in listurl:
    listurls.append('http:' + each[5:])
print(listurls)

i = 0
for url in listurls:
    response = requests.get(url)
    image = response.content.decode("utf-8")
    dir = 'D:\\编程代码集合\\Python程序代码\\网络爬虫\\image\\' + str(i) + '.jpg'
    f = open(dir, 'wb')
    f.write(image)
    i += 1
```
使用pyspider框架
```python
from pyspider.libs.base_handler import *
import re
class Handler(BaseHandler):
    crawl_config = {
    }
    @every(minutes=24 * 60)
    def on_start(self):
        self.crawl('http://www.bilibili.com/', callback=self.index_page)
    @config(age=10 * 24 * 60 * 60)
    def index_page(self, response):
        for each in response.doc('a[href^="http"]').items():
            if re.match("https://www.bilibili.com/video/", each.attr.href):
                self.crawl(each.attr.href, callback=self.detail_page)
    @config(priority=2)
    def detail_page(self, response):
        return {
            "url": response.url,
            "title": response.doc('title').text(),
        }
```
