---
layout: post
title: Spring-Context之一:一个简单的例子
date: 2014-03-11 02:27
comments: true
categories: Spring-Context
---

很久之前就想系统的学习和掌握Spring框架，但是拖了很久都没有行动。现在趁着在外出差杂事不多，就花时间来由浅入深的研究下Spring框架。Spring框架这几年来已经发展成为一个巨无霸产品。从最初的只是用来作为依赖注入到现在已经是无法不包。其涉及的领域有依赖注入、MVC、JMS、Web flow、Batch job、Web service、Security…..几乎是涵盖了技术开发的所有方面。本人虽然从事Java语言开发时间不长，但是对Spring中的很多组件都有所涉猎，比如上面列出的那几个都有用过。可以说Spring是Java程序员必须要掌握的一个库。

<!-- more -->

现在Spring的最新的稳定版本是4.0.2,该版本中包含了大量的新特性，是比较重要的一次release。本系列将基本使用该版本进行讲解。

第一讲就用一个简单的例子开始吧，初步学会使用Spring-Context的依赖注入功能。

首先使用maven创建一个新的项目。

```bash

$: mvn archetype:generate

```

创建成功后在pom.xml文件中加入对Spring-Context的依赖。

```xml pom.xml

<dependencies>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-context</artifactId>
        <version>4.0.2.RELEASE</version>
    </dependency>
</dependencies>

```

然后我们创建一个MovieService的接口。

```java MovieService.java

package huangbowen.net.service;

public interface MovieService {

    String getMovieName();
}

```

创建一个DefaultMovieService来实现这个接口。

```java DefaultMovieService.java

package huangbowen.net.service;

public class DefaultMovieService implements MovieService {

    public String getMovieName() {
        return "A Touch of Sin";
    }
}

``` 

然后创建一个Cinema类，会使用MoviceService来放电影。

```java Cinema.java

package huangbowen.net.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class Cinema {

    @Autowired
    private MovieService movieService;

    public void printMovieName() {
        System.out.println(movieService.getMovieName());
    }
}

```

建立一个Application类。

```java Application.java

package huangbowen.net;

import huangbowen.net.service.Cinema;
import huangbowen.net.service.DefaultMovieService;
import huangbowen.net.service.MovieService;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@ComponentScan
public class Application
{

    @Bean
    public MovieService getMovieService() {
        return new DefaultMovieService();
    }

    public static void main( String[] args )
    {
        AnnotationConfigApplicationContext applicationContext = new AnnotationConfigApplicationContext(Application.class);
        Cinema cinema = applicationContext.getBean(Cinema.class);
        cinema.printMovieName();

    }
}

```

Ok,运行main函数，得到控制台输出：

```text

A Touch of Sin

```

本例子中主要使用Annotation功能来实现对MoviceService的注入。我们将Cinema.java的头部标注为@Component说明该类交由Spring托管。而Cinema.java中的属性MoviceService标注为@Autowired，则Spring在初始化Cinema类时会从Application Context中找到类型为MovieService的Bean，并赋值给Cinema。在Application.java中我们声明了一个类型为MovieService的Bean。并且标注Application.java为@Configuration,这是告诉Spring在Application.java中定义了一个或多个@Bean方法，让Spring容器可以在运行时生成这些Bean。@ComponentScan则会让Spring容器自动扫描当前package下的标有@Component的class，这些class都将由Spring托管。


本例中的源码请在[我的GitHub](https://github.com/huangbowen521/Study)上自行下载。


