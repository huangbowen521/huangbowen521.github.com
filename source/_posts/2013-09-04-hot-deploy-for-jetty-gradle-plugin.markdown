---
layout: post
title: Gradle里配置jetty实现静态资源的热部署
date: 2013-09-04 22:32
comments: true
categories: Gradle
tags: [Gradle]
---

通过Gradle我们可以很方便的使用内置jetty启动我们的web程序，在本地进行调试。但是在使用的过程中，我发现了几个问题，导致本地调试的效率大受影响。

<!-- more -->

1. 如果使用`gradle jettyRun`启动jetty服务器后，项目里的静态资源（jsp，html，JavaScript文件）都被锁定了，导致无法实时修改这些静态资源。

2. 既然无法实时修改这些静态资源，那意味着我们做一个很小的改动都需要先停止jetty server，然后修改，再重新启动jetty server，这样来回浪费很多时间，尤其是涉及前台页面改动时，每调整一个参数都需要重启jetty。

由于我以前使用过Maven，在Maven里jetty是可以显示热部署的。也就是说如果有静态文件被改动，那么jetty可以实时load并展现。那么在Gradle里面实现这个应该也不是难事，花了一些时间搞定了。

* **首先要解决文件被锁定的问题。**

文件被锁定是由于在使用windows系统时，jetty默认在内存中映射了这些文件，而windows会锁定内存映射的文件。解决的办法就是修改jetty的配置，让其在启动server时将useFileMappedBuffer标志位设置为false。

设置方法有两种，一种是修改webdefault.xml文件中的useFileMappdBuffer标志位。webdefault.xml文件是jetty启动服务的配置文件，其先于项目中的WEB-INF/web.xml文件被加载。
jetty包中默认有这个文件，可以将其提取出来，保存在项目根目录下，并修改useFileMappedBuffer节点。

```xml

<param-name>useFileMappedBuffer</param-name> 
<param-value>false</param-value>

```

然后在build.gradle加入对此文件的引用。

```groovy

[jettyRun, jettyRunWar,jettyStop]*.with {    
	webDefaultXml = file("${rootDir}/webdefault.xml") 
}

```

第二种方法是修改项目中的`WEB-INF/web.xml`文件，在其中加入这个节点。

```xml

<servlet>
    <!-- Override init parameter to avoid nasty -->
    <!-- file locking issue on windows.         --> 
    <servlet-name>default</servlet-name> 
        <init-param>    
            <param-name>useFileMappedBuffer</param-name>  
            <param-value>false</param-value> 
        </init-param> 
</servlet>

```

* **解决jetty的hot deploy的问题。**

这个就比较简单了，Gradle的jetty插件有两个属性，一个是reload属性，需要设置为automatic。另一个属性是
scanIntervalSeconds，这是指定jetty扫描文件改变的时间间隔，默认为0，单位是秒。
在build.gradle中加入设置。

```groovy

jettyRun {    
	reload ="automatic"    
	scanIntervalSeconds = 1 
}

```

齐活。接下来运行`gradle jettyRun`，待服务启动起来以后，如果修改了静态资源，只需要按`Ctrl`+`R`刷新页面即可重新加载资源。








