---
layout: post
title: Gradle命令行黑魔法
date: 2013-09-01 22:25
comments: true
categories: Gradle
tags: [Gradle]
---

{% img /images/building.jpg %}

毫无疑问，现在Gradle已经成为java世界最火的构建工具，风头已经盖过了冗余的ant，落后的maven。Gradle是以Groovy语言编写的一套构建脚本的DSL，由于Groovy语法的优雅，所以导致Gradle天生就有简洁、可读性强、灵活等特性。

Gradle的命令行功能也非常强大。本人从maven转到Gradle，深深被gradle强大的命令行功能折服。通过命令行来实现Gradle的各种特性，就像魔法师在表演魔法一样。

<!-- more -->

* **日志输出。** Gradle中的日志有6个层级。从高到低分别是 ERROR（错误信息）、QUIET（重要信息）、WARNGING（警告信息）、LIFECYCLE（进程信息）、INFO（一般信息）、DEBUG（调试信息）。在执行gradle task时可以适时的调整信息输出等级，以便更方便的观看执行结果。

`-q`(或`--quiet`)是启用重要信息级别，该级别下只会输出自己在命令行下打印的信息及错误信息。

`-i`(或`--info`)则会输出除debug以外的所有信息。

`-d`（或`--debug`)会输出所有日志信息。  

比如一个build.gradle有这样一个task。

```groovy

task hello << {
     println 'hello world!'
}

```

加入`-q`与不加`-q`的输出结果不同。

```bash

$ gradle hello
:hello
hello world!

BUILD SUCCESSFUL

Total time: 3.546 secs
$ gradle -q hello
hello world!

```

* **堆栈跟踪。**如果执行gradle task失败时，如果想得到更详细的错误信息，那么就可以使用`-s`(或`--stacktrace`)来输出详细的错误堆栈。你还可以使用`-S`(或`--full-stacktrace`)来输出全部堆栈信息，不过一般不推荐这样做，因为gradle是基于groovy语言，而groovy作为一门动态语言可能会输出与你的错误代码毫不相关的信息。

* **跳过指定的测试。**如果你在执行build的时候想跳过test task，那么可以使用`-x`命令。

```bash

$ gradle build -x test
:compileJava UP-TO-DATE
:processResources UP-TO-DATE
:classes UP-TO-DATE
:jar UP-TO-DATE
:assemble UP-TO-DATE
:check
:build

BUILD SUCCESSFUL

Total time: 3.529 secs

```

* **继续执行task而忽略前面失败的task。**默认情况下，如果有某个task失败，后续的task就不会继续执行。但是有时候我们想运行所有的task来一次性得到所有的构建错误，那么我们可以使用`--continue`命令。使用`--continue`命令后即使遇到某些task失败也不会停止后续task的执行。但是需要注意的是如果某个task失败了，那么依赖于这个task的其他task依旧不会执行，因为这会带来不安全的因素。

* **调用task时使用短名或缩写。**如果一个task的名称过长，那么调用时可以只输入部分名称即可调用，无需输入全名。

```groovy

task helloWorld << {
     println 'hello world!'
}

```

比如调用helloWorld可以通过全名调用、前缀调用或首字母调用。

```bash
$ gradle -q helloWorld
hello world!
$ gradle -q hell
hello world!
$ gradle -q hW
hello world!
```

* **使用指定的gradle文件调用task。**默认情况下，如果你调用gradle task，那么首先会寻找当前目录下的build.gradle文件,以及根据settings.gradle中的配置寻找子项目的build.gradle。但是有时候我们想指定使用某个gradle文件，那么可以使用`-b`命令。
比如当前目录有个子目录subproject1,里面有个叫hello.gradle。

```groovy subproject1/hello.gradle

task helloWorld << {
     println 'hello world!'
}

```

那么在当前目录可以使用以下命令调用这个task。

```bash
$ gradle -b subproject1/hello.gradle  helloWorld
:helloWorld
hello world!

BUILD SUCCESSFUL

Total time: 3.752 secs

```

* **使用指定的项目目录调用task。**前面已经说过，执行gradle的task默认会在当前目录寻找build.gradle及settings.gradle文件。如果我们想在任何地方执行某个项目的task，那么可以使用`-p`来指定使用的项目。

```groovy

gradle -q -p learnGradle helloWorld

```

这条命令是调用learnGradle这个项目下的helloWorld task。

* **显示task之间的依赖关系。**众所周知，使用`gradle tasks`可以列出当前所有可被使用的task，但是并没有显示task之间的依赖关系。我们可以加上`--all`来显示
task的依赖关系。

```bash

$ gradle tasks --all
………………

Other tasks
-----------
task0
    task1
    task2
    task3

…………

```
	从上面可以看出task0依赖task1、task2及task3。

* **查看指定阶段的依赖关系。**使用`gradle dependencies` 可以查看项目中包的依赖关系。不过是列出了所有阶段的依赖，如果项目中依赖复杂的话看起来有点头痛。那么可以使用`--configuration`来查看指定阶段的依赖情况。

```groovy

$ gradle -q dependencies

------------------------------------------------------------
Root project
------------------------------------------------------------

archives - Configuration for archive artifacts.
No dependencies

compile - Compile classpath for source set 'main'.
No dependencies

default - Configuration for default artifacts.
No dependencies

runtime - Runtime classpath for source set 'main'.
No dependencies

testCompile - Compile classpath for source set 'test'.
\--- junit:junit:4.11
     \--- org.hamcrest:hamcrest-core:1.3

testRuntime - Runtime classpath for source set 'test'.
\--- junit:junit:4.11
     \--- org.hamcrest:hamcrest-core:1.3
```

使用`gradle -q dependencies --configuration testCompile`可以只查看testComiple的依赖。

```
$ gradle -q dependencies --configuration testCompile

------------------------------------------------------------
Root project
------------------------------------------------------------

testCompile - Compile classpath for source set 'test'.
\--- junit:junit:4.11
     \--- org.hamcrest:hamcrest-core:1.3

```

* **查看指定dependency的依赖情况。**
假如我想查看项目中有没有引入junit，那些阶段引入了junit，那么可以使用`dependecyInsight`来查看。

```bash

$ gradle dependencyInsight --dependency junit --configuration testCompile
:dependencyInsight
junit:junit:4.11
\--- testCompile

```

注意`dependencyInsight`默认只会查看compile阶段的依赖，如果要查看其他阶段可以使用`--configuration`来指定。

* **使用`--profile`命令行可以产生build运行时间的报告。**该报告存储在build/report/profile目录，名称为build运行的时间。

```bash
$ gradle build --profile
:compileJava UP-TO-DATE
:processResources UP-TO-DATE
:classes UP-TO-DATE
:jar UP-TO-DATE
:assemble UP-TO-DATE
:compileTestJava UP-TO-DATE
:processTestResources UP-TO-DATE
:testClasses UP-TO-DATE
:test UP-TO-DATE
:check UP-TO-DATE
:build UP-TO-DATE

BUILD SUCCESSFUL

Total time: 3.726 secs

```

然后在build/report/profile目录下可以看到build的report。

{% img /images/gradle_profile.png 600 %}

这个报表非常有用，尤其是在在缩短build时间时可以快速定位那些耗时长的task。


* **试运行build。**如果你想知道某个task执行时那些task会被一起执行，但是你又不想真正的执行这些task，可以使用`-m`来试运行。

```bash

$ gradle -m build
:compileJava SKIPPED
:processResources SKIPPED
:classes SKIPPED
:jar SKIPPED
:assemble SKIPPED
:compileTestJava SKIPPED
:processTestResources SKIPPED
:testClasses SKIPPED
:test SKIPPED
:check SKIPPED
:build SKIPPED

BUILD SUCCESSFUL

Total time: 3.53 secs

```

这样我们可以一目了然的看到那些task被执行了，又不需要花太多的时间。

* **Gradle的图形界面。**

其实Gradle自带一个图形界面来让习惯gui操作的人来操作Gradle。打开方式很简单。

```bash

$ gradle --gui

```

这样就会弹出一个gui界面。

{% img /images/gradle_gui.png 600 %}

通过这个gui界面可以很方面的执行gradle的各种命令，还可以将常用的命令保存为favorites。该gui的配置信息默认被存储在当前项目的gradle-app.setting文件中。

注意使用`gradle --gui`会阻塞当前终端，可以使用`gradle --gui&`来实现后台运行。

* **重新编译Gradle脚本。**第一次运行Gradle命令，会在项目更目录下生成一个.gradle目录来存放编译后的脚本。只有当构建脚本发生修改时采用重新编译。我们可以使用`--recompile-scripts`来强行重新编译。 
