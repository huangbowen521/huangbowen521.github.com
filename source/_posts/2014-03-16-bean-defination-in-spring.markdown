---
layout: post
title: Spring-Context之四:Spring容器及bean的定义
date: 2014-03-16 02:29
comments: true
categories: Spring-Context
---

Spring框架的核心功能之一就是控制反转（Inversion of Control, IoC），也叫做依赖注入（dependency injection, DI）。关于依赖注入的具体内容可以参见Martin Fowler写的一篇文章[《Inversion of Control Containers and the Dependency Injection pattern》](http://martinfowler.com/articles/injection.html)。

<!-- more -->

Spring容器接口是BeanFactory，其提供了一些方法来配置和管理对象。ApplicationContext是BeanFactory的子接口，它集成了Spring的AOP特性，信息资源管理（用于全球化），公共事件等。简单的说，BeanFactory提供了配置框架及基本的功能，而ApplicationContext增加了更多的企业级定制功能。比如其实现类WebApplicationContext可用于web应用程序中。

在Spring中，应用程序中受Spring IoC容器管理的对象叫做bean，即bean是一个由Spring IoC容器实例化、装配及其它管理的对象。下图是Spring IoC容器的一个简单图解。

{% img /images/iocOverView.png %}

以下列出了几个常用的实现了ApplicationContext的容器对象。

* AnnotationConfigApplicationContext :接收注解的class作为输入来初始化配置。

* GenericGroovyApplicationContext: 根据Groovy DSL来初始化配置。

* ClassPathXmlApplicationContext:根据当前classpath下的xml文件初始化配置。

* FileSystemXmlApplicationContext:根据文件系统路径下的xml文件初始化配置。

Bean的定义有多种方式，XML定义，Annoation定义，Java代码直接定义，Groovy DSL定义等。之前例子基本都演示过这些定义方法。

一个简单的XML定义是这样的。

```xml

<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="movieService" class="huangbowen.net.service.DefaultMovieService”/>

</beans>

```

其包含一个id和一个class。id是一个bean的唯一标示，同一个spring容器中不能有两个id一样的bean，不过你也可以给bean起别名，使用name属性即可，多个别名可以用逗号,分号或空格分开。

```xml

<bean id="movieService" name="service1 service2" class="huangbowen.net.service.DefaultMovieService"/>

```

```xml

<bean id="movieService" name=“service1,service2" class="huangbowen.net.service.DefaultMovieService"/>

```

```xml

<bean id="movieService" name="service1;service2" class="huangbowen.net.service.DefaultMovieService"/>

```

也可以使用alisa来起别名。

```xml

<bean id="movieService" name="service1,service2" class="huangbowen.net.service.DefaultMovieService"/>

<alias name="movieService" alias="service3"/>

```

如果你的bean的实例不是通过构造函数直接生成的，而是通过工厂方法生成那，那么也有相应的配置方法。

```xml

<bean id="defaultMovieService" class="huangbowen.net.service.MovieServiceFactory" factory-method="GetMovieService" />

```

```java MovieServiceFactory 

package huangbowen.net.service;

public class MovieServiceFactory {

    private static DefaultMovieService defaultMovieService = new DefaultMovieService();

    public static MovieService GetMovieService() {
        return defaultMovieService;
    }
}

```

如果bean对象是由一个实例工厂生成的，那么应该这样配置。

```xml

    <bean id="serviceLocator" class="huangbowen.net.service.MovieServiceLocator"/>

    <bean id="instantMovieService" factory-bean="serviceLocator" factory-method="GetMovieService"/>

```

```java MovieServiceLocator

package huangbowen.net.service;

public class MovieServiceLocator {

    private static DefaultMovieService defaultMovieService = new DefaultMovieService();

    public MovieService GetMovieService() {
        return defaultMovieService;
    }
}

```

本例中的源码请在[我的GitHub](https://github.com/huangbowen521/Study)上自行下载。


