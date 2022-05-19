---
layout: post
title: ActiveMQ第三弹:在Spring中使用内置的Message Broker
date: 2014-02-22 19:16
comments: true
categories: ActiveMQ 
---

在上个例子中我们演示了如何使用Spring JMS来向ActiveMQ发送消息和接收消息。但是这个例子需要先从控制台使用ActiveMQ提供的命令行功能启动一个Message Broker,然后才能运行示例。这个Message Broker就相当于一个server，无论是发送方还是接收方都可以连接到这个Server进行消息的处理。在某些情况下，让Message Broker和consumer启动在同一个JVM里面，通信效率肯定会高不少。

<!-- more -->

ActiveMQ提供了很多方式来创建内置的broker。这篇文章主要介绍使用Spring及XBean来创建一个内置的broker。

首先需要在项目中引入xbean-spring依赖项。

```xml pom.xml

      <dependency>
          <groupId>org.apache.xbean</groupId>
          <artifactId>xbean-spring</artifactId>
          <version>3.16</version>
      </dependency> 

```

然后在Spring配置文件中加入以下代码:

```xml 

    <amq:broker id="activeMQBroker">
        <amq:transportConnectors>
            <amq:transportConnector uri="${jms.broker.url}" />
        </amq:transportConnectors>
    </amq:broker> 

```

注意在Spring配置文件中还要加入Namespace的定义。

```xml

<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:amq="http://activemq.apache.org/schema/core"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
       http://activemq.apache.org/schema/core http://activemq.apache.org/schema/core/activemq-core-5.8.0.xsd"> 

...
...
...

</beans>

```

完整的Spring配置如下。

```xml embedBroker.xml

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:amq="http://activemq.apache.org/schema/core"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
       http://activemq.apache.org/schema/core http://activemq.apache.org/schema/core/activemq-core-5.8.0.xsd">

    <bean class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer">
        <property name="location">
            <value>application.properties</value>
        </property>
    </bean>

    <!-- Activemq connection factory -->
    <bean id="amqConnectionFactory" class="org.apache.activemq.ActiveMQConnectionFactory">
        <!--<property name="brokerURL" value="${jms.broker.url}"/>-->
        <constructor-arg index="0" value="${jms.broker.url}"/>
        <property name="useAsyncSend" value="true"/>
    </bean>

    <amq:broker id="activeMQBroker">
        <amq:transportConnectors>
            <amq:transportConnector uri="${jms.broker.url}" />
        </amq:transportConnectors>
    </amq:broker>

    <!-- ConnectionFactory Definition -->
    <bean id="connectionFactory" class="org.springframework.jms.connection.CachingConnectionFactory">
        <constructor-arg ref="amqConnectionFactory"/>
    </bean>

    <!--  Default Destination Queue Definition-->
    <bean id="defaultDestination" class="org.apache.activemq.command.ActiveMQQueue">
        <constructor-arg index="0" value="${jms.queue.name}"/>
    </bean>

    <!-- JmsTemplate Definition -->
    <bean id="jmsTemplate" class="org.springframework.jms.core.JmsTemplate">
        <property name="connectionFactory" ref="connectionFactory"/>
        <property name="defaultDestination" ref="defaultDestination"/>
    </bean>

    <!-- Message Sender Definition -->
    <bean id="messageSender" class="huangbowen.net.jms.MessageSender">
        <constructor-arg index="0" ref="jmsTemplate"/>
    </bean>

    <!-- Message Receiver Definition -->
    <bean id="messageReceiver" class="huangbowen.net.jms.MessageReceiver">
    </bean>
    <bean class="org.springframework.jms.listener.SimpleMessageListenerContainer">
        <property name="connectionFactory" ref="connectionFactory"/>
        <property name="destinationName" value="${jms.queue.name}"/>
        <property name="messageListener" ref="messageReceiver"/>
    </bean>

</beans> 

```

在[示例项目](https://github.com/huangbowen521/SpringJMSSample)中我新加了一个Main方法来进行测试。可以运行EmbedBrokerApp中的Main方法来进行测试。

{% img /images/messageTest.png %}


如果客户端和broker在相同的JVM进程中，客户端连接时可以使用broker url为“vm://localhost:61616”,进程外连接则需要使用”tcp://localhost:61616"。如果有多个broker的话可以给每个broker起个名字。

```xml

    <amq:broker brokerName="broker1">
        <amq:transportConnectors>
            <amq:transportConnector uri="tcp://localhost:61616" />
        </amq:transportConnectors>
    </amq:broker>

    <amq:broker brokerName="broker2">
        <amq:transportConnectors>
            <amq:transportConnector uri="tcp://localhost:61617" />
        </amq:transportConnectors>
    </amq:broker> 

```

客户端连接时候可以直接使用broker名称连接，比如使用”vm://broker1”来使用第一个broker。

本章中的完整源码可从完整代码可从[https://github.com/huangbowen521/SpringJMSSample](https://github.com/huangbowen521/SpringJMSSample)下载。

