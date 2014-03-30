---
layout: post
title: Spring-Context之八:一些依赖注入的小技巧
date: 2014-03-30 18:31
comments: true
categories: Spring-Context
---

Spring框架在依赖注入方面是非常灵活和强大的，多了解点一些注入的方式、方法，绝对能优化配置。

<!-- more -->

## idref

idref属性可以传入一个bean的名称，虽然它是指向一个bean的引用，但是得到的是该bean的id名。

```xml 

<beans>

    <bean id="movieService" class="DefaultMovieService"/>

    <bean id="cinema" class=“Cinema">
        <property name="serviceRef">
            <idref bean="movieService"/>
        </property>
    </bean>

</beans>

```

它和直接设置serviceRef属性的value为movieService的区别是前者是能够保证必须有一个名movieService的bean存在于当前的spring容器中，如果没有则Spring容器会在初始化阶段就会报错;而后者仅仅是一个字符串，spring容器在初始化不会做任何检查，很可能将异常推后到运行时抛出。

## 内部bean

bean的定义是可以嵌套的。

```xml

<beans>
     <bean id=“movieService" class="DefaultMovieService"/>
     <bean id="cinema" class=“Cinema">
        <property name="movieService" ref=“movieService"/>
    </bean>
</beans>

```

可以改为这种方式。

```xml

    <bean id="cinema" class="Cinema">
        <property name="movieService">
            <bean class="DefaultMovieService"/>
        </property>
    </bean>

```

这样内部bean就不需要一个名字的，当然这也意味着它无法被其他bean引用了。当然即使你给它起了名字，Spring容器也会忽略这个名字，其他bean也无法引用它。neibubean的scope始终和waibubean的scope保持一致。

## 对集合的注入

Java的集合框架中包含很多集合元素，比如List、Map、Set等。Spring支持对这些集合元素的注入。

```xml

    <bean id="accountService" class="AccountService">
        <property name="accounts">
            <map>
                <entry key="bowen" value="1234"/>
                <entry key="tom" value="3456"/>
            </map>
        </property>
    </bean>

```

```xml

    <bean id="cookbook" class="Cookbook">
        <property name="recipe">
            <list>
                <value>noodle</value>
                <value>rice</value>
                <value>meat</value>
            </list>
        </property>
    </bean>

```

还可以直接配置java的Properties。

```xml

    <bean id="databaseSource" class="DatabaseSource">
        <property name="source">
            <props>
                <prop key="port">2012</prop>
                <prop key="host">localhost</prop>
                <prop key="schema">db1</prop>
            </props>
        </property>
    </bean>

```

## 嵌套属性名注入

Spring支持使用嵌套属性注入值。

```java Restaurant.java

public class Restaurant {

    private Person manager;

    public Person getManager() {
        return manager;
    }

    public void setManager(Person manager) {
        this.manager = manager;
    }
}


```

```java Person.java

public class Person {

    private String name;
    private int age;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }
}

```


```xml

    <bean id="restaurant" class="huangbowen.net.service.Restaurant">
        <property name="manager">
            <bean class="huangbowen.net.PAndCNamespace.Person"/>
        </property>
        <property name="manager.age" value="20"/>
    </bean>

```

需注意除了最后一个属性，其他属性不能为空值。


## 使用depends-on属性

当你初始化一个bean时，需要另一个bean先被初始化，这种情况很常见。虽然Spring在最大程度上能自动按照你期望的顺序来初始化bean（比如构造器注入的bean会优先初始化），但是不保证总能符合你的心意。你可以使用depends-on属性来显示指定bean的初始化顺序。

```xml 

<beans>


   <bean id="movieService" class="DefaultMovieService"/>

    <bean id="cinema" class=“Cinema” depends-on="movieService">
        <property name="serviceRef">
            <idref bean="movieService"/>
        </property>
    </bean> 

</beans>

```

也可以同时deppends-on多个对象。

```xml


    <bean id="cinema" class=“Cinema” depends-on=“movieService,accountService">
        <property name="serviceRef">
            <idref bean="movieService"/>
        </property>
    </bean>  

```

     





