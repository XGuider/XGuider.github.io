---
layout: "post"
title: "最新top消息消息-配置"
subtitle: "开源项目 / 数据采集类 / inforSum"
date: "2025-02-15 12:26:05"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - 数据采集类
    - inforSum
categories:
    - 开源项目
---

{% raw %}
> 来源：`本机相关/07-开源项目/01-数据采集类/inforSum/最新top消息消息-配置.md`

curl "https://api.bilibili.com/x/web-interface/search/square?limit=20" \
     -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" \
     -H "Referer: https://www.bilibili.com"

curl "https://top.taobao.com/index.php?s=1&limit=50&type=hot&sort=hot" \
     -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" \
     -H "Referer: https://www.taobao.com" \
     -H "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" \
     -H "Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8'"



     curl https://api.deepseek.com/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer sk-64da9bbfcf124ad7b5d463174a49eb7c" \
  -d '{
        "model": "deepseek-chat",
        "messages": [
          {"role": "system", "content": "You are a helpful assistant."},
          {"role": "user", "content": "Hello!"}
        ],
        "stream": false
      }'

https://api.weixin.qq.com/cgi-bin/message/template/send?access_token={token}

AppID:wxb8c324c0749dbca3
AppSecret:625bedaf9b6bb93aed6b97d757024724



获取token：https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=wxb8c324c0749dbca3&secret=625bedaf9b6bb93aed6b97d757024724


https://api.weixin.qq.com/cgi-bin/user/get?access_token=89_td9NQqtrzUH0EjbczebIkHuVwlAtrI6-I5EbpBPoYc0Of3bWLf4LMmTFVz_TdFioRSZhw0F5LBkxYtaFgU1hV_M7X4Um9I127205nSNicJc-xJKdclZZ3IaC4Q0QEYiAGAXLF

curl https://api.weixin.qq.com/cgi-bin/openapi/rid/get?access_token=67af5c89-496bcbf7-261c219c
{% endraw %}
