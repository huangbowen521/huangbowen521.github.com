---
layout: post
title: 使用Gradle运行集成测试
date: 2013-12-10 13:17
comments: true
categories: Gradle
tags: [Gradle, build, integration]  
---

如果Gradle构建的项目是一个web项目的话，里面可能包含一些集成测试和功能性测试。这些测试和单元测试不同之处是在运行之前要先在本地将web服务启动起来，并且跑完测试后能够自动的关闭web服务。

<!-- more -->

在本地启动web服务我们可以使用Gradle内置的jetty插件。jetty是一个轻量级的web容器，其执行速度快，配置简单，远程调试方便。启用jetty只需在build.gradle中加入对这个插件的引用。


```groovy build.gradle

apply plugin: 'jetty'

```

之后可以配置war包的名称，启动的端口等属性。

```groovy build.gradle

apply plugin: 'jetty'

httpPort = 9876

[jettyRun, jettyRunWar, jettyStop]*.stopPort = 9966
[jettyRun, jettyRunWar, jettyStop]*.stopKey = 'stopKey'

```

我们需要将集成测试与一般的单元测试分开。因为单元测试并不需要事先启动web服务，保证其执行速度快，能够得到更快的反馈。一般做法是单元测试后缀名为Test.java，集成测试后缀名为IntegrationTest.java。

配置单元测试执行的测试集合。

```groovy build.gradle

test {
	include '**/*Test.class'
	exclude '**/*IntegrationTest.class'
}

```

然后新建一个Task，用于运行集成测试。

```groovy build.gradle

task intTest(type: Test, dependsOn: test) {

	include '**/*IntegrationTest.class'

	doFirst {

		jettyRun.daemon = true
		jettyRun.execute()

	}

	doLast {
		jettyStop.execute()
	}
}

```

上述代码首先是创建一个名为intTest的task，其类型为Test,依赖于test task。该集成测试只会运行后缀名为IntegrationTest的测试类。在运行测试之前，首先采用后台模式启动jetty服务器，运行完测试后再调用jettyStop task停止jetty服务。

为了使我们在运行`gradle build`时也会运行intTest task，可以添加对intTest的依赖。

```groovy build.gradle

build.dependsOn intTest

```

这样在运行`gradle build`时也会运行集成测试。并且在集成测试前后web服务会自动的启动和关闭。

