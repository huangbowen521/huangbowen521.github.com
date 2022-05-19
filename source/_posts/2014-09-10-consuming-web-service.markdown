---
layout: post
title: 翻译-使用Spring调用SOAP web service
date: 2014-09-10 23:02:41 +1000
comments: true
categories: Spring
tags: [Consume]
---

原文链接: [http://spring.io/guides/gs/consuming-web-service/](http://spring.io/guides/gs/consuming-web-service/)


## 调用SOAP web service

本指南将指导你使用Spring调用一个基于SOAP的web service的整个过程。

<!-- more -->

### 指南内容

你将构建一个客户端，使用SOAP用来从远端的基于WSDL的web service获取天气数据。请访问[http://wiki.cdyne.com/index.php/CDYNE_Weather](http://wiki.cdyne.com/index.php/CDYNE_Weather)进一步获取该天气服务的信息。

该服务根据邮编返回天气预测。你可以使用自己的邮编。

### 准备事项

* 大约15分钟

* 钟爱的编辑器或IDE

* JDK1.6或更高版本

* Gradle 1.11+ 或 Maven 3.0+

* 你也可以直接参阅该指南导入代码，或通过Spring工具集（Spring Tool Suite，简称STS)通过网页浏览代码，从而帮助你学习该章节内容。源码下载地址:[https://github.com/spring-guides/gs-consuming-web-service.git](https://github.com/spring-guides/gs-consuming-web-service.git)。

### 如何完成该指南

如同大多数的[示例教程](http://spring.io/guides)一样，你可以从头开始并完成每个步骤，或者你也可以跳过已经熟悉的基础章节。无论怎样，最终你要得到可以工作的代码。

想*从头开始*，请移动到[使用Gradle构建](#scratch)章节。

想*跳过基础部分*，请做以下事情：

* [下载]()并解压该向导的源代码，或者使用[Git](ttp://spring.io/understanding/Git)复制一份： `git clone https://github.com/spring-guides/gs-consuming-web-service.git`

* 切换到`gs-consuming-web-service/initial` 

* 跳到基于WSDL生成领域对象章节。

当完成后，你可以使用`gs-consuming-web-service/complete`目录中的代码检查你的结果。

### <a name="#scratch">使用Gradle构建</a>

首先你要设置一个基本的build脚本。当构建Spring应用程序时，你可以使用任何构建系统，但是这里只包括了使用[Maven](https://maven.apache.org)和[Gradle](gradle.org)的代码。如果你两者都不熟悉，请访问[使用Gradle构建Java项目](http://spring.io/guides/gs/gradle)或[使用Maven构建Java项目](http://spring.io/guides/gs/maven)。

#### 创建目录结构

在你选择的存放项目的目录中，创建如下的子目录结构。例如，在*nix系统中使用`mkdir -p src/main/java/hello`。

```text

└── src
    └── main
        └── java
            └── hello

```

#### 创建Gradle 构建文件

下面是一个[初始的Gradle build文件](https://github.com/spring-guides/gs-consuming-web-service/blob/master/initial/build.gradle)。

```groovy build.gradle

configurations {
    jaxb
}

buildscript {
    repositories {
        maven { url "http://repo.spring.io/libs-release" }
        mavenLocal()
        mavenCentral()
    }
    dependencies {
        classpath("org.springframework.boot:spring-boot-gradle-plugin:1.1.6.RELEASE")
    }
}

apply plugin: 'java'
apply plugin: 'eclipse'
apply plugin: 'idea'
apply plugin: 'spring-boot'

repositories {
    mavenLocal()
    mavenCentral()
    maven { url 'http://repo.spring.io/libs-release' }
}

// tag::wsdl[]
task genJaxb {
    ext.sourcesDir = "${buildDir}/generated-sources/jaxb"
    ext.classesDir = "${buildDir}/classes/jaxb"
    ext.schema = "http://wsf.cdyne.com/WeatherWS/Weather.asmx?wsdl"

    outputs.dir classesDir

    doLast() {
        project.ant {
            taskdef name: "xjc", classname: "com.sun.tools.xjc.XJCTask",
                    classpath: configurations.jaxb.asPath
            mkdir(dir: sourcesDir)
            mkdir(dir: classesDir)

            xjc(destdir: sourcesDir, schema: schema,
                    package: "hello.wsdl") {
                arg(value: "-wsdl")
                produces(dir: sourcesDir, includes: "**/*.java")
            }

            javac(destdir: classesDir, source: 1.6, target: 1.6, debug: true,
                    debugLevel: "lines,vars,source",
                    classpath: configurations.jaxb.asPath) {
                src(path: sourcesDir)
                include(name: "**/*.java")
                include(name: "*.java")
            }

            copy(todir: classesDir) {
                fileset(dir: sourcesDir, erroronmissingdir: false) {
                    exclude(name: "**/*.java")
                }
            }
        }
    }
}
// end::wsdl[]

dependencies {
    compile("org.springframework.boot:spring-boot-starter")
    compile("org.springframework.ws:spring-ws-core")
    compile(files(genJaxb.classesDir).builtBy(genJaxb))

    jaxb "com.sun.xml.bind:jaxb-xjc:2.1.7"
}

jar {
    from genJaxb.classesDir
}

task wrapper(type: Wrapper) {
    gradleVersion = '1.11'
}

task afterEclipseImport {
    dependsOn genJaxb
}
```

[Spring Boot gradle插件](https://github.com/spring-projects/spring-boot/tree/master/spring-boot-tools/spring-boot-gradle-plugin)提供了很多便利的特性：

* 将classpath中的所有jar包构建单个可运行的jar包，从而更容易执行和传播服务。

* 搜索`public static void main（）`方法并标记为可运行的类。

* 提供了一个内置的依赖管理器，设置依赖版本以匹配[Spring Boot依赖](https://github.com/spring-projects/spring-boot/blob/master/spring-boot-dependencies/pom.xml)。你可以覆盖为任何你希望的版本，但默认会使用Boot选择的版本。

### 使用Maven构建

首先你需要设置一个基本的构建脚本。你可以使用任何构建系统来构建Spring应用程序，但这里包含了[Maven](https://maven.apache.org/)的代码。如果你对Maven不熟，请访问[使用Maven构建Java项目](http://spring.io/guides/gs/maven)。

#### 创建目录结构

在你选择的存放项目的目录中，创建如下的子目录结构。例如，在*nix系统中使用`mkdir -p src/main/java/hello`。

```text

└── src
    └── main
        └── java
            └── hello
```

```xml pom.xml

<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.springframework</groupId>
    <artifactId>gs-consuming-web-service</artifactId>
    <version>0.1.0</version>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>1.1.6.RELEASE</version>
    </parent>

    <properties>
        <!-- use UTF-8 for everything -->
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.ws</groupId>
            <artifactId>spring-ws-core</artifactId>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>2.3.2</version>
            </plugin>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
            <!-- tag::wsdl[] -->
            <plugin>
                <groupId>org.jvnet.jaxb2.maven2</groupId>
                <artifactId>maven-jaxb2-plugin</artifactId>
                <executions>
                    <execution>
                        <goals>
                            <goal>generate</goal>
                        </goals>
                    </execution>
                </executions>
                <configuration>
                    <schemaLanguage>WSDL</schemaLanguage>
                    <generatePackage>hello.wsdl</generatePackage>
                    <forceRegenerate>true</forceRegenerate>
                    <schemas>
                        <schema>
                            <url>http://wsf.cdyne.com/WeatherWS/Weather.asmx?wsdl</url>
                        </schema>
                    </schemas>
                </configuration>
            </plugin>
            <!-- end::wsdl[] -->
        </plugins>
    </build>

    <repositories>
        <repository>
            <id>spring-releases</id>
            <name>Spring Releases</name>
            <url>http://repo.spring.io/libs-release</url>
        </repository>
    </repositories>
    <pluginRepositories>
        <pluginRepository>
            <id>spring-releases</id>
            <url>http://repo.spring.io/libs-release</url>
        </pluginRepository>
    </pluginRepositories>

</project>

```

> 注意：你可能注意到我们指定了*maven-complier-plugin*的版本。通常并*不推荐*这样做。这里主要是为了解决我们的CI系统默认运行在该插件的早期版本（java5之前）的一个问题。

[Spring Boot Maven插件](https://github.com/spring-projects/spring-boot/tree/master/spring-boot-tools/spring-boot-maven-plugin)提供了很多便利的特性：

* 将classpath中的所有jar包构建单个可运行的jar包，从而更容易执行和传播服务。

* 搜索`public static void main（）`方法并标记为可运行的类。

* 提供了一个内置的依赖管理器，设置依赖版本以匹配[Spring Boot依赖](https://github.com/spring-projects/spring-boot/blob/master/spring-boot-dependencies/pom.xml)。你可以覆盖为任何你希望的版本，但默认会使用Boot选择的版本。

### 使用Spring工具集构建

如果你拥有Spring工具集，只需简单的[直接导入该指南](http://spring.io/guides/gs/sts/)。

>注意:如果你阅读过生成SOAP web service,你可能会疑惑为什么该指南没有使用**spring-boot-starter-ws**?这是因为Spring Boot Starter只用于服务器端程序。Starter提供了诸如嵌入式Tomcat等功能，而服务调用则不需要这些。

### 基于WSDL生成领域对象

SOAP web service的接口描述在[WSDL](http://en.wikipedia.org/wiki/Web_Services_Description_Language)文件中。JAXB提供了一个简单的方式来从WSDL（或者WSDL中包含在`<Types/>`节点中的XSD）生成Java类。可以访问[http://wsf.cdyne.com/WeatherWS/Weather.asmx?wsdl](http://wsf.cdyne.com/WeatherWS/Weather.asmx?wsdl)获取该天气服务的WSDL。

你需要下列插件来使用maven从WSDL生成Java类：

```xml

<plugin>
    <groupId>org.jvnet.jaxb2.maven2</groupId>
    <artifactId>maven-jaxb2-plugin</artifactId>
    <executions>
        <execution>
            <goals>
                <goal>generate</goal>
            </goals>
        </execution>
    </executions>
    <configuration>
        <schemaLanguage>WSDL</schemaLanguage>
        <generatePackage>hello.wsdl</generatePackage>
        <forceRegenerate>true</forceRegenerate>
        <schemas>
            <schema>
                <url>http://wsf.cdyne.com/WeatherWS/Weather.asmx?wsdl</url>
            </schema>
        </schemas>
    </configuration>
</plugin>

```
该代码将通过指定的WSDL的URL生成类，并放置在`hello.wsdl`包中。

你也可以使用下列代码在Gradle中完成同样的事：

```groovy

task genJaxb {
    ext.sourcesDir = "${buildDir}/generated-sources/jaxb"
    ext.classesDir = "${buildDir}/classes/jaxb"
    ext.schema = "http://wsf.cdyne.com/WeatherWS/Weather.asmx?wsdl"

    outputs.dir classesDir

    doLast() {
        project.ant {
            taskdef name: "xjc", classname: "com.sun.tools.xjc.XJCTask",
                    classpath: configurations.jaxb.asPath
            mkdir(dir: sourcesDir)
            mkdir(dir: classesDir)

            xjc(destdir: sourcesDir, schema: schema,
                    package: "hello.wsdl") {
                arg(value: "-wsdl")
                produces(dir: sourcesDir, includes: "**/*.java")
            }

            javac(destdir: classesDir, source: 1.6, target: 1.6, debug: true,
                    debugLevel: "lines,vars,source",
                    classpath: configurations.jaxb.asPath) {
                src(path: sourcesDir)
                include(name: "**/*.java")
                include(name: "*.java")
            }

            copy(todir: classesDir) {
                fileset(dir: sourcesDir, erroronmissingdir: false) {
                    exclude(name: "**/*.java")
                }
            }
        }
    }
}

```

由于gradle还没有jaxb插件，所以它调用了一个ant任务，代码看起来比maven稍显复杂。
在maven和gradle两个示例中，JAXB领域对象生成过程被包括在构建工具的生命周期中，所以无需额外步骤来运行。

### 创建天气服务客户端

创建一个web service客户端，你只需要扩展`WebServiceGatewaySupport`类并编写操作代码：

```java src/main/java/hello/WeatherClient.java


package hello;

import java.text.SimpleDateFormat;

import org.springframework.ws.client.core.support.WebServiceGatewaySupport;
import org.springframework.ws.soap.client.core.SoapActionCallback;

import hello.wsdl.Forecast;
import hello.wsdl.ForecastReturn;
import hello.wsdl.GetCityForecastByZIP;
import hello.wsdl.GetCityForecastByZIPResponse;
import hello.wsdl.Temp;

public class WeatherClient extends WebServiceGatewaySupport {

    public GetCityForecastByZIPResponse getCityForecastByZip(String zipCode) {
        GetCityForecastByZIP request = new GetCityForecastByZIP();
        request.setZIP(zipCode);

        System.out.println();
        System.out.println("Requesting forecast for " + zipCode);

        GetCityForecastByZIPResponse response = (GetCityForecastByZIPResponse) getWebServiceTemplate().marshalSendAndReceive(
                request,
                new SoapActionCallback(
                        "http://ws.cdyne.com/WeatherWS/GetCityForecastByZIP"));

        return response;
    }

    public void printResponse(GetCityForecastByZIPResponse response) {
        ForecastReturn forecastReturn = response.getGetCityForecastByZIPResult();

        if (forecastReturn.isSuccess()) {
            System.out.println();
            System.out.println("Forecast for " + forecastReturn.getCity() + ", "
                    + forecastReturn.getState());

            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            for (Forecast forecast : forecastReturn.getForecastResult().getForecast()) {
                System.out.print(format.format(forecast.getDate().toGregorianCalendar().getTime()));
                System.out.print(" ");
                System.out.print(forecast.getDesciption());
                System.out.print(" ");
                Temp temperature = forecast.getTemperatures();
                System.out.print(temperature.getMorningLow() + "\u00b0-"
                        + temperature.getDaytimeHigh() + "\u00b0 ");
                System.out.println();
            }
        } else {
            System.out.println("No forecast received");
        }
    }

}

```

该客户端包含了两个方法。`getCityForecastByZip`用于实际的SOAP交换;`printResponse`打印收到的响应结果。我们重点关注第一个方法。

在该方法中，`GetCityForecastByZIP`及`GetCityForecastByZIPResponse`类衍生于WSDL中，被前一个步骤描述过的JAXB生成。该方法创建了`GetCityForecastByZIP`请求对象并设置了`zipCode`参数。打印出邮编后，使用WebServiceGatewaySupport基类提供的[WebServiceTemplate](http://docs.spring.io/spring-ws/sites/2.0/apidocs/org/springframework/ws/client/core/WebServiceTemplate.html)来进行实际的SOAP交换。它传入`GetCityForecastByZIP`请求对象，以及一个`SoapActionCallback`来传入[SOAPAction](http://www.w3.org/TR/2000/NOTE-SOAP-20000508/#_Toc478383528)头，因为WSDL说明其需要在`<soap:operation/>`元素中使用该头。该方法将返回值转换为`GetCityForecastByZIPResponse`对象，然后返回该对象。


### 配置web service组件

Spring WS使用了Spring框架的OXM模块。该模块拥有`Jaxb2Marshaller`类来序列化和反序列化XML请求。

```java src/main/java/hello/WeatherConfiguration.java

package hello;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.oxm.jaxb.Jaxb2Marshaller;

@Configuration
public class WeatherConfiguration {

    @Bean
    public Jaxb2Marshaller marshaller() {
        Jaxb2Marshaller marshaller = new Jaxb2Marshaller();
        marshaller.setContextPath("hello.wsdl");
        return marshaller;
    }

    @Bean
    public WeatherClient weatherClient(Jaxb2Marshaller marshaller) {
        WeatherClient client = new WeatherClient();
        client.setDefaultUri("http://wsf.cdyne.com/WeatherWS/Weather.asmx");
        client.setMarshaller(marshaller);
        client.setUnmarshaller(marshaller);
        return client;
    }

}


```

`marshaller`被指向了生成的领域对象集合，将使用这些对象来实现XML和POJO之间的序列化和反序列化。

我们使用了上面显示的天气服务URI创建和配置了`weatherClient`。他也被配置使用JAXB marshaller。

### 生成可执行的应用程序

该应用程序被打包后可运行与命令行，传入一个邮编则会得到一个天气预报。

```java src/main/java/hello/Application.java

package hello;

import org.springframework.boot.SpringApplication;
import org.springframework.context.ApplicationContext;

import hello.wsdl.GetCityForecastByZIPResponse;

public class Application {

    public static void main(String[] args) {
        ApplicationContext ctx = SpringApplication.run(WeatherConfiguration.class, args);

        WeatherClient weatherClient = ctx.getBean(WeatherClient.class);

        String zipCode = "94304";
        if (args.length > 0) {
            zipCode = args[0];
        }
        GetCityForecastByZIPResponse response = weatherClient.getCityForecastByZip(zipCode);
        weatherClient.printResponse(response);
    }

}


```

`main()`方法调用了`SpringApplication`辅助方法，并向其`run()`方法传入了`WeatherConfiguration.class`参数。这会使`Spring从WeatherConfiguration`中读取注解元数据，并作为[Spring应用程序上下文中](http://spring.io/understanding/application-context)的一个组件进行管理。

> 注意:该应用程序硬编码了邮编94304，Palo Alto, CA。在该指南的最后，你可以看到如何添加不同的邮编而不用修改代码。

### 构建可执行的jar包

你可以创建一个包含所有必须的依赖，类，及资源的可执行的JAR文件。这很方便传输，版本管理以及独立于部署生命周期来部署服务，跨不同的环境，诸如此类。

```bash

gradlew build

```

然后你可以运行WAR文件：

```bash

java -jar build/libs/gs-consuming-web-service-0.1.0.jar

```

如果你使用的是maven，你可以使用`mvn spring-boot:run`来运行程序，或者你可以使用`mvn clean package`构建JAR文件，并使用下面命令来运行：

```bash

java -jar target/gs-consuming-web-service-0.1.0.jar

```

> 注意：上面的产出物是一个可运行JAR文件。你也可以[创建一个经典的WAR文件](http://spring.io/guides/gs/convert-jar-to-war/)。　

### 运行服务

如果使用的是Gradle，可以使用以下命令来运行服务：

```bash

gradlew clean build && java -jar build/libs/gs-consuming-web-service-0.1.0.jar

```

> 注意：如果你使用的是Maven，可以使用以下命令来运行服务：`mvn clean package && java -jar target/gs-consuming-web-service-0.1.0.jar`。

你也可以通过Gradle直接运行该程序：

```bash

gradlew bootRun

```

>注意：使用mvn的话，命令是`mvn spring-boot:run`。

可以看到日志输出。该服务应该在几秒钟内启动并运行起来。


```text

Requesting forecast for 94304

Forecast for Palo Alto, CA
2013-01-03 Partly Cloudy °-57°
2013-01-04 Partly Cloudy 41°-58°
2013-01-05 Partly Cloudy 41°-59°
2013-01-06 Partly Cloudy 44°-56°
2013-01-07 Partly Cloudy 41°-60°
2013-01-08 Partly Cloudy 42°-60°
2013-01-09 Partly Cloudy 43°-58°

```

你也可以使用不同的邮编：`java -jar build/libs/gs-consuming-web-service-0.1.0.jar 34769`

```text

Requesting forecast for 34769

Forecast for Saint Cloud, FL
2014-02-18 Sunny 51°-79°
2014-02-19 Sunny 55°-81°
2014-02-20 Sunny 59°-84°
2014-02-21 Partly Cloudy 63°-85°
2014-02-22 Partly Cloudy 63°-84°
2014-02-23 Partly Cloudy 63°-82°
2014-02-24 Partly Cloudy 62°-80°


```

### 总结

恭喜你！你开发了一个客户端来使用Spring调用一个基于SOAP的web service。







