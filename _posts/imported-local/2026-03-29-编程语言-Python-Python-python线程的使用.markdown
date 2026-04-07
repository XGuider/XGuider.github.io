---
layout: "post"
title: "python线程的使用"
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

> 来源：`本机相关/01-编程语言/02-Python/Python/python线程的使用.md`

---
tags:
  - Python
  - 编程语言
  - 多线程
  - 并发编程
created: 2024-01-01
updated: 2026-03-29
status: final
confidence: high
---

threading.Thread 适用于简单的并发任务，特别是那些不需要大量线程的任务。
ThreadPoolExecutor 适用于需要处理大量并发任务的场景，可以有效地管理线程资源。


import threading
from concurrent.futures import ThreadPoolExecutor

handler_pool = ThreadPoolExecutor(max_workers=8)

class ChatChannel:
    def __init__(self):
        _thread = threading.Thread(target=self.consume)
        _thread.setDaemon(True)
        _thread.start()

    def consume(self):
        while True:
            # 从消息队列中取出消息并提交给线程池处理
            context = get_message_from_queue()
            handler_pool.submit(self._handle, context)

    def _handle(self, context):
        # 处理消息的逻辑
        pass

##threading.BoundedSemaphore， 控制线程数量
import threading
import time
semaphore = threading.BoundedSemaphore(value=3)

def worker(thread_id):
    print(f"Thread {thread_id} is trying to acquire the semaphore")
    semaphore.acquire()
    print(f"Thread {thread_id} has acquired the semaphore")
    time.sleep(2)  # 模拟工作时间
    print(f"Thread {thread_id} is releasing the semaphore")
    semaphore.release()

# 创建并启动多个线程
threads = []
for i in range(10):
    thread = threading.Thread(target=worker, args=(i,))
    threads.append(thread)
    thread.start()

# 等待所有线程完成
for thread in threads:
    thread.join()

print("All threads have finished")
