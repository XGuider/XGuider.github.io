---
layout: "post"
title: "readme"
subtitle: "开源项目 / 数据采集类 / clklog"
date: "2025-07-15 18:44:37"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - 数据采集类
    - clklog
categories:
    - 开源项目
---

> 来源：`本机相关/07-开源项目/01-数据采集类/clklog/readme.md`

不同职能的团队对于行为数据的关注点完全不同，因此需要先梳理清楚使用目的和优先级。常见需求分类：
· 产品团队：关注功能使用率、转化率、用户行为路径
· 运营团队：关注用户分群、留存、画像、精准营销
· 技术团队：关注 SDK 采集质量、崩溃监控、维护保障



@加密@参考：https://manual.sensorsdata.cn/sa/docs/tech_super_access/v0300

curl -v POST 'http://localhost:8002/api/gp?project=clklogapp' \ 
-H "Content-Type: application/json" \
-d 'gzip=1&data_list=H4sIAEx6XmgAA9VSTWvDMAy951f4BzTB7pRqyy3px3WH9TZGyRJTxBrbOM4glP73JU2g3gbZCj1sBh%2F8pCc9We85YOzYXcZypVVb6abeUZmwZYwCYZWGsIqzELIUwxSzOFwj8OyOI1%2FCZnbmlVQ7UoW7kibfpXIJGx6OKpkwgYIDR5jDA4ox0Jou4GxevA0AlR2NHMk6GXX355rGv88%2Fp58G1oFePzeEaBHN%2FYr0%2BOQ%2FRQSR8IG8cXrbD%2BKXNVYbab%2BP81OxQpdyNqVG4KS61JiDHIQEo5gbuqDVjd0VTe10JW2HjF%2Bo96Qm4v%2FAEX7%2B1yFu65Z%2BwX%2FGKBcg3%2Fdbub84J3gJPgB1AtXSQwQAAA%3D%3D'


# 加密数据 需要经过url编码
curl -v 'http://localhost:8002/api/gp?project=clklogapp&gzip=1&data_list=H4sIAI%2FQIGYAA%2BVTTU%2BDQBC991dsSI9CoC6ueoNWrx7QkzFkC1ucWHY3uwsJMf53%2BYwFa9NoD0YPXObNeztvePM4Q%2Bi1%2FhCyKBe8ykWhY0ita2QtfeIRvApsvPJDG4cBsQMS%2BvYNwW547hJ3iW%2Bts46bgjbAE%2FMNKisZNw1pHkgZGarMgBjIWQ14xHOxS%2FACXxFvgCrZQJZRNHkZ%2BiGtlcAA0zXUmWrr8x6o4h9YnChBuimPVmgF3vopt7CejFdX4pIpDYI3kti5cBajVzuKBXfRqEyl3OV5Dna8KS%2FOmXkWrVlaGHHf7ms0j1RCMrVna0Kf4NFEpOwTfNCs0CN9ctwucsqLDU1MoZhq8DpLW9YbnfVmT5%2FzShQqTgptRM5UUxv%2BsciAf9mDpsGPIOMP8s%2FFfq%2FCwdWg33EpbWj%2FzZHsdNCsTd7lx93Mnt4B6qJXJSIGAAA%3D'

加密 //
echo "[
  {
    "anonymous_id": "C57174DA-4D5B-4BA7-A7B5-E740B3070C4F",
    "distinct_id": "C57174DA-4D5B-4BA7-A7B5-E740B3070C4F",
    "event": "AppStart",
    "time": 1710407424971,
    "type": "track",
    "identities": {
        "identity_anonymous_id": "C57174DA-4D5B-4BA7-A7B5-E740B3070C4F",
        "identity_idfv": "C57174DA-4D5B-4BA7-A7B5-E740B3070C4F"
    },
    "lib": {
        "lib_version": "4.6.2",
        "lib": "iOS",
        "app_version": "1.4.1",
        "lib_method": "autoTrack"
    },
    "properties": {
        "os": "iOS",
        "app_version": "1.4.1",
        "lib_method": "code",
        "lib_version": "4.6.2",
        "os_version": "17.2",
        "lib": "iOS",
        "manufacturer": "Apple"
    }
  },
  {
    "anonymous_id": "C57174DA-4D5B-4BA7-A7B5-E740B3070C4F",
    "distinct_id": "your_customer_id",
    "login_id": "your_customer_id",
    "event": "SignUp",
    "time": 1710407424971,
    "type": "track",
    "identities": {
        "identity_anonymous_id": "C57174DA-4D5B-4BA7-A7B5-E740B3070C4F",
        "identity_idfv": "C57174DA-4D5B-4BA7-A7B5-E740B3070C4F",
        "identity_login_id": "your_customer_id"
    },
    "lib": {
        "lib_version": "4.6.2",
        "lib": "iOS",
        "app_version": "1.4.1",
        "lib_method": "code"
    },
    "properties": {
        "os": "iOS",
        "app_version": "1.4.1",
        "lib_method": "code",
        "lib_version": "4.6.2",
        "os_version": "17.2",
        "lib": "iOS",
        "manufacturer": "Apple",
        "age": 18
    }
  }
]" | gzip | base64 -b 0

解密 //
echo "H4sIAAW0a2gAA91STU+EMBC98yv6A4DQtVjlBrt69YCejCEVujhxaZu2kBDjf5evBNa4m3VjTPTQQ9/Mm5k38x4dhN66hxATUrSVrE0GRYTWIcWUbGKPbMLEI0lMvZgmoXdDSZBcBDRYk1t34BVgLIjcfpPGGy5shGKlUsu0HUELFY8QpjggASUrck3xFGhVF7Ca5a8jAEVHBwvcRNP8C7TNzhWzVwSKbXMaeeC+jyV28LwcqftmDdcGpIgQ8S/9lbuMRQju0hlhSs3Z2Cc+3svOKm5fZKeI1Vbe99tYdlZaKq4/70SaM3vksuDuSTqkWRSkxxVWTNRblttacz2cf8dHDc6k4wfd2MpaZ3ltrKy47pDpQLIEcSQ+OTOFUjyov+3LL8iH1f+6iXuD/Qf/LkYre5tczYZ2npwPIiK2BWIFAAA=" |base64 -d | gzip -d
