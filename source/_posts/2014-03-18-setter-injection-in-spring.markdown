---
layout: post
title: Spring-Context之六:基于Setter方法进行依赖注入
date: 2014-03-18 00:33
comments: true
categories: Spring-Context
---

上文讲了基于构造器进行依赖注入，这里讲解基于Setter方法进行注入。在Java世界中有个约定（Convention）,那就是属性的设置和获取的方法名一般是:set+属性名(参数)及get+属性名()的方式。boolean类型稍有不同，可以使用is+属性名()方式来获取。

<!-- more -->

以下是一个示例。

```java MessageHandler.java

public class MessageHandler {

    private MessageService messageService;

    public MessageService getMessageService() {
        return messageService;
    }

    public void setMessageService(MessageService messageService) {
        this.messageService = messageService;
    }

    public String handle() {
        return messageService.sendService();
    }
}

```

使用Setter方法注入如下所示。

```xml

<bean id="messageService" class="huangbowen.net.DependecyInjection.ConstructorInjection.SimpleMessageService"/>
    <bean id="messageHandler" class="huangbowen.net.DependecyInjection.SetterInjection.MessageHandler">
        <property name="messageService" ref="messageService"/>
    </bean>

```

如果property的name为messageService,那么必须在类中有个叫做`setMessageService`的方法，这样才能完成注入。如果将MessageHandler.java中的`setMessageService`方法改为`setMessageService1`，那么注入就会失败，失败message如下所示。

```text


...
java.lang.IllegalStateException: Failed to load ApplicationContext

...
Caused by: org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'messageHandler' defined in class path resource [spring-context.xml]: Error setting property values; nested exception is org.springframework.beans.NotWritablePropertyException: Invalid property 'messageService' of bean class [huangbowen.net.DependecyInjection.SetterInjection.MessageHandler]: Bean property 'messageService' is not writable or has an invalid setter method. Did you mean 'messageService1'?

...

```

当然可以同时使用构造器注入和setter方法注入。

```java  Person.java

public class Person {

    private String name;

    public Person(String name) {
        this.name = name;
    }

    private int age;

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getName() {
        return name;
    }
}

```

bean定义如下：

```xml

    <bean id="person" class="huangbowen.net.DependecyInjection.SetterInjection.Person">
        <constructor-arg value="Tom"/>
        <property name="age" value="20"/>
    </bean>

```

要实现一个bean，即可以使用构造器注入，也可以使用setter注入，甚至可以在一个bean中综合使用这两种方式。那么在真正开发中应该作何取舍那？一般来说，使用构造器注入的依赖必须是强制的依赖，而使用setter注入的依赖则是可选的依赖。使用构造器注入生成的对象是完全初始化了的，用户可以直接拿来用，但是相比于setter方法而言用户也就失去了定制化的能力。如果你发现构造器参数过多，那么很可能说明该类承担的职责过多，应该从设计解耦的角度对类的职责进行拆分。使用setter注入的对象好处是，用户可以按需重新注入新的属性。

另外在进行依赖注入时，可以将某些属性抽出来成为一个元素，或者将元素内联成为一个属性。比如ref这个属性。

```xml

    <bean id="messageHandler" class="huangbowen.net.DependecyInjection.SetterInjection.MessageHandler">
        <property name="messageService" ref="messageService" />
    </bean>

```

它与以下xml配置完全等价。

```xml

 <bean id="messageHandler" class="huangbowen.net.DependecyInjection.SetterInjection.MessageHandler">
        <property name="messageService">
            <ref bean="messageService"/>
        </property>
    </bean>

```

value属性也可以独立为元素。

```xml


    <bean id="person" class="huangbowen.net.DependecyInjection.SetterInjection.Person">
        <constructor-arg value="Tom"/>
        <property name="age" value="20"/>
    </bean> 

```

其等价于:

```xml

    <bean id="person" class="huangbowen.net.DependecyInjection.SetterInjection.Person">
        <constructor-arg value="Tom"/>
        <property name="age">
            <value>20</value>
        </property>
    </bean>

```

也可以显式指定value的类型。

```xml

    <bean id="person" class="huangbowen.net.DependecyInjection.SetterInjection.Person">
        <constructor-arg value="Tom"/>
        <property name="age">
            <value type="int">20</value>
        </property>
    </bean>

```

比如有一个属性是个boolean值，如果想将其注入为true的话，不指定具体类型的话，Spring可能会将其作为字符串true对待。当然Spring会尝试将传入的字符串转换为setter方法希望的类型，但这种自动转换有时候并不是你期望的，这种情况下你就需要显式指定其类型。

本例中的源码请在[我的GitHub](https://github.com/huangbowen521/Study)上自行下载。




