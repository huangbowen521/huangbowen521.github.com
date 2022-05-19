---
layout: post
title: "ActiveMQ第六弹:设置多个并行的消费者"
date: 2014-03-23 01:52
comments: true
categories: ActiveMQ 
---

消息队列本来就是一种经典的生产者与消费者模式。生产者向消息队列中发送消息，消费者从消息队列中获取消息来消费。

<!-- more -->


{% img /images/singleQ.png %}

消息的传送一般由一个代理来实现的，那就是Message broker（即消息代理）。Message broker有两大职责，一是消息路由，二是数据转换。这就好比A给B寄信，如果不使用邮局的话，就要自己想办法送达，费时费力，而通过邮局的话，只要B的地址在邮局中注册过，那么天涯海角也能送达。这里的邮局扮演的角色就像消息系统中的Message broker。

{% img /images/queueAndMB.png %}

众所周知，消息队列是典型的’send and forget’原则的体现，生产者只管发送，不管消息的后续处理。为了最大效率的完成对消息队列中的消息的消费，一般可以同时起多个一模一样的消费者，以并行的方式来拉取消息队列中的消息。这样的好处有多个：

1. 加快处理消息队列中的消息。

2. 增强稳定性，如果一个消费者出现问题，不会影响对消息队列中消息的处理。

{% img /images/multipleCunsumer.png %}

使用Spring JMS来配置多个Listener实例其实也相当简单，只需要配置下MessageListenerContainer就行。

```xml

<bean class="org.springframework.jms.listener.SimpleMessageListenerContainer">
    <property name="connectionFactory" ref="connectionFactory"/>
    <property name="destinationName" value="${jms.queue.name}"/>
    <property name="messageListener" ref="messageReceiver"/>
    <property name="concurrentConsumers" value="4"/>
</bean>

```

多配置一个属性`concurrentConsumers`，设置值为4，就是同时启动4个Listener实例来消费消息。

使用MessageSender来发送100条消息，可以检查消息处理的顺序会发生变化。

```java

    for (int i = 0; i < 100; i++) {
        messageSender.send(String.format("message %d",i));
    }

```

```text

...
Received: message 4
Received: message 7
Received: message 6
Received: message 5
Received: message 8
Received: message 10
Received: message 9
…

```

除了设置一个固定的Listener数量，也可以设置一个Listener区间，这样MessageListenerContainer可以根据消息队列中的消息规模自动调整并行数量。

```xml

    <bean class="org.springframework.jms.listener.SimpleMessageListenerContainer">
        <property name="connectionFactory" ref="connectionFactory"/>
        <property name="destinationName" value="${jms.queue.name}"/>
        <property name="messageListener" ref="messageReceiver"/>
        <property name="concurrency" value="4-8"/>
    </bean>

```

这次使用的是`concurrency`属性，4-8表示最小并发数是4，最大并发数为8，当然也可以给一个固定值，比如5，这样就相当于concurrentConsumers属性了。

本章中的完整源码可从完整代码可从[https://github.com/huangbowen521/SpringJMSSample](https://github.com/huangbowen521/SpringJMSSample)下载。

