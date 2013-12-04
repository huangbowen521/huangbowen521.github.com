---
layout: post
title: Gradle中使用idea插件的一些实践
date: 2013-12-04 22:19
comments: true
categories: Gradle
tags: [Gradle] 
---

如果你的项目使用了Gradle作为构建工具，那么你一定要使用Gradle来自动生成IDE的项目文件，无需再手动的将源代码导入到你的IDE中去了。

<!-- more -->

如果你使用的是eclipse，可以在build.gradle中加入这么一行.

```groovy

apply plugin: 'eclipse'

```

然后在命令行中输入`gradle eclipse`就可以生成eclipse的项目文件，直接使用eclipse打开生成的项目文件即可。

当然作为Java程序开发者，最好使的IDE还是Intellij,昨天听闻Intellij 13已经发布了，增加了不少新功能，看来又要掏腰包了。如果要让Gradle自动生成Intellij的项目文件，需要使用idea插件。

```groovy

apply plugin: 'idea'

```

命令行下输入`gradle idea`，就会生成Intellij的项目文件，真是省时省力。如果在已经存在Intellij的项目文件情况下，想根据build.gradle中的配置来更新项目文件，可以输入`gradle cleanIdea idea`。`cleanIdea`可以清除已有的Intellij项目文件。

Intellij项目文件主要有三种类型。

* .ipr Intellij工程文件

* .iml Intellij 模块文件

* .iws Intellij 工作区文件


如果只简单的使用`gradle idea`生成Intellij的工程文件，其实在使用Intellij打开项目以后，我们还要做一些手工配置，比如指定JDK的版本，指定源代码管理工具等。Gradle的idea命令本质上就是生成这三个xml文件,所以Gradle提供了生成文件时的hook(钩子)，让我们可以方便的做定制化，实现最大程度的自动化。这就需要自定义idea这个任务了。

```groovy

idea.project {
     jdkName = '1.6'
     languageLevel = '1.6' 
}

```

这个用来配置项目的jdk及languageLevel。

如果要指定源代码管理工具类型，就需要调用hook修改生成的ipr文件。

```groovy

idea.project {

    ipr {
        withXml { provider ->
            provider.node.component.find { it.@name == 'VcsDirectoryMappings' }.mapping.@vcs = 'Git'
        }
    }

}

```
通过这种方式可以最大限度的实现对Intellij项目文件的定制化。











