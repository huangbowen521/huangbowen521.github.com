---
layout: post
title: Gradle与Gatling脚本集成
date: 2014-07-23 16:12:23 +1000
comments: true
categories: Gatling
tags: [Gradle, Gatling]
---

Gatling作为次时代的性能测试工具，由于其API简洁明了、性能出众，越来越受欢迎。但是运行Gatling脚本却有诸多不便，其提供的默认方式不是很方便。考虑到Gatling脚本本质上是Scala类，运行的时候还是使用的是java虚拟机，我们可以将其脚本的运行与Gradle结合起来。这样子就可以通过Gradle来运行Gatling脚本了。

<!-- more -->

废话少说，接下来就讲述下如何来进行配置。

创建一个标准的maven结构的工程目录，如下图所示。


{% img /images/gradle-gatling.png 600 %}

conf目录存放Gatling的基本配置文件。
Gatling的脚本文件存放在src/test/scala/simulations包里面。可以自行在此包下对脚本文件再分类。


在build.gradle文件中引入scala插件。

```groovy

apply plugin: 'scala'

```

然后引入有gatling库的maven repo。

```groovy

repositories {
    mavenCentral ()
    maven {
        url 'http://repository.excilys.com/content/groups/public'
    }
}

```

再加入scala和gatling的依赖项。

```groovy

dependencies {
    compile 'org.scala-lang:scala-library:2.10.1'
    testCompile 'io.gatling.highcharts:gatling-charts-highcharts:2.0.0-M3a'
}

```

把conf文件夹作为test的source文件。

```groovy

sourceSets {
    test {
        resources {
            srcDir 'conf'
        }
    }
}

```

创建一个名为gatling的task，目的是运行所有的gatling脚本。


```groovy

task gatling (dependsOn: 'compileTestScala') << {

    logger.lifecycle (" ---- Executing all Gatling scenarios from: ${sourceSets.test.output.classesDir} ----")

    sourceSets.test.output.classesDir.eachFileRecurse { file ->
        if (file.isFile ()) {

            def gatlingScenarioClass = (file.getPath () - (sourceSets.test.output.classesDir.getPath () + File.separator) - '.class')
                    .replace (File.separator, '.')

            javaexec {
                main = 'io.gatling.app.Gatling'
                classpath = sourceSets.test.output + sourceSets.test.runtimeClasspath
                args '-sbf',
                        sourceSets.test.output.classesDir,
                        '-s',
                        gatlingScenarioClass,
                        '-rf',
                        'build/reports/gatling'
            }
        }

    }

    logger.lifecycle (" ---- Done executing all Gatling scenarios ----")
}

```

这是借助于Gatling的command line运行功能来实现的。具体参数指定官网上有，这里贴出原文。

> Command Line Options #
Gatling can be started with several options listed below:

   * -nr (--no-reports): Runs simulation but does not generate reports
   * -ro <folderName> (--reports-only <folderName>): Generates the reports for the simulation log file located in <gatling_home>/results/<folderName>
   * -df <folderAbsolutePath> (--data-folder <folderAbsolutePath>): Uses <folderAbsolutePath> as the folder where feeders are stored
   * -rf <folderAbsolutePath> (--results-folder <folderAbsolutePath>): Uses <folderAbsolutePath> as the folder where results are stored
   * -bf <folderAbsolutePath> (--request-bodies-folder <folderAbsolutePath>): Uses <folderAbsolutePath> as the folder where request bodies are stored
   * -sf <folderAbsolutePath> (--simulations-folder <folderAbsolutePath>): Uses <folderAbsolutePath> as the folder where simulations are stored
   * -sbf <folderAbsolutePath> (--simulations-binaries-folder <folderAbsolutePath>): Uses <folderAbsolutePath> as the folder where simulation binaries are stored
   * -s <className> (--simulation <className>): Uses <className> as the name of the simulation to be run
   * -sd <text> (--simulation-description <text>): Uses <text> as simulation description



我在github上创建了一个示例项目，请参见[https://github.com/huangbowen521/gatling-gradle](https://github.com/huangbowen521/gatling-gradle)
