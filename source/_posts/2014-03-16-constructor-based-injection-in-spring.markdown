---
layout: post
title: Spring-Context之五:基于构造器进行依赖注入
date: 2014-03-16 20:19
comments: true
categories: Spring-Context
---

上一节讲述了如何在XML中定义bean。这些bean都比较简单，基本只是个单一对象。但是在企业级开发中，一个对象或多或少都要跟其他对象发生关联，比如继承、调用、实现接口等。传统的方法中，如果对象A某方法的实现要调用对象B的方法，那么一般由对象A来维护对象B的生命周期，包括创建、调用、销毁等。而引入了控制反转（即依赖注入）以后，对象A只管负责对对象B的调用，对象B的整个声明周期都交由IoC容器管理。甚至对象A在实现时基于接口实现，IoC容器可以按需注入实现了指定接口的对象到对象A中，这样无需修改任何代码就可以灵活的实现需求变动。

<!-- more -->

Spring中对bean的依赖注入主要有两种方式，一种是基于构造器注入，一种是基于Setter方法注入。

以下是构造方法注入的一个简单例子。


```java 


public class MessageHandler {

    private MessageService messageService;

    public MessageHandler(MessageService messageService) {
        this.messageService = messageService;
    }

    public String handle() {
        return messageService.sendService();
    }
}

``` 

```xml

<bean id="messageService" class="huangbowen.net.DependecyInjection.ConstructorInjection.SimpleMessageService"/>

<bean id="messageHandler" class="huangbowen.net.DependecyInjection.ConstructorInjection.MessageHandler">
    <constructor-arg ref="messageService"/>
</bean>

```

这里的java对象是POJO（plain old java object）的，说明了Spring框架是无侵入性的。在xml中通过constructor-arg属性来向MessageHandler注入对象，ref指向了另一个bean。

由于该构造函数只有一个参数，所以无需指明注入的是哪个参数。

如果构造函数有多个参数，那么有很多方式可以指定注入的对象与参数的对应关系。

可以通过索引来指定。

```xml

<bean id="person" class="huangbowen.net.DependecyInjection.ConstructorInjection.Person">
    <constructor-arg index="0" value="Tom"/>
    <constructor-arg index="1" value="20"/>
</bean>

```

也可以通过类型来指定。

```xml

<bean id="person" class="huangbowen.net.DependecyInjection.ConstructorInjection.Person">
    <constructor-arg type="java.lang.String" value="Tom"/>
    <constructor-arg type="int" value="20"/>
</bean>

```

这要求两个类型不能一样或者不能有继承关系，要不然Spring就不知道映射关系了。如果出现了这样的情况，就需要借助其它的方式来告诉Spring你的参数映射关系。

也可以通过参数名来指定。

```xml

<bean id="person" class="huangbowen.net.DependecyInjection.ConstructorInjection.Person">
    <constructor-arg name="name" value="Tom"/>
    <constructor-arg name="age" value="20"/>
</bean>

```

这种注入方法有个风险就是如果你的源代码在编译时关闭了debug标志，那么Spring就无法获取构造器的参数名了。不过可以使用@ConstructorProperties 属性显式指定构造器参数名称。


```java Person.java


public class Person {
    private String name;
    private int age;

    @ConstructorProperties({"name", "age"})
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
}


```


本例中的源码请在[我的GitHub](https://github.com/huangbowen521/Study)上自行下载。










