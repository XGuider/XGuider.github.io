---
layout: "post"
title: "设计模式解决问题"
subtitle: "Java开发 / Spring框架 / Spring"
date: "2024-12-26 21:56:15"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - Spring框架
    - Spring
categories:
    - Java开发
---

> 来源：`本机相关/02-Java开发/01-Spring框架/Spring/设计模式解决问题.md`

一、优化if...else
开闭原则：对扩展开放，对修改关闭。就是说增加新功能要尽量少改动已有代码。
单一职责原则：顾名思义，要求逻辑尽量单一，不要太复杂，便于复用
策略模式+工厂模式
public interface IPay {
    void pay();
}

@Service
public class AliaPay implements IPay {
    @PostConstruct
    public void init() {
        PayStrategyFactory.register("aliaPay", this);
    }

    @Override
    public void pay() {
        System.out.println("===发起支付宝支付===");
    }
}

@Servicepublic
class WeixinPay implements IPay {
    @PostConstruct
    public void init() {
        PayStrategyFactory.register("weixinPay", this);
    }

    @Override
    public void pay() {
        System.out.println("===发起微信支付===");
    }
}

@Servicepublic
class JingDongPay implements IPay {
    @PostConstruct
    public void init() {
        PayStrategyFactory.register("jingDongPay", this);
    }

    @Override
    public void pay() {
        System.out.println("===发起京东支付===");
    }
}

public class PayStrategyFactory {
    private static Map<String, IPay> PAY_REGISTERS = new HashMap<>();

    public static void register(String code, IPay iPay) {
        if (null != code && !"".equals(code)) {
            PAY_REGISTERS.put(code, iPay);
        }
    }

    public static IPay get(String code) {
        return PAY_REGISTERS.get(code);
    }
}

@Servicepublic
class PayService3 {
    public void toPay(String code) {
        PayStrategyFactory.get(code).pay();
    }
}
二、责任链模式
下面介绍其应用场景，责任链模式通常在以下几种情况使用。
1.有多个对象可以处理一个请求，哪个对象处理该请求由运行时刻自动确定。
2.可动态指定一组对象处理请求，或添加新的处理者。
3.在不明确指定请求处理者的情况下，向多个处理者中的一个提交请求。
package chainOfResponsibility;
public class LeaveApprovalTest
{
    public static void main(String[] args)
    {
        //组装责任链 
        Leader teacher1=new ClassAdviser();
        Leader teacher2=new DepartmentHead();
        Leader teacher3=new Dean();
        //Leader teacher4=new DeanOfStudies();
        teacher1.setNext(teacher2);
        teacher2.setNext(teacher3);
        //teacher3.setNext(teacher4);
        //提交请求 
        teacher1.handleRequest(8);
    }
}
//抽象处理者：领导类
abstract class Leader
{
    private Leader next;
    public void setNext(Leader next)
    {
        this.next=next; 
    }
    public Leader getNext()
    { 
        return next; 
    }   
    //处理请求的方法
    public abstract void handleRequest(int LeaveDays);       
}
//具体处理者1：班主任类
class ClassAdviser extends Leader
{
    public void handleRequest(int LeaveDays)
    {
        if(LeaveDays<=2) 
        {
            System.out.println("班主任批准您请假" + LeaveDays + "天。");       
        }
        else
        {
            if(getNext() != null) 
            {
                getNext().handleRequest(LeaveDays);             
            }
            else
            {
                  System.out.println("请假天数太多，没有人批准该假条！");
            }
        } 
    } 
}
//具体处理者2：系主任类
class DepartmentHead extends Leader
{
    public void handleRequest(int LeaveDays)
    {
        if(LeaveDays<=7) 
        {
            System.out.println("系主任批准您请假" + LeaveDays + "天。");       
        }
        else
        {
            if(getNext() != null) 
            {
                  getNext().handleRequest(LeaveDays);             
            }
            else
            {
                System.out.println("请假天数太多，没有人批准该假条！");
           }
        } 
    } 
}
//具体处理者3：院长类
class Dean extends Leader
{
    public void handleRequest(int LeaveDays)
    {
        if(LeaveDays<=10) 
        {
            System.out.println("院长批准您请假" + LeaveDays + "天。");       
        }
        else
        {
              if(getNext() != null) 
            {
                getNext().handleRequest(LeaveDays);             
            }
            else
            {
                  System.out.println("请假天数太多，没有人批准该假条！");
            }
        } 
    } 
}
//具体处理者4：教务处长类
class DeanOfStudies extends Leader
{
    public void handleRequest(int LeaveDays)
    {
        if(LeaveDays<=20) 
        {
            System.out.println("教务处长批准您请假"+LeaveDays+"天。");       
        }
        else
        {
              if(getNext()!=null) 
            {
                getNext().handleRequest(LeaveDays);          
            }
            else
            {
                  System.out.println("请假天数太多，没有人批准该假条！");
            }
        } 
    } 
}
三、解决代码相同类问题
模板方法模式
// 商户A处理句柄
CompanyAHandler implements RequestHandler {
   Resp hander(req){
   //查询商户信息
   queryMerchantInfo();
   //加签
   signature();
   //http请求（A商户假设走的是代理）
   httpRequestbyProxy()
   //验签
   verify();
   }
}
// 商户B处理句柄
CompanyBHandler implements RequestHandler {
   Resp hander(Rreq){
   //查询商户信息
   queryMerchantInfo();
   //加签
   signature();
   // http请求（B商户不走代理，直连）
   httpRequestbyDirect();
   // 验签
   verify(); 
   }
}
优化
abstract class AbstractMerchantService  { 

     //模板方法流程
     Resp handlerTempPlate(req){
           //查询商户信息
           queryMerchantInfo();
           //加签
           signature();
           //http 请求
           httpRequest();
           // 验签
           verifySinature();
     }
      // Http是否走代理（提供给子类实现）
      abstract boolean isRequestByProxy();
}


四、代理模式
4.1 静态代理
// 目标对象接口
interface IUserService {
    void save();
}

// 被代理的目标对象
class UserServiceImpl implements IUserService {
    @Override
    public void save() {
        System.out.println("UserServiceImpl save()");
    }
}

// 静态代理对象
class UserServiceProxy implements IUserService {
    private IUserService userService;

    public UserServiceProxy(IUserService userService) {
        this.userService = userService;
    }

    @Override
    public void save() {
        System.out.println("Before proxy operation.");
        userService.save();
        System.out.println("After proxy operation.");
    }
}

public class StaticProxyDemo {
    public static void main(String[] args) {
        IUserService userService = new UserServiceImpl();
        IUserService proxy = new UserServiceProxy(userService);
        proxy.save();
    }
}

4.2 动态代理
import java.lang.reflect.*;

// 目标对象
class UserServiceImpl {
    public void save() {
        System.out.println("UserServiceImpl save()");
    }
}

// 动态代理工厂
class ProxyFactory {
    private Object target;

    public ProxyFactory(Object target) {
        this.target = target;
    }

    public Object getProxyInstance() {
        return Proxy.newProxyInstance(
                target.getClass().getClassLoader(),
                target.getClass().getInterfaces(),
                new InvocationHandler() {
                    @Override
                    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                        System.out.println("Before operation by dynamic proxy.");
                        Object result = method.invoke(target, args);
                        System.out.println("After operation by dynamic proxy.");
                        return result;
                    }
                }
        );
    }
}
public class DynamicProxyDemo {
    public static void main(String[] args) {
        UserServiceImpl target = new UserServiceImpl();
        ProxyFactory factory = new ProxyFactory(target);
        IUserService proxyInstance = (IUserService) factory.getProxyInstance();
        proxyInstance.save();
    }
}
4.3 CGLib 代理

import net.sf.cglib.proxy.Enhancer;
import net.sf.cglib.proxy.MethodInterceptor;
import net.sf.cglib.proxy.ReflectUtils;

// 目标对象类
class UserServiceImpl {
    public void save() {
        System.out.println("UserServiceImpl save()");
    }
}

// CGLib 代理类
class CGLibProxy implements MethodInterceptor {
    private Object target;

    public CGLibProxy(Object target) {
        this.target = target;
    }

    public Object getProxy() {
        Enhancer enhancer = new Enhancer();
        enhancer.setSuperclass(target.getClass());
        enhancer.setCallback(this);
        return enhancer.create();
    }

    @Override
    public Object intercept(Object obj, Method method, Object[] args, MethodProxy methodProxy) throws Throwable {
        System.out.println("Before operation by CGLib.");
        Object result = methodProxy.invokeSuper(obj, args);
        System.out.println("After operation by CGLib.");
        return result;
    }

    public static void main(String[] args) {
        UserServiceImpl target = new UserServiceImpl();
        CGLibProxy cgLibProxy = new CGLibProxy(target);
        UserServiceImpl proxy = (UserServiceImpl) cgLibProxy.getProxy();
        proxy.save();
    }
}
