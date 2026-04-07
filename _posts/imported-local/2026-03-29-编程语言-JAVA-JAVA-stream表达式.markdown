---
layout: "post"
title: "stream表达式"
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

> 来源：`本机相关/01-编程语言/01-JAVA/JAVA/stream表达式.md`

---
tags:
  - Java
  - 编程语言
  - Stream
  - 函数式编程
created: 2024-01-01
updated: 2026-03-29
status: final
confidence: high
---

# filter(Predicate<T> predicate): 过滤元素
List<String> words = Arrays.asList("apple", "pie", "banana", "cherry");
List<String> longWords = words.stream()
                              .filter(w -> w.length() > 5)
                              .collect(Collectors.toList());
// 结果: ["banana", "cherry"]
# map(Function<T, R> mapper): 转换元素类型或值
List<String> words = Arrays.asList("apple", "pie", "banana");
List<Integer> wordLengths = words.stream()
                                 .map(String::length) // Lambda: w -> w.length()
                                 .collect(Collectors.toList());
// 结果: [5, 3, 6]

# flatMap(Function<T, Stream<R>> mapper): 将每个元素转换为流，然后将所有流扁平化为一个流
List<List<String>> listOfLists = Arrays.asList(
    Arrays.asList("a", "b"),
    Arrays.asList("c", "d", "e")
);
List<String> flattened = listOfLists.stream()
                                    .flatMap(List::stream) // 或 l -> l.stream()
                                    .collect(Collectors.toList());
// 结果: ["a", "b", "c", "d", "e"]

#distinct(): 去除重复元素
List<Integer> numbers = Arrays.asList(1, 2, 1, 3, 2, 4);
List<Integer> uniqueNumbers = numbers.stream()
                                     .distinct()
                                     .collect(Collectors.toList());
// 结果: [1, 2, 3, 4]

# sorted(): 自然排序（需元素实现 Comparable）
List<String> words = Arrays.asList("banana", "apple", "cherry");
List<String> sortedWords = words.stream()
                                .sorted()
                                .collect(Collectors.toList());
// 结果: ["apple", "banana", "cherry"]

#peek(Consumer<T> action): 对每个元素执行操作（主要用于调试）
List<String> words = Arrays.asList("apple", "banana");
List<String> upperWords = words.stream()
                               .peek(System.out::println) // 打印每个元素
                               .map(String::toUpperCase)
                               .peek(System.out::println) // 打印转换后的元素
                               .collect(Collectors.toList());

#reduce(BinaryOperator<T> accumulator): 规约（聚合）为单个值（Optional）
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);
Optional<Integer> sum = numbers.stream().reduce((a, b) -> a + b);
// 结果: Optional[15]
Optional<Integer> product = numbers.stream().reduce((a, b) -> a * b);
// 结果: Optional[120]


#collect(Collector<T, A, R> collector): 使用 Collector 将元素收集到集合或其他结构中
List<String> words = Arrays.asList("apple", "pie", "banana");
Set<String> wordSet = words.stream().collect(Collectors.toSet());
