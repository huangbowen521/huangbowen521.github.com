---
layout: post
title: 在Grunt task中集成Protractor
date: 2015-06-01 12:18:57 +0800
comments: true
categories: Grunt
---

Protractor是专为AngularJS应用程序编写的UI自动化测试框架。前端构建有很多构建工具，比如Grunt、Gulp等。一般我们会把这些构建工具作为集成集成的脚本执行工具。所以如果把Protractor的执行也集成进去，则可以达到自动验证UI功能的效果。

<!-- more -->

本文将介绍如何将Protractor命令集成到Grunt task中。

首先需要为Grunt安装一个插件，`grunt-protractor-runner`。这个插件会帮你在Grunt中运行Protractor。

```bash

npm install grunt-protractor-runner —save-dev

```

在Gruntfile.js文件中引入该插件(如果你没有package.json文件)。

```
grunt.loadNpmTasks('grunt-protractor-runner');

```

接着在Gruntfile.js中配置protractor运行参数。需要指定protractor的配置文件路径。

```

protractor: {
	e2e: {
 		options: {
    	keepAlive: true,
    	configFile: "protractor.conf.js"
  		}
	}
}

```

然后在Gruntfile.js中新注册一个名为`e2e`的task，用于运行Protractor。

```

grunt.registerTask(‘e2e’,’run e2e tests’, function() {
	grunt.task.run([
	     'connect:test',
	     'protractor:e2e'
	]);

});

```

此外为了不忘记自动更新webdriver的版本，可以在package.json中加入以下代码块：

```

"scripts": {
  "install": "node node_modules/protractor/bin/webdriver-manager update"
}

```

这样每次运行`npm install`时会自动更新webdriver版本。








