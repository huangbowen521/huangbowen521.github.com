---
layout: post
title: Spring-Context之七:使用p-namesapce和c-namespace简化bean的定义
date: 2014-03-26 00:50
comments: true
categories: Spring-context 
---

在Spring中定义bean的方式多种多样，即使使用xml的方式来配置也能派生出很多不同的方式。

<!-- more -->


比如如下的bean定义:

```xml

<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd">


    <bean id="person" class="Person">
        <property name="name" value="Tom"/>
        <property name="age" value="20"/>
    </bean>

</beans>

```

这样的bean有三行，通过使用p-namespace以后可以简化为一行。

```xml

<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:p="http://www.springframework.org/schema/p"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="person" class="Person" p:name="Tom" p:age="20"/>

</beans>

```

那么什么是`p-namespace`那？它的作用就是使用xml中的元素属性取代`<property/>`节点来定义bean的属性。这个神奇的p是什么东西那？它其实是使用了namespace的xml扩展配置格式。beans的配置格式是定义在一个xsd格式中的（即 http://www.springframework.org/schema/beans/spring-beans.xsd），但p却没有一个xsd格式文件与其对应，但是它可以被spring内核解析处理。

上面只是演示了对属性为普通值的时使用`p-namespace`的注入，如果属性为另一个bean的引用时该如何处理那？很简单。

这是使用正常方式注入属性。

```xml

    <bean id="messageService" class="SimpleMessageService"/>
    <bean id="messageHandler" class="MessageHandler">
        <property name="messageService">
            <ref bean="messageService" />
        </property>
    </bean>

```

使用`p-namespace`后是这样的。

```xml

    <bean id="messageService" class="SimpleMessageService"/>
    <bean id="messageHandler" class=“MessageHandler” p:messageService-ref=“messageService”/>

```

加上`-ref`后缀即表示是对一个bean的引用。

那既然setter方法注入bean可以使用`p-namespace`，那么构造器方式注入有没有相应的简写那？答案是肯定的，那就是`c-namespace`，原理和使用方法与`p-namespace`大同小异。

使用`c-namespace`前:

```xml

<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:c="http://www.springframework.org/schema/c"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd">


    <bean id="person" class="Person">
        <constructor-arg name="name">
            <value>Tom</value>
        </constructor-arg>
        <constructor-arg name="age" value="20"/>
    </bean>

</beans>

```

使用`c-namespace`后:


```xml

<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:c="http://www.springframework.org/schema/c"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd">

<bean id="person"  c:name="Tom" c:age="20"/>
</beans>

```

也可以使用`-ref`后缀来表示对另一个bean的引用。

```xml

 <bean id="messageService" class="SimpleMessageService"/>
    <bean id="messageHandler" class="MessageHandler" c:messageService-ref="messageService"/>

```

在前面章节讲解构造器注入时，可以使用构造参数索引来注入依赖，`c-namespace`也支持这一方式。


```xml

<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:c="http://www.springframework.org/schema/c"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd">

<bean id="person”  c:_0="Tom" c:_1="20"/>

<bean id="messageService" class="SimpleMessageService"/>
<bean id="messageHandler" class="MessageHandler" c:_0-ref="messageService"/>

</beans>

``` 

怎么样，是不是很强大啊。但是太过强大也容易伤人伤己。在项目中使用这些技巧之前最好先和项目成员达成一致。


本例中的源码请在[我的GitHub](https://github.com/huangbowen521/Study)上自行下载。










