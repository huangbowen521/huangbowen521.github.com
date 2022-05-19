---
layout: post
title: 翻译-使用Spring WebService生成SOAP web service
date: 2014-09-05 19:50:02 +1000
comments: true
categories: Spring
tags: [SOAP]
---


原文链接：[http://spring.io/guides/gs/producing-web-service/](http://spring.io/guides/gs/producing-web-service/)

## 生成SOAP web service

该指南将带领你使用Spring创建一个基于SOAP的web service的整个过程。

<!-- more -->

### 指南内容

你将创建一个服务，该服务通过一个基于WSDL的SOAP web service向外暴露欧洲国家的数据。

>　注意：为了简化该示例，你将使用硬编码方式嵌入英国，西班牙及波兰。

### 准备事项

* 15分钟

* 喜爱的编辑器或IDE

* JDK1.6或更高版本

* Gradle 1.11+或Maven 3.0+

* 你也可以直接通过该指南导入代码，或通过Spring工具集（Spring Tool Suite，简称STS)通过网页浏览代码，从而帮助你学习该章节内容。源码下载地址： [https://github.com/spring-guides/gs-producing-web-service.git](https://github.com/spring-guides/gs-producing-web-service.git)。

### 如何完成该指南

如同大多数的[示例教程](http://spring.io/guides)一样，你可以从头开始并完成每个步骤，或者你也可以跳过已经熟悉的基础章节。无论怎样，最终你要得到可以工作的代码。

想*从头开始*，请移动到[使用Gradle构建](#scratch)章节。

想*跳过基础部分*，请做以下事情：

* [下载](https://github.com/spring-guides/gs-soap-service/archive/master.zip)并解压该向导的源代码，或者使用[Git](http://spring.io/understanding/Git)复制一份： `git clone https://github.com/spring-guides/gs-soap-service.git`

* 切换到`gs-soap-service/initial`

* 跳到[添加Spring-WS依赖](#initial)章节。

当完成后，你可以使用`gs-soap-service/complete`目录中的代码检查你的结果。

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

下面是一个[初始的Gradle build文件](https://github.com/spring-guides/gs-soap-service/blob/master/initial/build.gradle)。

```groovy build.gradle

buildscript {
    repositories {
        mavenLocal()
        mavenCentral()
        maven { url "http://repo.spring.io/libs-release" }
    }
    dependencies {
        classpath("org.springframework.boot:spring-boot-gradle-plugin:1.1.5.RELEASE")
    }
}

apply plugin: 'java'
apply plugin: 'eclipse'
apply plugin: 'idea'
apply plugin: 'spring-boot'

jar {
    baseName = 'gs-producing-web-service'
    version =  '0.1.0'
}

repositories {
    mavenLocal()
    mavenCentral()
    maven { url "http://repo.spring.io/libs-release" }
}

dependencies {
    compile("org.springframework.boot:spring-boot-starter-web")
}

task wrapper(type: Wrapper) {
    gradleVersion = '1.11'
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
    <artifactId>gs-producting-web-service</artifactId>
    <version>0.1.0</version>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>1.1.5.RELEASE</version>
    </parent>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
    </dependencies>

    <properties>
        <!-- use UTF-8 for everything -->
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
        <start-class>hello.Application</start-class>
    </properties>

    <build>
        <plugins>
            <plugin>
                <artifactId>maven-compiler-plugin</artifactId>
            </plugin>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>

```

> 注意：你可能注意到我们指定了*maven-complier-plugin*的版本。通常并*不推荐*这样做。这里主要是为了解决我们的CI系统默认运行在该插件的早期版本（java5之前）的一个问题。

[Spring Boot Maven插件](https://github.com/spring-projects/spring-boot/tree/master/spring-boot-tools/spring-boot-maven-plugin)提供了很多便利的特性：

* 将classpath中的所有jar包构建单个可运行的jar包，从而更容易执行和传播服务。

* 搜索`public static void main（）`方法并标记为可运行的类。

* 提供了一个内置的依赖管理器，设置依赖版本以匹配[Spring Boot依赖](https://github.com/spring-projects/spring-boot/blob/master/spring-boot-dependencies/pom.xml)。你可以覆盖为任何你希望的版本，但默认会使用Boot选择的版本。

### 使用Spring工具集构建

如果你拥有Spring工具集，只需简单的[直接导入该指南](http://spring.io/guides/gs/sts/)。

### <a name="#initial">添加Spring-ws依赖</a>


你创建的项目需要添加`spring-ws-core`和wsdl4j依赖到构建文件中。

maven代码:

```xml 

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-ws</artifactId>
</dependency>
<dependency>
    <groupId>wsdl4j</groupId>
    <artifactId>wsdl4j</artifactId>
    <version>1.6.1</version>
</dependency>

```

gradle代码：

```groovy

dependencies {
    compile("org.springframework.boot:spring-boot-starter-ws")
    compile("wsdl4j:wsdl4j:1.6.1")
    jaxb("com.sun.xml.bind:jaxb-xjc:2.2.4-1")
    compile(files(genJaxb.classesDir).builtBy(genJaxb))
}

```

### 创建XML格式来定义领域对象

该web service领域对象被定义在一个XML格式文件中（XSD），Spring-WS将自动导出为一个WSDL文件。

创建一个XSD文件，包含一个操作来返回一个国家的*名称*，*人口*，*首都*和*货币*。

```xml src/main/resources/countries.xsd

<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tns="http://spring.io/guides/gs-producing-web-service"
           targetNamespace="http://spring.io/guides/gs-producing-web-service" elementFormDefault="qualified">

    <xs:element name="getCountryRequest">
        <xs:complexType>
            <xs:sequence>
                <xs:element name="name" type="xs:string"/>
            </xs:sequence>
        </xs:complexType>
    </xs:element>

    <xs:element name="getCountryResponse">
        <xs:complexType>
            <xs:sequence>
                <xs:element name="country" type="tns:country"/>
            </xs:sequence>
        </xs:complexType>
    </xs:element>

    <xs:complexType name="country">
        <xs:sequence>
            <xs:element name="name" type="xs:string"/>
            <xs:element name="population" type="xs:int"/>
            <xs:element name="capital" type="xs:string"/>
            <xs:element name="currency" type="tns:currency"/>
        </xs:sequence>
    </xs:complexType>

    <xs:simpleType name="currency">
        <xs:restriction base="xs:string">
            <xs:enumeration value="GBP"/>
            <xs:enumeration value="EUR"/>
            <xs:enumeration value="PLN"/>
        </xs:restriction>
    </xs:simpleType>
</xs:schema>

```

###　基于XML格式创建领域类

接下来的步骤是根据XSD文件来创建java类。正确的方式是使用maven或gradle插件在构建时间自动创建。

maven插件配置;

```xml

<plugin>
    <groupId>org.codehaus.mojo</groupId>
    <artifactId>jaxb2-maven-plugin</artifactId>
    <version>1.6</version>
    <executions>
        <execution>
            <id>xjc</id>
            <goals>
                <goal>xjc</goal>
            </goals>
        </execution>
    </executions>
    <configuration>
        <schemaDirectory>${project.basedir}/src/main/resources/</schemaDirectory>
        <outputDirectory>${project.basedir}/src/main/java</outputDirectory>
        <clearOutputDir>false</clearOutputDir>
    </configuration>
</plugin>

```

生成的类放置在`target/generated-sources/jaxb`目录。

gradle插件配置如下，首先需要在构建文件中配置JAXB：

```groovy

configurations {
    jaxb
}

jar {
    baseName = 'gs-producing-web-service'
    version =  '0.1.0'
    from genJaxb.classesDir
}

// tag::dependencies[]
dependencies {
    compile("org.springframework.boot:spring-boot-starter-ws")
    compile("wsdl4j:wsdl4j:1.6.1")
    jaxb("com.sun.xml.bind:jaxb-xjc:2.2.4-1")
    compile(files(genJaxb.classesDir).builtBy(genJaxb))
}
// end::dependencies[]

```

> 注意：上面的构建文件拥有tag及end注释。目的是为了能够在本指南中更容易抽取出来并做进一步解释。在你的构建文件中无需这些注释。

接下来的步骤是添加任务`genJaxb`,该任务会生成java类：

```groovy

task genJaxb {
    ext.sourcesDir = "${buildDir}/generated-sources/jaxb"
    ext.classesDir = "${buildDir}/classes/jaxb"
    ext.schema = "src/main/resources/countries.xsd"

    outputs.dir classesDir

    doLast() {
        project.ant {
            taskdef name: "xjc", classname: "com.sun.tools.xjc.XJCTask",
                    classpath: configurations.jaxb.asPath
            mkdir(dir: sourcesDir)
            mkdir(dir: classesDir)

            xjc(destdir: sourcesDir, schema: schema) {
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

### 创建国家仓库

为了给web service提供数据，需要创建一个国家仓库，在本指南中创建了一个硬编码的伪造的国家仓库实现。

```java

package hello;

import javax.annotation.PostConstruct;
import java.util.ArrayList;
import java.util.List;

import io.spring.guides.gs_producing_web_service.Country;
import io.spring.guides.gs_producing_web_service.Currency;
import org.springframework.stereotype.Component;
import org.springframework.util.Assert;

@Component
public class CountryRepository {
    private static final List<Country> countries = new ArrayList<Country>();

    @PostConstruct
    public void initData() {
        Country spain = new Country();
        spain.setName("Spain");
        spain.setCapital("Madrid");
        spain.setCurrency(Currency.EUR);
        spain.setPopulation(46704314);

        countries.add(spain);

        Country poland = new Country();
        poland.setName("Poland");
        poland.setCapital("Warsaw");
        poland.setCurrency(Currency.PLN);
        poland.setPopulation(38186860);

        countries.add(poland);

        Country uk = new Country();
        uk.setName("United Kingdom");
        uk.setCapital("London");
        uk.setCurrency(Currency.GBP);
        uk.setPopulation(63705000);

        countries.add(uk);
    }

    public Country findCountry(String name) {
        Assert.notNull(name);

        Country result = null;

        for (Country country : countries) {
            if (name.equals(country.getName())) {
                result = country;
            }
        }

        return result;
    }
}

```

### 创建国家服务终端

为了创建一个service endpoint，x需要一个pojo对象，以及一些Spring WS注解来处理SOAP请求：

```java

package hello;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ws.server.endpoint.annotation.Endpoint;
import org.springframework.ws.server.endpoint.annotation.PayloadRoot;
import org.springframework.ws.server.endpoint.annotation.RequestPayload;
import org.springframework.ws.server.endpoint.annotation.ResponsePayload;

import io.spring.guides.gs_producing_web_service.GetCountryRequest;
import io.spring.guides.gs_producing_web_service.GetCountryResponse;

@Endpoint
public class CountryEndpoint {
    private static final String NAMESPACE_URI = "http://spring.io/guides/gs-producing-web-service";

    private CountryRepository countryRepository;

    @Autowired
    public CountryEndpoint(CountryRepository countryRepository) {
        this.countryRepository = countryRepository;
    }

    @PayloadRoot(namespace = NAMESPACE_URI, localPart = "getCountryRequest")
    @ResponsePayload
    public GetCountryResponse getCountry(@RequestPayload GetCountryRequest request) {
        GetCountryResponse response = new GetCountryResponse();
        response.setCountry(countryRepository.findCountry(request.getName()));

        return response;
    }
}

```

`@Endpoint`向Spring WS注册了该类为一个处理来临的SOAP消息的潜在对象。

`@PayloadRoot` 被Spring WS用来根据消息的*命名空间*及*localPart*来选择处理该请求的方法。

`@RequestPayload` 指明来临的消息将被映射到该方法的request参数。

`@ResponsePayload`注解将使得Spring WS将返回值与响应负载映射起来。

> 注意：在以上代码中，如果你没有运行任务来根据WSDL生成领域对象，那么在你的IDE中io.spring.guides类将会报告编译时错误。

### 配置web service bean

使用Spring WS相关的bean配置选项创建一个新的类：

```java

package hello;

import org.springframework.boot.context.embedded.ServletRegistrationBean;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.ws.config.annotation.EnableWs;
import org.springframework.ws.config.annotation.WsConfigurerAdapter;
import org.springframework.ws.transport.http.MessageDispatcherServlet;
import org.springframework.ws.wsdl.wsdl11.DefaultWsdl11Definition;
import org.springframework.xml.xsd.SimpleXsdSchema;
import org.springframework.xml.xsd.XsdSchema;

@EnableWs
@Configuration
public class WebServiceConfig extends WsConfigurerAdapter {
    @Bean
    public ServletRegistrationBean dispatcherServlet(ApplicationContext applicationContext) {
        MessageDispatcherServlet servlet = new MessageDispatcherServlet();
        servlet.setApplicationContext(applicationContext);
        servlet.setTransformWsdlLocations(true);
        return new ServletRegistrationBean(servlet, "/ws/*");
    }

    @Bean(name = "countries")
    public DefaultWsdl11Definition defaultWsdl11Definition(XsdSchema countriesSchema) {
        DefaultWsdl11Definition wsdl11Definition = new DefaultWsdl11Definition();
        wsdl11Definition.setPortTypeName("CountriesPort");
        wsdl11Definition.setLocationUri("/ws");
        wsdl11Definition.setTargetNamespace("http://spring.io/guides/gs-producing-web-service");
        wsdl11Definition.setSchema(countriesSchema);
        return wsdl11Definition;
    }

    @Bean
    public XsdSchema countriesSchema() {
        return new SimpleXsdSchema(new ClassPathResource("countries.xsd"));
    }
}

```

* 这里Spring WS使用了不同的servlet类型来处理SOAP消息：`MessageDispatcherServlet`。注入及设置`MessageDispatcherServlet`给`ApplicationContext`是非常重要的。如果不这样做，Spring WS无法自动检测到Spring bean。

* 通过给`dispatcherServlet` bean命名，[替代](http://docs.spring.io/spring-boot/docs/1.1.5.RELEASE/reference/htmlsingle/#howto-switch-off-the-spring-mvc-dispatcherservlet)了Spring Boot中默认的`DispatcherServlet bean`。

* `DefaultMethodEndpointAdapter`配置了注解驱动的Spring WS编程模型。这使得使用前面提过的诸如`@Endpoint`等各种各样的注解成为可能。

* `DefaultWsdl11Defination`使用`XsdSchema`暴露了一个标准的WSDL 1.1。

请注意你需要为`MessageDispatcherServlet`及`DefaultWsdl11Definition`制定bean名称，这是非常重要的。Bean名称决定了生成的WSDL文件在哪个web service是可用的。在本例中，WSDL可通过`http://<host>:<port>/ws/countries.wsdl`来访问。

该配置也使用了WSDL位置servlet转化`servlet.setTransformWsdlLocations(true)`。如果你访问[http://localhost:8080/ws/countries.wsdl](http://localhost:8080/ws/countries.wsdl)，`soap：address`将拥有正确的值。如果你使用本机的公共IP来访问该WSDL，你将看到的是IP。

### 创建该程序的可执行文件

尽管我们可以将该程序打包成一个传统的[war包](http://spring.io/understanding/WAR)并部署到一个外部的应用程序服务器中，但是最简单的方式还是下面所演示的，创建一个能独立运行的应用程序。你可以通过老但好用的java `main()`方法，将所有文件打包到单个可执行的jar包中。同时，可以借助于Spring的支持内置[Tomcat](http://spring.io/understanding/Tomcat) servlet容器作为HTTP运行时，从而无需部署到外部的实例中。

```java src/main/java/hello/Application.java

package hello;

import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.SpringApplication;
import org.springframework.context.annotation.ComponentScan;

@ComponentScan
@EnableAutoConfiguration
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}

```

`main()`方法使用了`SpringApplication`辅助方法，将`Application.class`作为参数传递给其自身的`run（）`方法。这告诉Spring读取`Application`中的注解元数据，并将其作为[Spring 应用程序上下文](http://spring.io/understanding/application-context)的组件。

`@ComponentScan`注解告诉Spring递归搜索`hello`包及其子包中找到被直接或者间接使用了Spring的`@Component`注解的类。该指令确保了Spring发现并注册`CountryRepository`及`CountriesEndpoint`，因为他们被标记为`@Component`及`@Endpoint`，这是一种`@Component`注解。

`@EnableAutoConfiguration`注解会基于classpath内容切换到默认的合理的行为。例如，由于应用程序依赖Tomcat的内置版本（tomcat-embed-core.jar），Spring会替你设置并配置一个默认的合理的Tomcat服务器。并且该程序还依赖Spring MVC（spring-webmvc.jar），Spring会配置并注册以恶搞Spring MVC `DispatcherServlet`，根本无需`web.xml`文件！自动配置是强大的，弹性的机制。请查看[API文档](http://docs.spring.io/spring-boot/docs/1.1.5.RELEASE/api/org/springframework/boot/autoconfigure/EnableAutoConfiguration.html)获取更多细节。

#### 构建可执行的jar包

你可以创建一个包含所有必须的依赖，类，及资源的可执行的JAR文件。这很方便传输，版本管理以及独立于部署生命周期来部署服务，跨不同的环境，诸如此类。

```bash

./gradlew build

```

然后你可以运行WAR文件：

```bash

java -jar build/libs/gs-soap-service-0.1.0.jar

```

如果你使用的是maven，你可以使用`mvn spring-boot:run`来运行程序，或者你可以使用`mvn clean package`构建JAR文件，并使用下面命令来运行：

```bash

java -jar target/gs-soap-service-0.1.0.jar

```

> 注意：上面的产出物是以恶搞可运行JAR文件。你也可以[创建一个经典的WAR文件](http://spring.io/guides/gs/convert-jar-to-war/)。

###　运行服务

如果使用的是Gradle，可以使用以下命令来运行服务：

```bash

./gradlew clean build && java -jar build/libs/gs-soap-service-0.1.0.jar

```

注意：如果你使用的是Maven，可以使用以下命令来运行服务：`mvn clean package && java -jar target/gs-soap-service-0.1.0.jar`。

你也可以通过Gradle直接运行该程序：

```bash

./gradlew bootRun

```

> 注意：使用mvn的话，命令是`mvn spring-boot:run`。

可以看到日志输出。该服务应该在几秒钟内启动并运行起来。

###　测试该程序

现在该程序正在运行，你可以测试它。创建一个名为`request.xml`文件，包含以下的SOAP请求；

```xml

<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
                  xmlns:gs="http://spring.io/guides/gs-producing-web-service">
   <soapenv:Header/>
   <soapenv:Body>
      <gs:getCountryRequest>
         <gs:name>Spain</gs:name>
      </gs:getCountryRequest>
   </soapenv:Body>
</soapenv:Envelope>

```

有很多方式来测试该SOAP接口。你可以使用[SoapUI](http://www.soapui.org/)等工具，或者如果你使用的是*nix/Mac系统的话，直接可以使用命令行，如下所示：

```bash

$ curl --header "content-type: text/xml" -d @request.xml http://localhost:8080/ws

```

你将看到如下的响应结果：

```xml

<?xml version="1.0"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
  <SOAP-ENV:Header/>
  <SOAP-ENV:Body>
    <ns2:getCountryResponse xmlns:ns2="http://spring.io/guides/gs-producing-web-service">
      <ns2:country>
        <ns2:name>Spain</ns2:name>
        <ns2:population>46704314</ns2:population>
        <ns2:capital>Madrid</ns2:capital>
        <ns2:currency>EUR</ns2:currency>
      </ns2:country>
    </ns2:getCountryResponse>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>

```

> 注意：输出可能是一个紧凑的XML文档，而不是上面显示的格式友好的文档。如果系统中安装了xmllib2，可以使用`curl <args above> > output.xml | xmllint --format output.xml`来查看格式友好的结果。

###　总结

恭喜你！你使用Spring Web Service开发完成了一个基于SOAP的服务。