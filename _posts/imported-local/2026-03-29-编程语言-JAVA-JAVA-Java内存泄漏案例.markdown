---
layout: "post"
title: "Java内存泄漏案例"
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

{% raw %}
> 来源：`本机相关/01-编程语言/01-JAVA/JAVA/Java内存泄漏案例.md`

---
tags:
  - Java
  - 编程语言
  - 内存泄漏
  - JVM
created: 2024-01-01
updated: 2026-03-29
status: final
confidence: high
---

在这个示例中，OuterClass 有一个非静态内部类 InnerClass，它持有对外部类的引用。main 方法中创建了 OuterClass 的实例，并将其内部类的实例存储在列表中。
由于 InnerClass 引用了 OuterClass，即使 OuterClass 的实例在方法调用结束后不再被使用，但由于 InnerClass 实例被长期引用，OuterClass 的实例也不会被垃圾回收，导致内存泄漏。
public class OuterClass {
    private String outerField = "外部类的字段";

    public class InnerClass {
        public void display() {
            System.out.println("内部类持有外部类的引用: " + outerField);
        }
    }

    public InnerClass getInner() {
        return new InnerClass();
    }
}

public class MemoryLeakExample {
    public static void main(String[] args) {
        List<OuterClass.InnerClass> innerList = new ArrayList<>();
        
        for (int i = 0; i < 10000; i++) {
            OuterClass outer = new OuterClass();
            innerList.add(outer.getInner());
        }
    }
}


#栈内容溢出情况
public class StackOverflowExample {
    public static void main(String[] args) {
        StackOverflowExample example = new StackOverflowExample();
        example.recursiveMethod();
    }

    public void recursiveMethod() {
        // 无限递归调用
        recursiveMethod();
    }
}
{% endraw %}
