---
layout: post
title: Spring-Context之二:使用Spring提供的测试框架进行测试
date: 2014-03-12 01:01
comments: true
categories: Spring-Context
---

Spring框架是无侵入性的，所以你的代码可以完全是POJO（plain old java object），直接使用Junit就可以完成大部分的单元测试。但是在集成测试方面就比较吃力了。单元测试层面你可以mock一些依赖对象，但是集成测试时需要真实的依赖对象，而这些对象都是在Spring容器的控制之下。那么如何在引入了Spring的情况下进行集成测试那？别着急，Spring框架早为我们想到了这点，本身提供了集成测试的功能。

<!-- more -->

就拿上一次那个简单的例子来做实验吧。

首先引入对junit以及spring-test库的依赖。

```xml pom.xml

   <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.11</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-test</artifactId>
            <version>4.0.2.RELEASE</version>
        </dependency>
    </dependencies>

```

spring-test模块是专门为使用了spring框架的项目进行集成测试的辅助类库。其有以下几个目的。

* 提供在运行测试时对Spring IOC容器的缓存，提高集成测试速度。

* 对测试实例提供依赖注入功能。

* 集成测试中提供事务管理。

* 提供一些辅助类库帮助开发者更好的编写集成测试。

然后新建一个ApplicationTest.java类，代码如下所示。

```java ApplicationTest.java

package huangbowen.net;


import huangbowen.net.service.Cinema;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import static org.junit.Assert.assertNotNull;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {Application.class})
public class ApplicationTest {

    @Autowired
    private ApplicationContext applicationContext;

    @Autowired
    private Cinema cinema;

    @Test
    public void shouldGetCinemaInstance()  {
        Cinema cinema = applicationContext.getBean(Cinema.class);
        assertNotNull(cinema);
    }

    @Test
    public void shouldGetAutowiredCinema() {
        assertNotNull(cinema);
    }

    @Test
    public void shouldGetMovieServiceInstance() {
        assertNotNull(cinema.getMovieService());
        assertThat(cinema.getMovieService(), instanceOf(DefaultMovieService.class));
    }
}

```

在本例中ApplicationTest有两个注解。@RunWith(SpringJUnit4ClassRunner.class).是Spring TestContext 框架提供的一个自定义的JUnit runner，这样在测试类中就可以获取ApplicationContext，甚至直接进行依赖注入，使用事务控制测试方法执行等。声明了@RunWith(SpringJUnit4ClassRunner.class)以后一般还要声明@ContextConfiguration注解。这个注解是用于告诉测试类本项目中的Spring配置。这里我们传入Application.class类，因为这个类中配置了Spring的bean。

然后就可以在测试类中使用强大的@Autowired功能了。我们写了三个测试方法，第一个是通过Autowired功能拿到ApplicationContext，第二个是通过Autowired功能直接拿到cinema，第三个则是验证Cinema中的MovieService是被正确注入了的。

Ok,今天就到这里。本例中的源码请在[我的GitHub](https://github.com/huangbowen521/Study)上自行下载。
