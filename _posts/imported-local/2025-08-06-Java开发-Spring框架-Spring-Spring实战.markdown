---
layout: "post"
title: "Spring实战"
subtitle: "Java开发 / Spring框架 / Spring"
date: "2025-08-06 15:55:38"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - Spring框架
    - Spring
categories:
    - Java开发
---

{% raw %}
> 来源：`本机相关/02-Java开发/01-Spring框架/Spring/Spring实战.md`

一 如何获取spring容器对象
@Service
public class PersonService implements BeanFactoryAware {
    private BeanFactory beanFactory;

    @Override
    public void setBeanFactory(BeanFactory beanFactory) throws BeansException {
        this.beanFactory = beanFactory;
    }

    public void add() {
        Person person = (Person) beanFactory.getBean("person");
    }
}

@Service
public class PersonService2 implements ApplicationContextAware {
    private ApplicationContext applicationContext;

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        this.applicationContext = applicationContext;
    }

    public void add() {
        Person person = (Person) applicationContext.getBean("person");
    }

}
二 轻松自定义类型转换
spring目前支持3中类型转换器：
- Converter<S,T>：将 S 类型对象转为 T 类型对象
- ConverterFactory<S, R>：将 S 类型对象转为 R 类型及子类对象
- GenericConverter：它支持多个source和目标类型的转化，同时还提供了source和目标类型的上下文，这个上下文能让你实现基于属性上的注解或信息来进行类型转换。
这3种类型转换器使用的场景不一样，我们以Converter<S,T>为例。
假如：接口中接收参数的实体对象中，有个字段的类型是Date，但是实际传参的是字符串类型：2021-01-03 10:20:15，要如何处理呢？
第一步，定义一个实体User：
@Data
public class User {

    private Long id;
    private String name;
    private Date registerDate;
}
第二步，实现Converter接口：
public class DateConverter implements Converter<String, Date> {

    private SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    @Override
    public Date convert(String source) {
        if (source != null && !"".equals(source)) {
            try {
                simpleDateFormat.parse(source);
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        return null;
    }
}
第三步，将新定义的类型转换器注入到spring容器中：
@Configuration
public class WebConfig extends WebMvcConfigurerAdapter {

    @Override
    public void addFormatters(FormatterRegistry registry) {
        registry.addConverter(new DateConverter());
    }
}
第四步，调用接口
@RequestMapping("/user")
@RestController
public class UserController {

    @RequestMapping("/save")
    public String save(@RequestBody User user) {
        return "success";
    }

三 spring mvc拦截器

spring mvc拦截器根spring拦截器相比，它里面能够获取HttpServletRequest和HttpServletResponse 等web对象实例。
HandlerInterceptor接口的实现类HandlerInterceptorAdapter类
spring mvc拦截器的顶层接口是：HandlerInterceptor，包含三个方法：
- preHandle 目标方法执行前执行
- postHandle 目标方法执行后执行
- afterCompletion 请求完成时执行
假如有权限认证、日志、统计的场景，可以使用该拦截器
第一步，继承HandlerInterceptorAdapter类定义拦截器：
public class AuthInterceptor extends HandlerInterceptorAdapter {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String requestUrl = request.getRequestURI();
        if (checkAuth(requestUrl)) {
            return true;
        }

        return false;
    }

    /**
     * 处理中
     */
    @Override
    public void postHandle(HttpServletRequest arg0, HttpServletResponse arg1, Object handler, ModelAndView modelAndView)
            throws Exception {
        HandlerMethod handlerMethod = (HandlerMethod) handler;
        this.log.info("[****BaseInterceptor.postHandle()控制器处理中****]" + 
                handlerMethod.getBean().getClass().getSimpleName());
        this.log.info("[****BaseInterceptor.postHandle()****]" + modelAndView);
    }
 
    /**
     * 处理后
     */
    @Override
    public void afterCompletion(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, Exception arg3)
            throws Exception {
        this.log.info("[****BaseInterceptor.afterCompletion()控制器处理后****]拦截处理完毕");
    }


    private boolean checkAuth(String requestUrl) {
        System.out.println("===权限校验===");
        return true;
    }
}
第二步，将该拦截器注册到spring容器，自动加载使用
@Configuration
public class WebAuthConfig extends WebMvcConfigurerAdapter {
 
    @Bean
    public AuthInterceptor getAuthInterceptor() {
        return new AuthInterceptor();
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new AuthInterceptor());
    }
}
第三步，在请求接口时spring mvc通过该拦截器，能够自动拦截该接口，并且校验权限


四、基于Spring实现异步请求
对于一次请求（/email），基于Callable的处理流程如下：
1、Spring MVC开启副线程处理业务(将Callable提交到TaskExecutor)；
2、DispatcherServlet和所有的Filter退出Web容器的线程，但是response保持打开状态；
3、Callable返回结果，SpringMVC将原始请求重新派发给容器(再重新请求一次/email)，恢复之前的处理；
4、DispatcherServlet重新被调用，将结果返回给用户；

@GetMapping("/email")
public Callable<String> order() {
    System.out.println("主线程开始：" + Thread.currentThread().getName());
    Callable<String> result = () -> {
        System.out.println("副线程开始：" + Thread.currentThread().getName());
        Thread.sleep(1000);
        System.out.println("副线程返回：" + Thread.currentThread().getName());
        return "success";
    };

    System.out.println("主线程返回：" + Thread.currentThread().getName());
    return result;
}
返回：
主线程开始：http-nio-8080-exec-1
主线程返回：http-nio-8080-exec-1
副线程开始：task-1
副线程返回：task-1

Callable默认使用SimpleAsyncTaskExecutor类来执行，这个类非常简单而且没有重用线程。在实践中，需要使用AsyncTaskExecutor类来对线程进行配置。
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Resource
    private ThreadPoolTaskExecutor myThreadPoolTaskExecutor;

    /**
     * 配置线程池
     */
    @Bean(name = "asyncPoolTaskExecutor")
    public ThreadPoolTaskExecutor getAsyncThreadPoolTaskExecutor() {
        ThreadPoolTaskExecutor taskExecutor = new ThreadPoolTaskExecutor();
        taskExecutor.setCorePoolSize(2);
        taskExecutor.setMaxPoolSize(10);
        taskExecutor.setQueueCapacity(25);
        taskExecutor.setKeepAliveSeconds(200);
        taskExecutor.setThreadNamePrefix("thread-pool-");
        // 线程池对拒绝任务（无线程可用）的处理策略，目前只支持AbortPolicy、CallerRunsPolicy；默认为后者
        taskExecutor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        taskExecutor.initialize();
        return taskExecutor;
    }

    @Override
    public void configureAsyncSupport(final AsyncSupportConfigurer configurer) {
        // 处理callable超时
        configurer.setDefaultTimeout(60 * 1000);
        configurer.setTaskExecutor(myThreadPoolTaskExecutor);
        configurer.registerCallableInterceptors(timeoutCallableProcessingInterceptor());
    }

    @Bean
    public TimeoutCallableProcessingInterceptor timeoutCallableProcessingInterceptor() {
        return new TimeoutCallableProcessingInterceptor();
    }
}
五、Spring使用策略模式
一、定义接口
public interface IFileStrategy {
    
    //属于哪种文件解析类型
    FileTypeResolveEnum gainFileType();
    
    //封装的公用算法（具体的解析方法）
    void resolve(Object objectparam);
}
二、实现接口
@Component
public class AFileResolve implements IFileStrategy {
    
    @Override
    public FileTypeResolveEnum gainFileType() {
        return FileTypeResolveEnum.File_A_RESOLVE;
    }

    @Override
    public void resolve(Object objectparam) {
      logger.info("A 类型解析文件，参数：{}",objectparam);
      //A类型解析具体逻辑
    }
}
三、加载服务到Context服务中
@Component
public class StrategyUseService implements ApplicationContextAware{

  
    private Map<FileTypeResolveEnum, IFileStrategy> iFileStrategyMap = new ConcurrentHashMap<>();

    public void resolveFile(FileTypeResolveEnum fileTypeResolveEnum, Object objectParam) {
        IFileStrategy iFileStrategy = iFileStrategyMap.get(fileTypeResolveEnum);
        if (iFileStrategy != null) {
            iFileStrategy.resolve(objectParam);
        }
    }

    //把不同策略放到map
    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        Map<String, IFileStrategy> tmepMap = applicationContext.getBeansOfType(IFileStrategy.class);
        tmepMap.values().forEach(strategyService -> iFileStrategyMap.put(strategyService.gainFileType(), strategyService));
    }
}

六、Sping 责任链的使用
1、定义抽象类
public abstract class AbstractHandler {
    //责任链中的下一个对象
    private AbstractHandler nextHandler;
    /**
     * 责任链的下一个对象
     */
    public void setNextHandler(AbstractHandler nextHandler){
        this.nextHandler = nextHandler;
    }
    /**
     * 具体参数拦截逻辑,给子类去实现
     */
    public void filter(Request request, Response response) {
        doFilter(request, response);
        if (getNextHandler() != null) {
            getNextHandler().filter(request, response);
        }
    }

    public AbstractHandler getNextHandler() {
        return nextHandler;
    }

     abstract void doFilter(Request filterRequest, Response response);

}
2、实现抽象类
@Component
@Order(1) //顺序排第1，最先校验
public class CheckParamFilterObject extends AbstractHandler {

    @Override
    public void doFilter(Request request, Response response) {
        System.out.println("非空参数检查");
    }
}

/**
 *  安全校验对象
 */
@Component
@Order(2) //校验顺序排第2
public class CheckSecurityFilterObject extends AbstractHandler {

    @Override
    public void doFilter(Request request, Response response) {
        //invoke Security check
        System.out.println("安全调用校验");
    }
}
3、对象链连起来（初始化）&& 使用
@Component("ChainPatternDemo")
public class ChainPatternDemo {

    //自动注入各个责任链的对象
    @Autowired
    private List<AbstractHandler> abstractHandleList;

    private AbstractHandler abstractHandler;

    //spring注入后自动执行，责任链的对象连接起来
    @PostConstruct
    public void initializeChainFilter(){
        for(int i = 0;i<abstractHandleList.size();i++){
            if(i == 0){
                abstractHandler = abstractHandleList.get(0);
            }else{
                AbstractHandler currentHander = abstractHandleList.get(i - 1);
                AbstractHandler nextHander = abstractHandleList.get(i);
                currentHander.setNextHandler(nextHander);
            }
        }
    }

    //直接调用这个方法使用
    public Response exec(Request request, Response response) {
        abstractHandler.filter(request, response);
        return response;
    }

    public AbstractHandler getAbstractHandler() {
        return abstractHandler;
    }

    public void setAbstractHandler(AbstractHandler abstractHandler) {
        this.abstractHandler = abstractHandler;
    }
}
七、观察者模式使用
使用场景： 完成某件事情后，异步通知场景。如，登陆成功，发个IM消息等等
一个对象（被观察者）的状态发生改变，所有的依赖对象（观察者对象）都将得到通知，进行广播通知。它的主要成员就是观察者和被观察者。
1. 定义事件
import org.springframework.context.ApplicationEvent;
public class CustomEvent extends ApplicationEvent {
    private String message;

    public CustomEvent(Object source, String message) {
        super(source);
        this.message = message;
    }

    public String getMessage() {
        return message;
    }
}
2. 发布事件
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
@Service
public class EventService {
    @Autowired
    private ApplicationEventPublisher publisher;

    public void publishEvent(String message) {
        CustomEvent event = new CustomEvent(this, message);
        publisher.publishEvent(event);
    }
}
3. 监听事件
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;
@Component
// public class EventListener implements ApplicationListener<CustomEvent> {
public class AnotherEventListener {

    // @EventListener
    // public void handleCustomEvent(CustomEvent event) {
    //     // 处理事件
    //     System.out.println("Another listener received event with message: " + event.getMessage());
    // }

    @Override
    public void onApplicationEvent(CustomEvent event) {
        String message = event.getMessage();
        // 处理事件
        System.out.println("Received event with message: " + message);
    }
}

4、使用
public class Application {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        EventService eventService = context.getBean(EventService.class);
        eventService.publishEvent("Hello, Spring Event!");
        context.close();
    }
}


八、异步调用
1、替换try catch使用注解
@RestControllerAdvice

import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

public class CompletableFutureExample {
    public static void main(String[] args) throws InterruptedException, ExecutionException {
        // 假设这是从某处获取的ID和userInfo
        int id = 1; // 示例ID
        String userInfo = "User Info"; // 示例userInfo

        // 创建一个单线程的ExecutorService
        ExecutorService executorService = Executors.newSingleThreadExecutor();

        try {
            // 使用CompletableFuture来异步执行任务
            CompletableFuture<String> cf = CompletableFuture.supplyAsync(() -> getRemoteUserAndFill(id, userInfo), executorService)
                    .thenApply(data -> sendData(data));

            // 获取CompletableFuture的结果，这将阻塞直到任务完成
            String result = cf.get();
            System.out.println("Result: " + result);
        } finally {
            // 关闭ExecutorService来释放资源
            executorService.shutdown();
            if (!executorService.awaitTermination(5, TimeUnit.SECONDS)) {
                System.out.println("Executor service did not terminate in the given time.");
            }
        }
    }
    // 模拟从远程获取用户信息并填充的方法
    private static String getRemoteUserAndFill(int id, String userInfo) {
        // 这里是模拟的远程调用，实际开发中可能是网络请求等操作
        try {
            Thread.sleep(1000); // 模拟耗时操作
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        return "Fetched user info for ID " + id + ": " + userInfo;
    }

    // 模拟发送数据的方法
    private static String sendData(String data) {
        // 这里是模拟发送数据的逻辑
        try {
            Thread.sleep(1000); // 模拟耗时操作
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        return "Data sent successfully: " + data;
    }
}


2、某个接口批量查询数据，远程调用接口，会发现该用户查询接口经常超时。
    1、同步调用
    List<List<Long>> allIds = Lists.partition(ids,200);
    for(List<Long> batchIds:allIds) {
       List<User> users = remoteCallUser(batchIds);
    }
    2、异步调用
    import com.google.common.collect.Lists;
    import java.util.List;
    import java.util.concurrent.CompletableFuture;
    import java.util.concurrent.ExecutorService;
    import java.util.concurrent.Executors;
    import java.util.stream.Collectors;

    // 假设 User 和 remoteCallUser 方法已经定义好

    public class AsyncExample {

        public static void main(String[] args) {
            List<Long> ids = // ... 初始化你的ids列表
            ExecutorService executor = Executors.newFixedThreadPool(10);
            List<User> result = Lists.newArrayList();

            try {
                List<List<Long>> allIds = Lists.partition(ids, 200);
                allIds.stream()
                    .map(batchIds -> CompletableFuture.supplyAsync(() -> {
                        result.addAll(remoteCallUser(batchIds));
                        return Boolean.TRUE;
                    }, executor))
                    .collect(Collectors.toList())
                    .forEach(future -> {
                        try {
                            future.get(); // 等待每个CompletableFuture完成
                        } catch (InterruptedException | ExecutionException e) {
                            e.printStackTrace();
                        }
                    });
            } finally {
                executor.shutdown();
            }

            // 此时 result 包含了所有远程调用的结果
        }

        private static List<User> remoteCallUser(List<Long> batchIds) {
            // 模拟远程调用的实现
            return // ... 返回获取到的用户列表
        }
    }
{% endraw %}
