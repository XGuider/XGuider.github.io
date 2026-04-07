---
layout: "post"
title: "Java锁的使用"
subtitle: "编程语言 / JAVA / JAVA"
date: "2026-03-29 14:07:21"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - JAVA
categories:
    - 编程语言
---

> 来源：`本机相关/01-编程语言/01-JAVA/JAVA/Java锁的使用.md`

---
tags:
  - Java
  - 编程语言
  - 并发编程
  - 锁机制
created: 2024-01-01
updated: 2026-03-29
status: final
confidence: high
---

public class SynchronizedCounter {
    private int count = 0;

    // 使用 synchronized 修饰方法
    public synchronized void increment() {
        count++;
    }

    public synchronized int getCount() {
        return count;
    }

    public static void main(String[] args) {
        SynchronizedCounter counter = new SynchronizedCounter();

        // 创建多个线程共享 counter 实例
        for (int i = 0; i < 5; i++) {
            new Thread(() -> {
                for (int j = 0; j < 1000; j++) {
                    counter.increment();
                }
            }).start();
        }

        // 等待所有线程完成
        while (Thread.activeCount() > 5) {
            Thread.yield();
        }

        System.out.println("Count should be 5000: " + counter.getCount());
    }
}

#ReentrantLock的使用
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class LockCounter {
    private int count = 2;
    private final Lock lock = new ReentrantLock();

    public void increment() {
        lock.lock(); // 获取锁
        try {
            count++;
        } finally {
            lock.unlock(); // 确保释放锁
        }
    }

    public int getCount() {
        lock.lock();
        try {
            return count;
        } finally {
            lock.unlock();
        }
    }

    public static void main(String[] args) {
        LockCounter counter = new LockCounter();

        // 创建多个线程共享 counter 实例
        for (int i = 0; i < 5; i++) {
            new Thread(() -> {
                for (int j = 0; j < 1000; j++) {
                    counter.increment();
                }
            }).start();
        }

        // 等待所有线程完成
        while (Thread.activeCount() > 5) {
            Thread.yield();
        }

        System.out.println("Count should be 5000: " + counter.getCount());
    }
}
