---
layout: post
title: ActiveMQ第二弹:使用Spring JMS与ActiveMQ通讯
date: 2014-02-20 23:18
comments: true
categories: ActiveMQ
---

本文章的完整代码可从我的github中下载：[https://github.com/huangbowen521/SpringJMSSample.git](https://github.com/huangbowen521/SpringJMSSample.git)

上一篇文章中介绍了如何安装和运行ActiveMQ。这一章主要讲述如何使用Spring JMS向ActiveMQ的Message Queue中发消息和读消息。

<!-- more -->

首先需要在项目中引入依赖库。

* spring-core: 用于启动Spring容器，加载bean。

* spring-jms:使用Spring JMS提供的API。

* activemq-all:使用ActiveMQ提供的API。

在本示例中我使用maven来导入相应的依赖库。

```xml pom.xml

  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.11</version>
      <scope>test</scope>
    </dependency>
      <dependency>
          <groupId>org.apache.activemq</groupId>
          <artifactId>activemq-all</artifactId>
          <version>5.9.0</version>
      </dependency>
      <dependency>
          <groupId>org.springframework</groupId>
          <artifactId>spring-jms</artifactId>
          <version>4.0.2.RELEASE</version>
      </dependency>
      <dependency>
          <groupId>org.springframework</groupId>
          <artifactId>spring-core</artifactId>
          <version>4.0.2.RELEASE</version>
      </dependency>
  </dependencies> 

```

接下来配置与ActiveMQ的连接，以及一个自定义的MessageSender。

```xml springJMSConfiguration.xml

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
 http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer">
        <property name="location">
            <value>application.properties</value>
        </property>
    </bean>

    <!-- Activemq connection factory -->
    <bean id="amqConnectionFactory" class="org.apache.activemq.ActiveMQConnectionFactory">
        <constructor-arg index="0" value="${jms.broker.url}"/>
    </bean>

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
</beans> 

```

在此配置文件中，我们配置了一个ActiveMQ的connection factory,使用的是ActiveMQ提供的ActiveMQConnectionFactory类。然后又配置了一个Spring JMS提供的CachingConnectionFactory。我们定义了一个ActiveMQQueue作为消息的接收Queue。并创建了一个JmsTemplate，使用了之前创建的ConnectionFactory和Message Queue作为参数。最后自定义了一个MessageSender，使用该JmsTemplate进行消息发送。

以下MessageSender的实现。

```java MessageSender.java

package huangbowen.net.jms;

import org.springframework.jms.core.JmsTemplate;

public class MessageSender {

    private final JmsTemplate jmsTemplate;

    public MessageSender(final JmsTemplate jmsTemplate) {
        this.jmsTemplate = jmsTemplate;
    }

    public void send(final String text) {
        jmsTemplate.convertAndSend(text);
    }
} 

```
这个MessageSender很简单，就是通过jmsTemplate发送一个字符串信息。

我们还需要配置一个Listener来监听和处理当前的Message Queue。

```xml springJMSReceiver.xml 

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
 http://www.springframework.org/schema/beans/spring-beans.xsd">

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

在上述xml文件中,我们自定义了一个MessageListener，并且使用Spring提供的SimpleMessageListenerContainer作为Container。

以下是MessageLinser的具体实现。

```java MessageReceiver.java

package huangbowen.net.jms;

import javax.jms.*;

public class MessageReceiver implements MessageListener {

    public void onMessage(Message message) {
        if(message instanceof TextMessage) {
            TextMessage textMessage = (TextMessage) message;
            try {
                String text = textMessage.getText();
                System.out.println(String.format("Received: %s",text));
            } catch (JMSException e) {
                e.printStackTrace();
            }
        }
    }
} 

```

这个MessageListener也相当的简单，就是从Queue中读取出消息以后输出到当前控制台中。

另外有关ActiveMQ的url和所使用的Message Queue的配置在application.properties文件中。

```xml application.properties

jms.broker.url=tcp://localhost:61616
jms.queue.name=bar 

```

好了，配置大功告成。如何演示那？我创建了两个Main方法，一个用于发送消息到ActiveMQ的MessageQueue中，一个用于从MessageQueue中读取消息。

```java SenderApp

package huangbowen.net;

import huangbowen.net.jms.MessageSender;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.util.StringUtils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class SenderApp
{
    public static void main( String[] args ) throws IOException {
        MessageSender sender = getMessageSender();
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String text = br.readLine();

        while (!StringUtils.isEmpty(text)) {
            System.out.println(String.format("send message: %s", text));
            sender.send(text);
            text = br.readLine();
        }
    }

    public static MessageSender getMessageSender() {
        ApplicationContext context = new ClassPathXmlApplicationContext("springJMSConfiguration.xml");
       return (MessageSender) context.getBean("messageSender");
    }
} 

```

```java ReceiverApp.java

package huangbowen.net;

import org.springframework.context.support.ClassPathXmlApplicationContext;

public class ReceiverApp {
    public static void main( String[] args )
    {
        new ClassPathXmlApplicationContext("springJMSConfiguration.xml", "springJMSReceiver.xml");
    }
} 

```

OK，如果运行的话要先将ActiveMQ服务启动起来（更多启动方式参见我上篇文章）。

```bash

$:/usr/local/Cellar/activemq/5.8.0/libexec$ activemq start xbean:./conf/activemq-demo.xml 

```

然后运行SenderApp中的Main方法，就可以在控制台中输入消息发送到ActiveMQ的Message Queue中了。运行ReceiverApp中的Main方法，则会从Queue中将消息读出来，打印到控制台。

这就是使用Spring JMS与ActiveMQ交互的一个简单例子了。完整代码可从https://github.com/huangbowen521/SpringJMSSample下载。 


