---
layout: "post"
title: "python基础语法"
subtitle: "编程语言 / Python / Python"
date: "2026-03-29 14:08:06"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - Python
categories:
    - 编程语言
---

> 来源：`本机相关/01-编程语言/02-Python/Python/python基础语法.md`

---
tags:
  - Python
  - 编程语言
  - 基础语法
created: 2024-01-01
updated: 2026-03-29
status: final
confidence: high
---

最大的数 inf = int(1e9)

1、包的引入
#你提供的代码片段是从一个模块中导入多个类。具体来说，这些类是从 ..nodes 模块中导入的
from ..nodes import (
    FetchNode,
    ParseNode,
    RAGNode,
    GenerateAnswerNode
)
#node文件夹__init__.py的使用
from .base_node import BaseNode
from .fetch_node import FetchNode
from .rag_node import RAGNode
from .generate_answer_node import GenerateAnswerNode

如果引入的是方法，直接引入包中的文件
mypackage/
    __init__.py
    mymodule.py
from mypackage import mymodule

2、schema 是可选参数，类型为 BaseModel 或 None，默认值为 None
def __init__(self, prompt: str, source: str, config: dict, schema: Optional[BaseModel] = None)

3、字典合并
llm_params = {**llm_defaults, **llm_config}

4、@property 装饰器将方法转换为属性，使得方法可以像属性一样被访问
class ChatModel:
    @property
    def _llm_type(self) -> str:
        """Return type of chat model."""
        return "ollama-chat"


5、__setitem__ 和 __delitem__

class MyClass:
    def __init__(self):
        self.data = {}

    def __setitem__(self, key, value):
        self.data[key] = value

    def __delitem__(self, key):
        del self.data[key]

obj = MyClass()
obj['key1'] = 'value1'  # Calls __setitem__('key1', 'value1')
print(obj.data)  # {'key1': 'value1'}

del obj['key1']  # Calls __delitem__('key1')
print(obj.data)  # {}


6、单例模式模式 

def singleton(cls):
    instances = {}

    def get_instance(*args, **kwargs):
        if cls not in instances:
            instances[cls] = cls(*args, **kwargs)
        return instances[cls]

    return get_instance


使用：
@singleton
class Bridge(object):



7、包的使用
project/
├── A/
│   └── a.py
└── B/
│  └── b.py
── main.py

相对引用：from ..A.a import MyClass, my_function
        需要添加__init__.py， 告诉 Python 这些目录是包
绝对引用：from mypackage.A.a import MyClass, my_function
