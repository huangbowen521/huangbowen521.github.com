---
layout: post
title: Gradle的属性设置大全
date: 2013-09-12 22:41
comments: true
categories: Gradle
tags: [Gradle, Build]
---

Gradle作为一款项目构建工具，由于其强大、灵活、快速、完全兼容Ant等特性，越来越受到人们欢迎。Gradle的灵活有时候也会引起人们的困惑。比如在Gradle中设置变量和属性就有N种办法。由于Gradle的理念是Convention over configruation(约定优于配置),所以如果了解了这些约定，那么在使用Gradle的属性配置时一定会如鱼得水。

<!-- more -->

---------------------

**在项目根目录下建立名为gradle.properties文件，在该文件中定义需要的属性。这些属性在Gradle构建Gradle领域对象（即project对象实例）时会被自动加到project对象实例中作为其属性被直接调用。**


```xml gradle.properties

guestName= Bowen 

```


```groovy build.gradle

task hello << {
     println $guestName
     println "hello, $guestName"
}

```

```bash

$ gradle hello -q
Bowen
hello, Bowen

$ gradle properties | grep guestName
guestName: Bowen

```

--------------------
**定义在build.gradle中的ext块中。ext准确的说是Gradle领域对象的一个属性，我们可以将自定义的属性添加到ext对象上，Build.gradle中的其它代码片段可以使用。**


```groovy build.gradle

ext {
     guestName='Bowen'
}

task hello << {
     println guestName
     println "hello, $guestName"
}

```


```bash

$ gradle hello -q
Bowen
hello, Bowen

$ gradle properties | grep guestName
guestName: Bowen
$ gradle properties | grep ext
ext: org.gradle.api.internal.plugins.DefaultExtraPropertiesExtension@10ef5fa0

```

从上述可以看到ext对象其实是DefaultExtraPropertiesExtension对象的一个实例。

--------------------------

**在命令行中通过`-D`或者`-P`给Gradle实时创建属性。**
`-D`属性会被传送给启动Gradle的jvm，作为一个系统属性被jvm使用。

```groovy build.gradle

task hello << {
     println System.properties['guestName']
}

```
```bash

$ gradle hello -DguestName='Bowen' -q
Bowen

```


`-P`属性则会被直接加载到Gradle领域对象上。

```groovy build.gradle

task hello << {
      println "hello, $guestName"
}

```
```bash

$ gradle hello -PguestName='Bowen' -q
hello, Bowen

```

-------------------------

**在Gradle配置文件中创建系统属性。刚讲过在gradle.properties文件可以创建属性，同时我们也可以创建系统属性。如果有`systemProp.`前缀的属性会被识别为系统属性。**


```xml gradle.properties

systemProp.guestName = 'Bowen' 

```
```groovy build.gradle

task hello << {
      println "hello, " + System.properties['guestName']
}

```


```bash

$ gradle hello -q
hello, Bowen

```

-------------------------------------

**将特殊前缀的系统属性或环境变量自动加入到Gradle领域对象中。**

如果有环境变量以`ORG_GRADLE_PROJECT.`为前缀，那么该变量会被自动添加到Gradle领域对象中。同样，如果有系统属性以`org.gradle.project.`为前缀，那么也会被自动加入到Gradl领域对象中。这一特性的目的之一是为了隐藏一些敏感的信息。比如在执行Gradle脚本时需要传入密码信息，如果以`-P`的方式传送会被别人看到。而把该属性保存为环境变量，只有系统管理员才有权访问和修改。在运行Gralde的时候该环境变量会被自动加入到Gradle对象中被使用，隔离了明暗数据，又不行影响其他用户使用。（其他用户可以通过`-P`方式是设置该属性）。


```groovy build.gradle

task hello << {
      println "hello, " + guestName 
}

```


```bash

$ gradle hello -Dorg.gradle.project.guestName=Bowen -q
hello, Bowen

$ export ORG_GRADLE_PROJECT_guestName=Bob
$ gradle hello -q
hello, Bob

```













