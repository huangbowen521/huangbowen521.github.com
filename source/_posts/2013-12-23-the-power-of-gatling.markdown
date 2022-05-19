---
layout: post
title: Gatling->次时代性能测试利器
date: 2013-12-23 23:07
comments: true
categories: Testing
tags: [Gatling]
---

Gatling作为一款开源免费的性能测试工具越来越受到广大程序员的欢迎。免费当然是好的，最缺钱的就是程序员了;开源更好啊，缺啥功能、想做定制化的可以自己动手，丰衣足食。其实我最喜欢的原因是其提供了简洁强大的API，原生支持命令行运行，不像JMeter那样需要在界面上点来点去。另外其出色的扩展API和轻量级的HTML报表都值得让人称道。

<!-- more -->

## Gatling版本

Gatling的的官方网站是[http://gatling-tool.org/](http://gatling-tool.org/)。目前Gatling有两个主线版本，一个是Gatling 1,最新版本是1.5.3;一个是Gatling 2,最新版本是2.0.0-M3a。Gatling 2使用了JDK7进行编译，使用的Scala版本是2.10，它对Gatling的API进行了一些重构和重新设计,内部也有一些调整。 目前Gatling 2还在开发阶段，所以如果要在项目中使用的话最好还是使用Gatling 1.5.3。


## 安装Gatling

其实Gatling是款绿色软件，可以直接从[https://github.com/excilys/gatling/wiki/Downloads](https://github.com/excilys/gatling/wiki/Downloads)下载指定的版本。下载下来解压缩以后，我们可以看到其目录结构。

```bash

twer@bowen-huang:~/sourcecode/GatlingWorkShop/gatling-charts-highcharts-1.5.2$ tree -L 2
.
├── bin                             //可执行文件目录
│   ├── gatling.bat
│   ├── gatling.sh
│   ├── recorder.bat
│   └── recorder.sh
├── conf                            //配置目录
│   ├── application.conf
│   ├── gatling.conf
│   └── logback.xml
├── lib                             //依赖的程序库
│   ├── akka-actor-2.0.4.jar
│   ├── async-http-client-1.7.18.20130621.jar
│   ├── commons-io-2.4.jar
│   ├── commons-lang-2.6.jar
│   ├── commons-math3-3.1.1.jar
│   ├── commons-pool-1.6.jar
│   ├── compiler-interface-0.12.3-sources.jar
│   ├── config-1.0.1.jar
│   ├── gatling-app-1.5.2.jar
│   ├── gatling-charts-1.5.2.jar
│   ├── gatling-charts-highcharts-1.5.2.jar
│   ├── gatling-core-1.5.2.jar
│   ├── gatling-http-1.5.2.jar
│   ├── gatling-jdbc-1.5.2.jar
│   ├── gatling-metrics-1.5.2.jar
│   ├── gatling-recorder-1.5.2.jar
│   ├── gatling-redis-1.5.2.jar
│   ├── grizzled-slf4j_2.9.2-0.6.10.jar
│   ├── incremental-compiler-0.12.3.jar
│   ├── jaxen-1.1.6.jar
│   ├── joda-convert-1.2.jar
│   ├── joda-time-2.2.jar
│   ├── jodd-core-3.4.4.jar
│   ├── jodd-lagarto-3.4.4.jar
│   ├── json-path-0.8.2.fix24.jar
│   ├── json-smart-1.1.1.jar
│   ├── jsoup-1.7.2.jar
│   ├── logback-classic-1.0.12.jar
│   ├── logback-core-1.0.12.jar
│   ├── netty-3.6.6.Final.jar
│   ├── opencsv-2.3.jar
│   ├── redisclient_2.9.2-2.10.jar
│   ├── scala-compiler-2.9.3.jar
│   ├── scala-library-2.9.3.jar
│   ├── scalate-core_2.9-1.6.1.jar
│   ├── scalate-util_2.9-1.6.1.jar
│   ├── scopt_2.9.2-2.1.0.jar
│   ├── slf4j-api-1.7.5.jar
│   ├── xercesImpl-2.11.0.jar
│   ├── xml-apis-1.4.01.jar
│   ├── xstream-1.4.3.jar
│   └── zinc-0.2.5.jar
├── results            //性能测试结果存放目录
│   └── blogsimulation-20131218210445
├── target             //性能测试脚本编译结果    
│   ├── cache
│   ├── classes
│   └── zincCache
└── user-files     //性能测试脚本源文件
    ├── data
    ├── request-bodies
    └── simulations 

```

Gatling在user-files目录中提供了几个性能测试脚本的示例。不过由于脚本中被测试的网站已经无法访问，所以我自己写了几个简单的测试脚本，已经放置到了Github上，可以通过[https://github.com/huangbowen521/GatlingWorkShop](https://github.com/huangbowen521/GatlingWorkShop)下载。

```bash

twer@bowen-huang:~/sourcecode/GatlingWorkShop/gatling-charts-highcharts-1.5.2/user-files$ tree simulations
simulations
└── blog
    ├── blog.scala
    └── github.scala

1 directory, 2 files 

``` 

可以看到在simulations目录下有两个文件，一个是我给自己的博客写的性能测试脚本，一个是给github写的一个性能测试脚本。

## 运行Gatling

在命令行下运行bin目录下的Gatling.sh(如果是windows用户，请运行Gatling.bat)。Gatling会自动列出当前所有的测试脚本供自己选择，然后会让填写simulation id(模拟Id)以及run description（运行描述）。输入完毕后按回车键测试即可启动。

```bash

twer@bowen-huang:~/sourcecode/GatlingWorkShop/gatling-charts-highcharts-1.5.2$ ./bin/gatling.sh
GATLING_HOME is set to /Users/twer/sourcecode/GatlingWorkShop/gatling-charts-highcharts-1.5.2
Choose a simulation number:
     [0] blog.BlogSimulation
     [1] blog.GithubSimulation
1
Select simulation id (default is 'githubsimulation'). Accepted characters are a-z, A-Z, 0-9, - and _
github
Select run description (optional)
testing github 

Simulation blog.GithubSimulation started…
 
……
……
……

Simulation finished.
Simulation successful.
Generating reports...
Reports generated in 0s.
Please open the following file : /Users/twer/sourcecode/GatlingWorkShop/gatling-charts-highcharts-1.5.2/results/github-20131223214957/index.html 

```

可以看到命令行中最后一行中标示了性能测试报表的存放路径。

## 查看测试报告

Gatling的测试报表其实就是一个html文件。Gatling使用了HighCharts这款JavaScript库来进行报表的展示。另外Gatling还提供了方便的接口用来自定义报告的展示。

以下是报表的部分截图。

{% img /images/gatlingReport1.png 800 %}

{% img /images/gatlingReport2.png 800 %}


## 测试脚本示例

这是GithubSimulation的性能测试脚本。其实它就是Scala的一个类，继承自Simulation。

```scala

package blog

import com.excilys.ebi.gatling.core.Predef._
import com.excilys.ebi.gatling.http.Predef._
import com.excilys.ebi.gatling.jdbc.Predef._
import com.excilys.ebi.gatling.http.Headers.Names._
import akka.util.duration._
import bootstrap._

class GithubSimulation extends Simulation {
     var httpConf = httpConfig.
     baseURL("https://github.com")

     var scn = scenario("search in github.com")
     .exec(
          http("home page")
          .get("/")
          .check(status.is(200)))
     .pause(0, 12)
     .exec(
          http("do search")
          .get("/search")
          .queryParam("q", "gatling")
          .check(status.is(200)))

     setUp(scn.users(500).ramp(10).protocolConfig(httpConf))
} 

``` 

在这个类中定义了一个httpConf，指定了被测网站的根目录。

```scala

     var httpConf = httpConfig.
     baseURL("https://github.com") 

```

然后定义了一个测试场景，用户先访问Github首页，检查http返回状态码是否为200，然后暂停一段时间后再执行一个查询操作，查询关键字是gatling，检查http返回状态码是否为200。

```scala

     var scn = scenario("search in github.com")
     .exec(
          http("home page")
          .get("/")
          .check(status.is(200)))
     .pause(0, 12)
     .exec(
          http("do search")
          .get("/search")
          .queryParam("q", "gatling")
          .check(status.is(200))) 

```

最后指定500个用户模拟该测试场景。500个用户以每秒50个递增，持续10秒。

```scala

     setUp(scn.users(500).ramp(10).protocolConfig(httpConf)) 

```

## 技术栈

这里列出了Gatling的一些主要的技术栈。

* **Akka Actors.** Gatling 使用了Akka作为其并发编程的运行时。Akka的Actors模式能够有效的绕过JVM上多线程带来的性能问题。

* **Scala.**选择Scala最大的原因是因为Scala可以很好的集成Akka,另一原因是作为一款运行在JVM上的语言，Scala更容易提供给用户简洁强大的API设计。

* **Async Http Client.** 使用这款开源库来是实现异步http通讯。并且使用了Netty调用http。

* **Highcharts及Highstock.** Gatling使用Highcarts和Highstock这两款JavaScript库来进行测试结果报表的展示。

---------------------------------------

其实Gatling并不完美，比如目前支持的协议并不多，不支持对数据库的性能测试，不能进行分布式性能测试等。当然Gatling也在不断的进步，看好你哦！







