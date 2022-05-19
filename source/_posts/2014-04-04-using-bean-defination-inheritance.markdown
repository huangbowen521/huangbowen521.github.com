---
layout: post
title: Spring-Context之九:在bean定义中使用继承
date: 2014-04-04 00:45
comments: true
categories: Spring-Context
---


定义bean时有个abstract属性，可以设置为true或false，默认为false。

<!-- more -->

```xml

<bean id="animal" class="Animal" abstract="true">
        <property name="name" value="elephant"/>
        <property name="legs" value="4”/>
</bean>

```

这里定义了一个叫elepahnt的animal bean，有4条腿，它与其他bean不同之处是abstract属性为true。这意味着什么？意味着这个bean不能被实例化，不能通过ApplicationContext.getBean()的方式来获取到该bean，也不能使用ref属性引用这个bean。否则会抛出BeanIsAbstractException的异常。

你可能会问？坑爹那？声明一个bean不能被实例化，那有何用？

当然有用，Spring框架开发者也不是一帮吃饱了没事干的人，设计一些没用的功能出来。

这要配合着parent属性来用。

```xml

<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="animal" class="Animal" abstract="true">
        <property name="legs" value="4"/>
    </bean>

    <bean id="monkey" parent="animal">
        <property name="name" value="dudu"/>
    </bean>

</beans>

```

这里有两个bean，一个是animal,指定legs是4，另一个是monkey，通过parent的属性指向animal，指定name为dudu。聪明的读者可能已经猜出来了，parent属性就是子bean可以继承父bean中的属性，并且在子bean中可以重载对应的属性。虽然我们没显式的指定monkey的legs为4，其实它已经从父bean animal中继承了这个属性。这样的好处是如果在定义大量bean时，发先大量bean存在重复属性定义时，可以抽取一个抽象bean出来，实现这些重复的属性定义，让其他bean都使用parent属性指向这个抽象bean。这样可以大大简化bean的配置。

除了使用parent直接引用父bean的class外，另外也可以使用自定义的class。

```java Monkey.java

public class Monkey extends Animal {

    private boolean canDrawing;

    public boolean isCanDrawing() {
        return canDrawing;
    }

    public void setCanDrawing(boolean canDrawing) {
        this.canDrawing = canDrawing;
    }
}

```

```xml

<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="animal" class="Animal" abstract="true">
        <property name="legs" value="4"/>
    </bean>

    <bean id="smartMonkey" class="Monkey" parent="animal">
        <property name="name" value="smallDudu"/>
        <property name="canDrawing" value="true"/>
    </bean>

</beans>

```

这样smartMonkey自动继承了父bean中的legs属性，同时它的class类型也是一个新类型。

有人可能要问了，子bean的class与父bean中的class一定要是继承关系吗？答案是否定的。
请看这个修改后的Monkey class，其本身并未从Animal继承。

```java


public class Monkey {

    private boolean canDrawing;
    private String name;
    private int legs;

    public boolean isCanDrawing() {
        return canDrawing;
    }

    public void setCanDrawing(boolean canDrawing) {
        this.canDrawing = canDrawing;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getLegs() {
        return legs;
    }

    public void setLegs(int legs) {
        this.legs = legs;
    }
}

```
然后还配置同样的bean。

```xml

<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="animal" class="Animal" abstract="true">
        <property name="legs" value="4"/>
    </bean>

    <bean id="smartMonkey" class="Monkey" parent="animal">
        <property name="name" value="smallDudu"/>
        <property name="canDrawing" value="true"/>
    </bean>

</beans> 

```

依然能够正常工作，并且smartMonkey中的legs还是4。

这说明了Spring中使用parent继承父bean中的属性并不需要子bean和父bean的class在一个继承树上。父bean更像一个模板，子bean能够自动使用父bean中的配置而已。唯一需要注意的是在父bean中定义的属性在子bean中都要存在。

那可能有人就有个大胆的猜想了，可不可以定义一个没有class类型的父bean那？这个bean反正不能实例化，只用来让子bean继承属性。答案是肯定的。

```xml

<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="animal" abstract="true">
        <property name="legs" value="4"/>
    </bean>

    <bean id="monkey" parent="animal" class="Animal">
        <property name="name" value="dudu"/>
    </bean>

    <bean id="smartMonkey" class="Monkey" parent="animal">
        <property name="name" value="smallDudu"/>
        <property name="canDrawing" value="true"/>
    </bean>

</beans>

```

上面的定义依然可以工作。

多说一点，parent也支持对集合属性的继承。比如在父bean中定义了一个属性为List或Map，子bean中也能继承到该List或Map，更强大的是子bean还可以对List或Map进行合并。

```xml

<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="sampleAccounts" abstract="true">
        <property name="accounts">
            <map>
                <entry key="Bob" value="001"/>
                <entry key="John" value="002"/>
            </map>
        </property>
    </bean>

    <bean id="accountService" parent="sampleAccounts" class="AccountService">
        <property name="accounts">
            <map merge="true">
                <entry key="Michael" value="003"/>
                <entry key="Joel" value="004"/>
            </map>
        </property>
    </bean>

</beans>

```

在子bean中使用的map元素上使用merge=“true”就可以和父bean中的map条目进行合并。如果指定为false则不会合并，只会使用子bean中定义的map条目。

本例中的源码请在[我的GitHub](https://github.com/huangbowen521/Study)上自行下载。

