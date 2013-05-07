---
layout: post
title: 将AngularJS的单元测试和端到端测试集成到gradle构建脚本中
date: 2013-05-07 15:55
comments: true
categories: [CI]
tags: [gradle, AngularJS]
---


我目前工作的一个项目后端使用java和spring建立了一个restful service,前端使用[AngularJS]来渲染页面，提供用户接口。在前端的[AngularJS]项目中，我们使用[Jasmine]来写单元测试，使用[AngularJS]自带的Angular_scenario来写端到端测试。运行这些测试则使用的是[Karma]。

虽然使用[Karma]在命令行下可以很方便的运行所有的测试，但是我们想将这些集成到[gradle]的构建脚本中，从而将[AngularJS]的所有测试加入到CI的构建中。同时为了保证运行测试的效率，我们决定使用[PhantomJS]作为运行测试的浏览器环境。

<!-- more -->

## 环境搭建

* **安装[nodeJS]。** 直接去官网<http://nodejs.org/ >下载最新的安装包进行安装。

* **安装[Karma]。** 可以使用nodeJS提供的npm(node package manager)来安装。

```bash
$ npm install -g karma

```

如果想安装最新的开发者版本，则运行：

```bash
$ npm install -g karma@canary
```

* **安装[PhantomJS]。** 

方式一：使用npm来安装:

```bash

$ npm install -g phantomjs

```

方式二：从官网上下载最新的安装包自行安装。地址是<http://phantomjs.org/> 。

不过为了方便其它人的使用，我将[PhantomJS]的文件直接放置到了项目的codebase中，并加入了svn管理。这样当setup一个新的工作电脑时就不需要安装它了，直接checkout项目代码就行。最大的原因是当[Karma]运行测试时会根据环境变量寻找[PhantomJS]的执行文件，将[PhantomJS]的执行文件放置在统一的地方方便管理，减少环境变量依赖。

## 配置[Karma]运行测试的配置文件

方式一：在项目根目录下运行`Karma init`,根据提示一步步创建配置文件。

方式二：如果对[Karma]的配置文件较为熟悉的话，可以自行创建一个。

以下是我为unit test创建的配置文件。

```JavaScript

// Sample Karma configuration file, that contain pretty much all the available options
// It's used for running client tests on Travis (http://travis-ci.org/#!/karma-runner/karma)
// Most of the options can be overriden by cli arguments (see karma --help)
//
// For all available config options and default values, see:
// https://github.com/karma-runner/karma/blob/stable/lib/config.js#L54


// base path, that will be used to resolve files and exclude
basePath = '';

frameworks = ['jasmine'];

// list of files / patterns to load in the browser
files = [
    'spec/*.spec.js'
];

// list of files to exclude
exclude = [];

// web server port
// CLI --port 9876
port = 9876;

// cli runner port
// CLI --runner-port 9100
runnerPort = 9100;

// enable / disable colors in the output (reporters and logs)
// CLI --colors --no-colors
colors = true;

// level of logging
// possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
// CLI --log-level debug
logLevel = LOG_INFO;

// enable / disable watching file and executing tests whenever any file changes
// CLI --auto-watch --no-auto-watch
autoWatch = false;

// Start these browsers, currently available:
// - Chrome
// - ChromeCanary
// - Firefox
// - Opera
// - Safari (only Mac)
// - PhantomJS
// - IE (only Windows)
// CLI --browsers Chrome,Firefox,Safari
browsers = ['PhantomJS'];

// If browser does not capture in given timeout [ms], kill it
// CLI --capture-timeout 5000
captureTimeout = 10000;

// Auto run tests on start (when browsers are captured) and exit
// CLI --single-run --no-single-run
singleRun = true;

// report which specs are slower than 500ms
// CLI --report-slower-than 500
reportSlowerThan = 500;

// compile coffee scripts
preprocessors = {
    '**/*.coffee': 'coffee'
};

plugins = [
    'karma-jasmine',
    'karma-chrome-launcher',
    'karma-firefox-launcher',
    'karma-phantomjs-launcher',
    'karma-junit-reporter'
]

```

由于需要在CI中运行测试，所以应当将autoWatch设置为false,将singleRun设置为true。这样[Karma]只会运行一遍测试。

由于我们将[PhantomJS]放置在工程目录下，为了让[Karma]能找到[PhantomJS]的执行文件，需要设置环境变量PHANTOMJS_BIN。在Karma.conf.js中加入如下代码:

```javaScript

process.env.PHANTOMJS = require('path').resolve(__dirname, 'tools/PhantomJS/phantomjs.exe';

```

如果Karma运行测试时找不到浏览器的执行文件，会报一个错误。

```bash

INFO [karma]: Karma v0.9.2 server started at http://localhost:9876/
INFO [launcher]: Starting browser PhantomJS
ERROR [karma]: { [Error: spawn ENOENT] code: 'ENOENT', errno: 'ENOENT', syscall: 'spawn' }
Error: spawn ENOENT
    at errnoException (child_process.js:977:11)
    at Process.ChildProcess._handle.onexit (child_process.js:768:34)

```

当时我花了好长时间来寻找原因，最后使用`karma start karma.conf.js --log-level=debug`来查看运行日志。

```bash

INFO [launcher]: Starting browser PhantomJS
DEBUG [launcher]: Creating temp dir at C:\Users\bowen\AppData\Local\2\karma-28747846
DEBUG [launcher]: C:\Program Files\PhantomJS\phamtomjs.exe  C:\Users\bowen\AppData\Local\2\karma-28747846capture.js
INFO [karma]: To run via this server, use "karma run --runner-port 9101"
ERROR [karma]: { [Error: spawn ENOENT] code: 'ENOENT', errno: 'ENOENT', syscall: 'spawn' }
Error: spawn ENOENT

```

通过DEBUG的log我发现`C:\Program Files\PhantomJS\phamtomjs.exe`下并未有该文件，最后使用上述的方法来设置[PhantomJS]的环境变量。（奇怪的是我已经在PowerShell里设置了该环境变量，并且Karma命令行也是在PowerShell运行的，但是[nodeJS]并未获取正确的环境变量值）。

## 在build.gradle中加入运行Karma的task

由于我们的开发机以及CI服务器都是Windows环境，所以需要调用CMD来执行[Karma]命令。

配置如下：

```java

task jsUnit(type: Exec, description: 'JS unit tests') {
     workingDir './src/test/scripts'
     commandLine 'cmd', '/c', 'karma start karma.conf.js'
}


task e2eTest(type: Exec, description: ' e2e tests') {
     workingDir './src/test/scripts'
     commandLine 'cmd', '/c', 'karma start karma-e2e.conf.js'
}

```

注意运行端到端测试前要将restful服务器setup起来。

当时在Windows上配置[Karma]花了很多功夫，使用Firefox浏览器发现会同时打开3个tab页，并且将singRun改为true不能运行成功，使用Chrome浏览器则测试运行完毕后浏览器无法关闭，使用[PhantomJS]又由于环境变量的问题花了一些时间来找原因。但是在我自己的苹果笔记本上各个浏览器都工作良好，真想说Windows是个奇葩。

对于普通用户来说可能Windows系统更适合他们，但是对于程序员来说MAC系统真的非常棒，反应迅速，配置简单，能让你的开发效率提升一个档次。


[Karma]: http://karma-runner.github.io/ 

[nodeJS]: http://nodejs.org/
 
[gradle]: http://www.gradle.org/ 

[PhantomJS]: http://phantomjs.org/ 

[AngularJS]: http://angularjs.org/ 

[Jasmine]: http://pivotal.github.io/jasmine/ 