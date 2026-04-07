---
layout: "post"
title: "AOP和拦截器"
subtitle: "Java开发 / Spring框架 / Spring"
date: "2025-07-31 15:10:26"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - Spring框架
    - Spring
categories:
    - Java开发
---

> 来源：`本机相关/02-Java开发/01-Spring框架/Spring/AOP和拦截器.md`

拦截器更适合处理请求 / 响应生命周期中的通用逻辑，尤其是与 HTTP 请求直接相关的操作。
AOP 更适合处理横切关注点（Cross-cutting Concerns），即与核心业务逻辑无关，但需要在多个地方复用的功能


HTTP请求到达
1. Servlet容器（如Tomcat）接收请求
2. Servlet Filter（若有）执行（先于所有拦截器）
3. Spring MVC拦截器：
   ├─ 拦截器A.preHandle()
   ├─ 拦截器B.preHandle()
4. 进入Controller方法调用阶段（AOP生效）：
   ├─ AspectA.@Before（增强Controller方法）
   ├─ AspectB.@Before
   ├─ Controller目标方法执行
   ├─ AspectB.@AfterReturning
   ├─ AspectB.@After
   ├─ AspectA.@AfterReturning
   └─ AspectA.@After
5. Spring MVC拦截器后续处理：
   ├─ 拦截器B.postHandle()
   ├─ 拦截器A.postHandle()
   ├─ 视图渲染
   ├─ 拦截器B.afterCompletion()
   └─ 拦截器A.afterCompletion()


# AOP
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class LoggingAspect {
    @Pointcut("execution(* com.example.service.*.*(..))")
    public void serviceMethods() {}

    @Before("serviceMethods()")
    public void beforeAdvice() {
        System.out.println("Before method execution");
    }
}


#拦截器
import org.springframework.web.servlet.HandlerInterceptor;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AuthInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, 
                             HttpServletResponse response, 
                             Object handler) throws Exception {
        // 身份验证逻辑
        String token = request.getHeader("Authorization");
        if (token == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return false;
        }
        return true;
    }
}
