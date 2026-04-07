---
layout: "post"
title: "Java多线程的使用"
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
> 来源：`本机相关/01-编程语言/01-JAVA/JAVA/Java多线程的使用.md`

---
tags:
  - Java
  - 编程语言
  - 多线程
  - 并发编程
created: 2024-01-01
updated: 2026-03-29
status: final
confidence: high
---

#  start 和 run的区别
class MyRunnable extends Runnable {
    @Override
    public void run() {
        System.out.println("线程运行中...");
    }
}

public class ThreadExample {
    public static void main(String[] args) {
        Runnable myRunnable = new MyRunnable();
        Thread t = new Thread(myRunnable, "Thread-1");
        // 启动线程，这将导致 run() 方法在新线程中异步执行
        t.start();
        // 直接调用 run() 方法，它将在当前线程（main 线程）中同步执行
        t.run();
    }
}
# 创建线程后，记得后面关闭
@PostConstruct
public void start() {
    threadList = new ArrayList<Thread>();
    if (serverSettings.getThreadCount() > 0) {
        running = true;
        for (int i = 0; i < serverSettings.getThreadCount(); i++) {
            int threadId = i;
            Thread thread = new Thread(new Runnable() {
                @Override
                public void run() {
                    work(threadId);
                }
            }, "LogReceiveProcess-" + String.valueOf(i));

            thread.start();
            threadList.add(thread);
        }
    }
}


# 线程池的使用

public class ThreadPoolExecutorExample {
    public static void main(String[] args) {
        // 创建一个固定大小的线程池
        ExecutorService executor = new ThreadPoolExecutor(
            2, // 核心线程数
            4, // 最大线程数
            1, // 空闲线程存活时间
            TimeUnit.MINUTES,
            new LinkedBlockingQueue<Runnable>() // 使用无界队列
        );

        // 提交任务给线程池
        for (int i = 0; i < 10; i++) {
            final int taskNumber = i;
            executor.submit(() -> {
                System.out.println("Executing task " + taskNumber + " using " + Thread.currentThread().getName());
            });
        }

        // 关闭线程池，不再接受新任务
        executor.shutdown();
        try {
            // 等待所有任务完成
            if (!executor.awaitTermination(5, TimeUnit.MINUTES)) {
                System.out.println("Executor did not terminate in the specified time.");
            }
        } catch (InterruptedException e) {
            System.out.println("Executor interrupted.");
        }
    }
}
# 创建线程后，记得后面关闭
    @PostConstruct
    public void start() {
        int threadCount = Math.max(serverSettings.getThreadCount(), 0);
        if (threadCount <= 0) {
            logger.warn("Log receive worker will not start because configured threadCount is {}", threadCount);
            return;
        }
        running = true;
        workerPool = new ThreadPoolExecutor(
                threadCount,
                threadCount,
                0L,
                TimeUnit.MILLISECONDS,
                new LinkedBlockingQueue<>(),
                createWorkerThreadFactory(),
                new ThreadPoolExecutor.AbortPolicy()
        );
        for (int i = 0; i < threadCount; i++) {
            final int threadId = i;
            workerPool.execute(() -> work(threadId));
        }
        logger.info("Log receive worker pool started with {} threads.", threadCount);
    }


// ThreadLocal的使用场景：线程隔离、数据库连接管理
public class UserSessionHolder {
    private static final ThreadLocal<String> userSession = new ThreadLocal<>();

    public static void setUserSession(String sessionId) {
        userSession.set(sessionId);
    }

    public static String getUserSession() {
        return userSession.get();
    }

    public static void clearUserSession() {
        userSession.remove();
    }
}

public class UserService {
    public void processUserRequest() {
        String sessionId = UserSessionHolder.getUserSession();
        System.out.println("Processing request for session: " + sessionId);
        // 处理用户请求的逻辑
    }
}

public class Main {
    public static void main(String[] args) {
        Runnable task = () -> {
            String sessionId = "session-" + Thread.currentThread().getId();
            UserSessionHolder.setUserSession(sessionId);
            try {
                new UserService().processUserRequest();
            } finally {
                UserSessionHolder.clearUserSession();
            }
        };

        Thread t1 = new Thread(task);
        Thread t2 = new Thread(task);
        t1.start();
        t2.start();
    }
}
{% endraw %}
