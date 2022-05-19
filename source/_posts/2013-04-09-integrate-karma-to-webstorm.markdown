---
layout: post
title: Karma(原名Testacular)与WebStorm进行集成
date: 2013-04-09 01:59
comments: true
categories: 工具
tags: [Karma, Testacular, WebStorm]
---


[Karma]是一款运行JavaScript测试的工具。它支持大部分的JavaScript测试框架，并支持多浏览器跑测试、自动监听文件运行测试等功能，实在是JavaScript开发的必备测试利器。有了它，基本不用再一遍遍手动刷新页面来trigger测试了。它的原名是testacular，也不知道作者咋想的，突然之间把项目名称改了。

而[WebStorm]则号称是世界上最聪明的JavaScript的IDE。（事实证明，确实如此）。JavaScript code自动提示、浏览器实时同步更新、支持HTML5, [node.js], TypeScript, CoffeeScript, ECMAScript Harmony, LESS…秉承了JetBrains这个牛逼公司的一贯传统。

<!-- more -->

那么，如何将[Karma]集成到[WebStorm]中来那？ 很简单。

## 配置Karma Runner.

1. 菜单栏Run里面选`Edit Configurations…`项，在弹出的对话框中点击左上角的`+`按钮,选择`Node.js`。


2. 然后进行如下配置。


	{% img /images/run.png %}



	主要配置参数：

	* Name : 名称标示，自己随便起一个就成。
	* Path to Node: node.js的运行路径。在Terminal下运行`which node`可以看到。
	* Working Directory: 项目的目录。
	* Path to Node App JS File: Karma的安装目录，同样在Terminal下运行`which karma`可以得到。
	* Application Parameters： start karma.conf.js。第一个参数start是运行karma server。第二个参数是karma的配置文件。

3. 点击ok按钮。大功告成。

在[WebStorm]中运行我们定义的Karma Runner，就能实时的看到测试结果。它能自动监听文件修改。一有风吹草动就会重新运行测试，而且速度奇快。


{% img /images/running.png %}


## 配置Karma Debugger.

如果想使用[Karma]在IDE里面进行Debug，该怎么办？也简单，配置一个Remote Debugger就行。

1. 菜单栏Run里面选`Edit Configurations…`项，在弹出的对话框中点击左上角的`+`按钮,选择`JavaScript Debug`->`Remote`。


2. 在配置框中输入以下参数。


	{% img /images/debug.png %}


	主要参数设置：

	* Name: 名称标示符。

	* URL to open:  http://localhost:9876/debug.html。默认是这个，要根据你Karma server配置的真实地址而定。

	* Browser: 要运行的浏览器。

	* Remote URL； http://localhost:9876/base。

3. 点击确定，又搞定了。

## 如何进行Debug？

1. 在源代码中设置断点。

2. 在WebStorm中启动Karma server，就是运行我们定义的Karma Runner。

3. 在WebStorm中运行我们定义的Karma Debug。

注意第一次运行时WebStorm会提醒你在浏览器上安装相应的插件。


{% img /images/debugging.png %}


[Karma]: http://karma-runner.github.io/0.8/index.html
[WebStorm]:http://www.jetbrains.com/webstorm/
[node.js]:http://nodejs.org/
