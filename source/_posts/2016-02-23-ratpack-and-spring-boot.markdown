---
layout: post
title: 翻译-使用Ratpack和Spring Boot打造高性能的JVM微服务应用
date: 2016-02-23 16:47:48 +0800
comments: true
categories: Ratpack
tags: [Ratpack, Spring Boot] 
---

这是我为InfoQ翻译的文章，原文地址:[Build High Performance JVM Microservices with Ratpack & Spring Boot](http://www.infoq.com/articles/Ratpack-and-Spring-Boot),InfoQ上的中文地址:[使用Ratpack与Spring Boot构建高性能JVM微服务](http://www.infoq.com/cn/articles/Ratpack-and-Spring-Boot)。

在微服务天堂中Ratpack和Spring Boot是天造地设的一对。它们都是以开发者为中心的运行于JVM之上的web框架，侧重于生产率、效率以及轻量级部署。他们在服务程序的开发中带来了各自的好处。Ratpack通过一个高吞吐量、非阻塞式的web层提供了一个反应式编程模型，而且对应用程序结构的定义和HTTP请求过程提供了一个便利的处理程序链；Spring Boot集成了整个Spring生态系统，为应用程序提供了一种简单的方式来配置和启用组件。Ratpack和Spring Boot是构建原生支持计算云的基于数据驱动的微服务的不二选择。

<!-- more -->

Ratpack并不关心应用程序底层使用了什么样的依赖注入框架。相反，应用程序可以通过Ratpack提供的DI抽象（被称为Registry）访问服务层组件。Ratpack的Registry是构成其基础设施的一部分，其提供了一个接口，DI提供者可以使用注册器回调（registry backing）机制来参与到组件解决方案序列中。

Ratpack直接为Guice和Spring Boot提供了注册器回调机制，开发人员可以为应用程序灵活选择使用的依赖注入框架。

在本文中我们将演示使用Ratpack和Spring Boot构建一个RESTful风格的基于数据驱动的微服务，背后使用了Spring Data用于操作数据。

开始构建Ratpack项目的最佳方式是创建Gradle脚本以及标准的Java项目结构。Gradle是Ratpack原生支持的构建系统，其实由于Ratpack只是一组简单的JVM库，所以其实它适用于任何构建系统（不管你的需求有多特别）。如果你还未安装Gradle，那么安装它最佳方式是通过[Groovy enVironment Manager工具](http://gvmtool.net/)。示例项目的构建脚本如列表1所示。

列表1

```groovy

buildscript {
  repositories {
    jcenter()
  }
  dependencies {
    classpath 'io.ratpack:ratpack-gradle:0.9.18'
  }
}

apply plugin: 'io.ratpack.ratpack-java'
apply plugin: 'idea'
apply plugin: 'eclipse'

repositories {
  jcenter()
}

dependencies {
  compile ratpack.dependency('spring-boot') (1)
}

mainClassName = "springpack.Main" (2)

eclipse {
  classpath {
    containers.remove('org.eclipse.jdt.launching.JRE_CONTAINER')
    containers 'org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-1.8'
  }
}

```

在(1)部分中，构建脚本通过调用Ratpack Gradle插件的ratpack.dependency(..)方法引入了Ratpack和Spring Boot的集成。根据构建脚本和当前项目结构，我们可以创建一个“主类”(main class)，其作为可运行的类来启动和运行应用程序。注意（2）中我们指定了主类的名称，所以使用命令行工具时会更简练。这意味着实际的主类名必须与之一致，所以需要在本项目的src/main/java目录中创建一个名为springpack.Main的类。

在主类中，我们通过工厂方法构造了RatpackServer的一个实例，在start方法中提供了对应用程序的定义。该定义中我们编写了RESTful API处理器链。请参见列表2中对Main类的演示。注意Ratpack要求的编译环境为Java 8。

列表2

```java

package springpack;

import ratpack.server.RatpackServer;

public class Main {

  public static void main(String[] args) throws Exception {
    RatpackServer.start(spec -> spec
      .handlers(chain -> chain (1)
          .prefix("api", pchain -> pchain (2)
            .all(ctx -> ctx (3)
              .byMethod(method -> method (4)
                .get(() -> ctx.render("Received GET request"))
                .post(() -> ctx.render("Received POST request"))
                .put(() -> ctx.render("Received PUT request"))
                .delete(() -> ctx.render("Received DELETE request"))
              )
            )
          )
      )
    );
  }

}

```

如果我们仔细剖析主类中的应用程序定义，我们可以识别出一些关键知识点，对于不熟悉Ratpack的人来说，我们需要对这些知识点做进一步解释。第一个值得注意的点在（1）中处理器区域定义了一个处理器链，该处理器链用于处理Ratpack流中的HTTP请求。通过链式定义的处理器描述了它们能够处理的请求类型。特别在（2）中我们定义了一个前缀处理器类型，指定它被绑定到“api”这个HTTP路由。前缀处理器创建了一个新的处理器链，用来处理匹配”/api” 端口(endpoint)到来的请求。在（3）处我们使用了所有的处理器类型来指定所有到来的请求应该运行在我们提供的处理器中，在（4）处我们使用Ratpack的byMethod机制来将get，post，put和delete处理器绑定到到各自的HTTP方法中。

在项目根目录下，我们可以通过命令行简单使用gradle的“run”命令运行该应用程序。这会启动web服务器并绑定到端口5050。为了演示当前项目的功能，确保处理器结构工作正常，我们可以在命令行中通过curl运行一些测试：

* 命令：curl http://localhost:5050, 期待输出：Received GET request
* 命令：curl -XPOST http://localhost:5050, 期待输出：Received POST request
* 命令：curl -XPUT http://localhost:5050, 期待输出：Received PUT request
* 命令：curl -XDELETE http://localhost:5050, 期待输出：Received DELETE request

可以看到，应用程序处理器链可以正确地路由请求，我们建立了RESTful API的结构。接下来需要改善这些API...

为了演示的缘故，让我们尽量保持简单，改造该微服务以便可以对一个User领域对象进行CRUD操作。通过REST接口，客户可以做以下事情：

* 通过一个GET请求来请求指定的用户账号，用户名作为路径变量（path variable）；
* GET请求中如果未指定用户名，则列出所有的用户；
* 通过POST一个JSON格式的用户对象来创建一个用户；
* 使用PUT请求，用户名作为路径变量来更新该用户的邮件地址；
* 使用DELETE请求，用户名作为路径变量来删除该用户。

在之前小节中我们定义的处理器已经包含了大多数处理这种需求的基础设施。但根据需求我们还需要做细微调整。例如，我们现在需要绑定处理器接收用户名作为路径变量。列表3中是更新后的代码，主类中的处理器可以满足现在的需求。

列表3

```java

package springpack;

import ratpack.server.RatpackServer;

public class Main {

  public static void main(String[] args) throws Exception {
    RatpackServer.start(spec -> spec
      .handlers(chain -> chain
        .prefix("api/users", pchain -> pchain (1)
          .prefix(":username", uchain -> uchain (2)
            .all(ctx -> { (3)
              String username = ctx.getPathTokens().get("username");
              ctx.byMethod(method -> method (4)
                .get(() -> ctx.render("Received request for user: " + username))
                                              .put(() -> {
                  String json = ctx.getRequest().getBody().getText();
                  ctx.render("Received update request for user: " + username + ", JSON: " + json);
                })
                .delete(() -> ctx.render("Received delete request for user: " + username))
              );
            })
          )
          .all(ctx -> ctx (5)
            .byMethod(method -> method
              .post(() -> { (6)
                String json = ctx.getRequest().getBody().getText();
                ctx.render("Received request to create a new user with JSON: " + json);
              })
              .get(() -> ctx.render("Received request to list all users")) (7)
            )
          )
        )
      )
    );
  }
}

```

重新构造后的API遵循了面向资源的模式，围绕着user领域对象为中心。以下是一些修改点：

* 在（1）中我们修改了入口级前缀为/api/users；
* 在（2）中我们绑定了一个新的前缀处理器到:username路径变量上。任何到来的请求路径中的值会被转换，并且Ratpack处理器可以通过ctx.getPathTokens()中的表来访问该值。
* 在（3）中我们为所有匹配/api/users/:username URI模式的请求绑定一个处理器；
*（4）中我们使用byMethod机制来为HTTP GET，PUT和DELETE方法绑定处理器。通过这些处理器我们可以了解客户端对指定用户的操作意图。在PUT处理器中，我们调用ctx.getRequest().getBody().getText()方法来捕获到来的请求中的JSON数据；
* 在（5）中我们附加一个处理器来匹配所有从/api/users端口到来的请求；
* 在（6）中我们对/api/users处理器使用byMethod机制来附加一个POST处理器，当创建新用户时该POST处理器会被调用。这里又一次从到来的请求中取出JSON数据；
* 最后在（7）中，我们附加了一个GET处理器，当客户端需要所有用户的列表时可以调用它。

再次启动该应用程序并进行一系列curl命令行调用，来测试这些端口操作是否符合预期：

* 命令：curl http://localhost:5050/api/users, 期望结果："Received request to list all users"
* 命令: curl -d '{ "username": "dan", "email": "danielpwoods@gmail.com" }'http://localhost:5050/api/users, 期望结果: "Received request to create a new user with JSON: { "username": "dan", "email": "danielpwoods@gmail.com" }"
* 命令: curl http://localhost:5050/api/users/dan, 期望结果: "Received request for user: dan"
* 命令: curl -XPUT -d '{ "email": "daniel.p.woods@gmail.com" }'http://localhost:5050/api/users/dan, 期望结果: "Received update request for user: dan, JSON: { "email": "daniel.p.woods@gmail.com" }"
* 命令: curl -XDELETE http://localhost:5050/api/users/dan, 期望结果: "Received delete request for user: dan"

现在我们拥有了满足需求的API的基础框架，但仍需使其更加有用。我们可以开始设置服务层的依赖。在本例中，我们将使用Spring Data JPA组件作为数据访问对象；列表4展示了对构建脚本的修改。

列表4

```groovy

buildscript {
  repositories {
    jcenter()
  }
  dependencies {
    classpath 'io.ratpack:ratpack-gradle:0.9.18'
  }
}

apply plugin: 'io.ratpack.ratpack-java'
apply plugin: 'idea'
apply plugin: 'eclipse'

repositories {
  jcenter()
}

dependencies {
  compile ratpack.dependency('spring-boot')
  compile 'org.springframework.boot:spring-boot-starter-data-jpa:1.2.4.RELEASE' (1)
  compile 'com.h2database:h2:1.4.187' (2)
}

mainClassName = "springpack.Main"

eclipse {
  classpath {
    containers.remove('org.eclipse.jdt.launching.JRE_CONTAINER')
    containers 'org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-1.8'
  }
}

```

在（1）中，我们引入了对Spring Boot Spring Data JPA的依赖，(2)中我们引入了H2嵌入式数据库依赖。总共就这么点修改。当在classpath中发现H2时，Spring Boot将自动配置Spring Data来使用它作为内存数据源。通过[该页面](http://projects.spring.io/spring-data-jpa/)可以详细了解如何配置和使用Spring Data数据源。

有了新的依赖后，我们必须做的第一件事是建模我们的微服务领域对象：User。User类为了演示的目的尽可能的简单，列表5展示了一个正确建模的JPA领域实体。我们将其放置到项目的src/main/java/springpack/model/User.java类文件中。

列表5

```java

package springpack.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity
public class User {
  private static final long serialVersionUID = 1l;

  @Id
  @GeneratedValue
  private Long id;

  @Column(nullable = false)
  private String username;

  @Column(nullable = false)
  private String email;

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getUsername() {
    return username;
  }

  public void setUsername(String username) {
    this.username = username;
  }

  public String getEmail() {
    return email;
  }

  public void setEmail(String email) {
    this.email = email;
  }

}
```

由于Spring Data已经处于该项目的编译时需要的classpath中，所以我们可以使用javax.persistence.*注解。Spring Boot使用该注解可以实现与数据访问对象一起设置及运行，所以我们可以使用Spring Data的脚手架功能中的Repository服务类型来模块化DAO。由于我们的API相对来说只是直接的CRUD操作，所以我们实现UserRepository DAO时，可以利用Spring Data提供的CrudRepository 固定层来编写尽可能少的代码。

列表6

```java
package springpack.model;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends CrudRepository<User, Long> {

  User findByUsername(String username); (1)
}

```

惊奇的是，列表6中展示的UesrRepository DAO实现短短一行代码已经对User领域对象实现了一个必要的完全成形的服务层。Spring Data提供的Repository接口允许基于我们对搜索的实体的约定创建”helper"查找方法。根据需求，我们知道API层需要通过用户名查找用户，所以可以在（1）处添加findByUsername方法。我们把该UserRepository放置到项目中的/src/main/java/springpack/model/UserRepository.java类文件中。

在修改API来使用UserRepository之前，我们首先必须定义Spring Boot 应用程序类。该类代表了一个配置入口，指向了Spring Boot自动配置引擎，并且可以构造一个Spring ApplicationContext，从而可以使用Ratpack应用程序中的注册器回调。列表7描述了该Spring Boot配置类。

列表7

```java

package springpack;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class SpringBootConfig {

  @Bean
  ObjectMapper objectMapper() { (1)
    return new ObjectMapper();
  }
}

```

SpringBootConfig类中短小精悍的代码放置在src/main/java/springpack/SpringBootConfig.java类文件中。在该类中我们显式地自动配置了Jackson OjbectMapper的Spring bean。我们将在API层使用它来读写JSON数据。

@SpringBootApplication注解做了大部分事情。当初始化Spring Boot注册器回调时，该类会作为入口点。它的基础设施将使用该注解来扫描classpath中任何可用的组件，并自动装配这些组件到应用程序上下文中中，并且根据Spring Boot的约定规则来自动配置它们。例如，UserRepository类（使用了@Repository注解）存在于应用程序classpath中，所以Spring Boot将使用Spring Data引擎代理该接口，并配置其与H2嵌入式数据库一块工作，因为H2也在classpath中。借助Spring Boot我们无需其它多余的配置。

在实现API层之前我们需要做的另一个事情是构造Ratpack来使用Spring Boot应用程序作为注册器。Ratpack的Spring Boot集成组件提供了一个固定层来无缝转换Spring Boot应用程序为注册器回调程序，只需一行代码就可以合并这两个世界。列表8中的代码展示了更新后的主类，这次使用SpringBootConfig类作为API层的注册器。

列表8

```java

package springpack;

import ratpack.server.RatpackServer;
import ratpack.spring.Spring;
import springpack.config.SpringBootConfig;

public class Main {

  public static void main(String[] args) throws Exception {
    RatpackServer.start(spec -> spec
      .registry(Spring.spring(SpringBootConfig.class)) (1)
      .handlers(chain -> chain
        .prefix("api/users", pchain -> pchain
          .prefix(":username", uchain -> uchain
            .all(ctx -> {
              String username = ctx.getPathTokens().get("username");
              ctx.byMethod(method -> method
                .get(() -> ctx.render("Received request for user: " + username))
                .put(() -> {
                  String json = ctx.getRequest().getBody().getText();
                  ctx.render("Received update request for user: " + username + ", JSON: " + json);
                })
                .delete(() -> ctx.render("Received delete request for user: " + username))
              );
            })
          )
          .all(ctx -> ctx
            .byMethod(method -> method
              .post(() -> {
                String json = ctx.getRequest().getBody().getText();
                ctx.render("Received request to create a new user with JSON: " + json);
              })
              .get(() -> ctx.render("Received request to list all users"))
            )
          )
        )
      )
    );
  }
}

```

唯一需要的修改是（1），我们通过一个显式的Registry实现提供了对Ratpack应用程序的定义。现在我们可以开始实现API层。

如果你仔细观察接下来的修改，就会理解Ratpack与传统的基于servlet的web应用是完全不同的。之前我们提及过，Ratpack的HTTP层构建在非阻塞的网络接口上，该web框架天然支持高性能。而基于servlet的web应用会为每个到来的请求产生一个新的线程，虽然会降低资源利用率，但每个请求处理流时是隔离的。在这种机制下，web应用处理请求时会采用阻塞式的方式，比如调用数据库并等待对应的结果然后返回，在等待期间（相对来说）并不关心这会影响它服务接下来的客户端的能力。在非阻塞式的web应用中，如果客户端或服务器端不发送数据，那么网络层并不会被阻塞，所以线程池中少量的“请求任务”线程就可以服务大量高并发的请求。然而这意味着如果应用程序代码阻塞了一个“请求任务”线程，那么吞吐量会显著影响。因此，阻塞操作（比如对数据库的操作）不能放置在请求线程中。

幸运的是，Ratpack通过在请求上下文中暴露一个阻塞接口来在应用程序中执行阻塞操作。该接口会把阻塞操作放置到另一个不同的线程池中，在维持高容量的情况服务新带来的请求的同时，这些阻塞调用也可以同步完成。一旦阻塞调用完成，处理流会返回到“请求任务”线程中，应答会被写回到客户端。在我们构建的API层中，我们要确保所有对UserRepository的操作都被路由到阻塞固定层中。列表9展示了API层的实现。

列表9

```java

package springpack;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import ratpack.exec.Promise;
import ratpack.handling.Context;
import ratpack.server.RatpackServer;
import ratpack.spring.Spring;
import springpack.model.User;
import springpack.model.UserRepository;

import java.util.HashMap;
import java.util.Map;

public class Main {
  private static final Map<String, String> NOT_FOUND = new HashMap<String, String>() \{\{
    put("status", "404");
    put("message", "NOT FOUND");
  }};
  private static final Map<String, String> NO_EMAIL = new HashMap<String, String>() \{\{
    put("status", "400");
    put("message", "NO EMAIL ADDRESS SUPPLIED");
  }};

  public static void main(String[] args) throws Exception {
    RatpackServer.start(spec -> spec
      .registry(Spring.spring(SpringBootConfig.class))
      .handlers(chain -> chain
        .prefix("api/users", pchain -> pchain
          .prefix(":username", uchain -> uchain
            .all(ctx -> {
              // extract the "username" path variable
              String username = ctx.getPathTokens().get("username");
              // pull the UserRepository out of the registry
              UserRepository userRepository = ctx.get(UserRepository.class);
              // pull the Jackson ObjectMapper out of the registry
              ObjectMapper mapper = ctx.get(ObjectMapper.class);
              // construct a "promise" for the requested user object. This will
              // be subscribed to within the respective handlers, according to what
              // they must do. The promise uses the "blocking" fixture to ensure
              // the DB call doesn't take place on a "request taking" thread.
              Promise<User> userPromise = ctx.blocking(() -> userRepository.findByUsername(username));
              ctx.byMethod(method -> method
                .get(() ->
                  // the .then() block will "subscribe" to the result, allowing
                  // us to send the user domain object back to the client
                  userPromise.then(user -> sendUser(ctx, user))
                )
                .put(() -> {
                  // Read the JSON from the request
                  String json = ctx.getRequest().getBody().getText();
                  // Parse out the JSON body into a Map
                  Map<String, String> body = mapper.readValue(json, new TypeReference<Map<String, String>>() {
                  });
                  // Check to make sure the request body contained an "email" address
                  if (body.containsKey("email")) {
                    userPromise
                      // map the new email address on to the user entity
                      .map(user -> {
                        user.setEmail(body.get("email"));
                        return user;
                      })
                      // and use the blocking thread pool to save the updated details
                      .blockingMap(userRepository::save)
                      // finally, send the updated user entity back to the client
                      .then(u1 -> sendUser(ctx, u1));
                  } else {
                    // bad request; we didn't get an email address
                    ctx.getResponse().status(400);
                    ctx.getResponse().send(mapper.writeValueAsBytes(NO_EMAIL));
                  }
                })
                .delete(() ->
                  userPromise
                    // make the DB delete call in a blocking thread
                    .blockingMap(user -> {
                      userRepository.delete(user);
                      return null;
                    })
                    // then send a 204 back to the client
                    .then(user -> {
                      ctx.getResponse().status(204);
                      ctx.getResponse().send();
                    })
                )
              );
            })
          )
          .all(ctx -> {
            // pull the UserRepository out of the registry
            UserRepository userRepository = ctx.get(UserRepository.class);
            // pull the Jackson ObjectMapper out of the registry
            ObjectMapper mapper = ctx.get(ObjectMapper.class);
            ctx.byMethod(method -> method
              .post(() -> {
                // read the JSON request body...
                String json = ctx.getRequest().getBody().getText();
                // ... and convert it into a user entity
                User user = mapper.readValue(json, User.class);
                // save the user entity on a blocking thread and
                // render the user entity back to the client
                ctx.blocking(() -> userRepository.save(user))
                  .then(u1 -> sendUser(ctx, u1));
              })
              .get(() ->
                // make the DB call, on a blocking thread, to list all users
                ctx.blocking(userRepository::findAll)
                  // and render the user list back to the client
                  .then(users -> {
                    ctx.getResponse().contentType("application/json");
                    ctx.getResponse().send(mapper.writeValueAsBytes(users));
                  })
              )
            );
          })
        )
      )
    );
  }

  private static void notFound(Context context) {
    ObjectMapper mapper = context.get(ObjectMapper.class);
    context.getResponse().status(404);
    try {
      context.getResponse().send(mapper.writeValueAsBytes(NOT_FOUND));
    } catch (JsonProcessingException e) {
      context.getResponse().send();
    }
  }

  private static void sendUser(Context context, User user) {
    if (user == null) {
      notFound(context);
    }

    ObjectMapper mapper = context.get(ObjectMapper.class);
    context.getResponse().contentType("application/json");
    try {
      context.getResponse().send(mapper.writeValueAsBytes(user));
    } catch (JsonProcessingException e) {
      context.getResponse().status(500);
      context.getResponse().send("Error serializing user to JSON");
    }
  }
}

```

API层最值得关注的点是对阻塞机制的使用，这次阻塞操作可以从每个请求的Conext对象中抽取出来。当调用ctx.blocking()方法时，会返回一个Promise对象，我们必须订阅该对象以便执行代码。我们可以抽取一个promise（在prefix(“:username”)中展示的一样）从而在不同的处理器中重用，保持代码简洁。

现在实现了API后，可以运行一系列curl测试来确保该微服务符合预期：

* 命令: curl -d '{"username": "dan", "email": "danielpwoods@gmail.com"}'http://localhost:5050/api/users, 期望结果: {"id":1,"username":"dan","email":"danielpwoods@gmail.com"}
* 命令: curl http://localhost:5050/api/users, 期望结果: [{"id":1,"username":"dan","email":"danielpwoods@gmail.com"}]
* 命令: curl -XPUT -d '{ "email": "daniel.p.woods@gmail.com" }'http://localhost:5050/api/users/dan, 期望结果: {"id":1,"username":"dan","email":"daniel.p.woods@gmail.com"}
* 命令: curl http://localhost:5050/api/users/dan, 期望结果: {"id":1,"username":"dan","email":"daniel.p.woods@gmail.com"}
* 命令: curl -XDELETE http://localhost:5050/api/users/dan, 期望结果: empty
* 命令: curl http://localhost:5050/api/users/dan, 期望结果: {"message":"NOT FOUND","status":"404"}

通过上面的命令序列可以看出API层工作完全正确，我们拥有了一个完全正式的数据驱动的基于Ratpack和Spring Boot的微服务，并且使用了Spring Data JPA！

整个过程的最后一步是部署。部署的最简单方式是执行gradle installDist命令。这会打包应用程序以及整个运行时依赖到一个traball(.tar文件)和zip(.zip文件)存档文件中。它另外也会创建跨平台的启动脚本，可以在任何安装了Java 8的系统中启动我们的微服务。当installDist任务完成后，可以在项目的build/distributions目录中找到这些存档文件。

通过本文章你已经学会了如何利用Spring Boot提供的大量生态系统以及Ratpack提供的高性能特性来打造一个微服务应用程序。你可以使用该示例作为起点来构建JVM上原生支持云的数据驱动的微服务程序。

欢迎使用Ratpack和Srping Boot！

### 关于作者

Daniel Woods醉心于企业级Java、Groovy以及Grails开发。他在JVM软件开发领域拥有10余年的工作经验，并且乐于向开源项目（比如[Grails](http://www.ratpack.io/)和[Ratpack](http://www.ratpack.io/)）贡献他的经验。Dan曾在Gr8conf和SpringOne 2GX大会上做过演讲嘉宾，展示了他基于JVM的企业级应用程序架构的专业知识。
