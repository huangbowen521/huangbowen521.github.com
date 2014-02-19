---
layout: post
title: ActiveMQ第一弹:安装与运行
date: 2014-02-20 00:12
comments: true
categories: ActiveMQ
---

ActiveMQ使用java写的，所以天然跨平台，windows，各种类Unix系统都可运行，只需要下载对应的分发包即可。当前AciveMQ的最新版本是5.9.0。我目前在自己机子上安装的版本是5.8.0。

<!-- more -->

安装ActivceMQ需要先设置好系统环境。

1. 空间剩余磁盘大于60M。（这个肯定没问题）

2. 需要预装JDK，版本为1.6.x及其以上。（ActiveMQ就是用java写的，肯定要装java环境的嘛）

接下来就可以安装ActiveMQ了。

一种是直接下载分发包，地址是[http://activemq.apache.org/](http://activemq.apache.org/)。找到想要安装的版本后解压缩即可。

另一种是通过源代码安装，地址是[http://activemq.apache.org/download.html](http://activemq.apache.org/download.html)。该源代码是使用maven作为构建工具的，所以需要先安装maven，如何安装可参见[maven官网](http://maven.apache.org/)（MAC用户如果安装了homebrew的话，直接运行`brew install maven`即可）。    然后使用`mvn clean install -Dmaven.test.skip=true`来构建源代码。如果构建成功的话在target目录下可以看到生成的activemq-x.x-SNAPSHOT.zip文件，解压缩以后就可以使用了。

当然MAC用户的话安装就简单了，直接使用`brew install activemq`就行（不知道homebrew为何物的参见我写的文章：
[Homebrew- MAC上的包管理利器](http://www.huangbowen.net/blog/2013/07/01/homebrew-in-mac/)）。ActiveMQ会被默认安装到/usr/local/Cellar/activemq。

```bash

$:/usr/local/Cellar/activemq$ ls
5.7.0 5.8.0
$:/usr/local/Cellar/activemq$ cd 5.8.0
$:/usr/local/Cellar/activemq/5.8.0$ ls
INSTALL_RECEIPT.json NOTICE               bin
LICENSE              README.txt           libexec

```

HomeBrew会自动将activemq加入到系统路径中。

下表列出了与ActiveMQ有关的一些重要的环境变量。

* ACTIVEMQ_HOME: /usr/local/Cellar/activemq/5.8.0/libexec

* ACTIVEMQ_BASE: /usr/local/Cellar/activemq/5.8.0/libexec

* ACTIVEMQ_CONF: /usr/local/Cellar/activemq/5.8.0/libexec/conf

* ACTIVEMQ_DATA: /usr/local/Cellar/activemq/5.8.0/libexec/data

**注意一下所有命令有时基于ActiveMQ 5.8.0版本，不同版本命令稍有不同。**

先运行`activemq setup ~/.activemqrc`来指定activemq的环境配置文件。在这个文件中可以自定义activemq使用的JDK路径，jvm参数等信息。

```bash

$:/usr/local/Cellar/activemq/5.8.0$ activemq setup ~/.activemqrc
INFO: Loading '/Users/twer/.activemqrc'
INFO: Creating configuration file: /Users/twer/.activemqrc
INFO: It's recommend to limit access to '/Users/twer/.activemqrc' to the priviledged user
INFO: (recommended: chown 'twer':nogroup '/Users/twer/.activemqrc'; chmod 600 '/Users/twer/.activemqrc’) 

```

运行`activemq`可以显示activemq相应的配置信息及可用的命令。（注意低版本中此命令是启动ActiveMQ）

运行`activemq start`可以在一个独立进程中启动activemq。

```bash

$:/usr/local/Cellar/activemq/5.8.0$ activemq start
INFO: Loading '/Users/twer/.activemqrc'
INFO: Using java '/System/Library/Frameworks/JavaVM.framework/Home/bin/java'
INFO: Starting - inspect logfiles specified in logging.properties and log4j.properties to get details
INFO: pidfile created : '/usr/local/Cellar/activemq/5.8.0/libexec/data/activemq-bowen-huang.local.pid' (pid '50873') 

```

可以看到进程id是50873.

终止ActiveMQ的运行有两种方式。一种是使用`activemq stop`。

```bash

$:/usr/local/Cellar/activemq/5.8.0$ activemq stop
INFO: Loading '/Users/twer/.activemqrc'
INFO: Using java '/System/Library/Frameworks/JavaVM.framework/Home/bin/java'
INFO: Waiting at least 30 seconds for regular process termination of pid '50873' :
Java Runtime: Apple Inc. 1.6.0_65 /System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home
  Heap sizes: current=1035520k  free=1033420k  max=1035520k
    JVM args: -Xms1G -Xmx1G -Djava.util.logging.config.file=logging.properties -Dactivemq.classpath=/usr/local/Cellar/activemq/5.8.0/libexec/conf; -Dactivemq.home=/usr/local/Cellar/activemq/5.8.0/libexec -Dactivemq.base=/usr/local/Cellar/activemq/5.8.0/libexec -Dactivemq.conf=/usr/local/Cellar/activemq/5.8.0/libexec/conf -Dactivemq.data=/usr/local/Cellar/activemq/5.8.0/libexec/data
Extensions classpath:
  [/usr/local/Cellar/activemq/5.8.0/libexec/lib,/usr/local/Cellar/activemq/5.8.0/libexec/lib/camel,/usr/local/Cellar/activemq/5.8.0/libexec/lib/optional,/usr/local/Cellar/activemq/5.8.0/libexec/lib/web,/usr/local/Cellar/activemq/5.8.0/libexec/lib/extra]
ACTIVEMQ_HOME: /usr/local/Cellar/activemq/5.8.0/libexec
ACTIVEMQ_BASE: /usr/local/Cellar/activemq/5.8.0/libexec
ACTIVEMQ_CONF: /usr/local/Cellar/activemq/5.8.0/libexec/conf
ACTIVEMQ_DATA: /usr/local/Cellar/activemq/5.8.0/libexec/data
Connecting to pid: 50873
.Stopping broker: localhost
… FINISHED

```

另一种则是暴力的杀死进程,即`kill 50873`。

运行`activemq console`则会在当前console中启动activemq。这种好处是不用多开一个进程，而且可以直接从console中看到log。关闭activemq也很简单，直接按`ctrl`+`C`终止终端运行。 

ActiveMQ的默认端口是61616，可以检测这端口来判断ActiveMQ是否启动成功。

```bash

$:/usr/local/Cellar/activemq/5.8.0$ netstat -an|grep 61616
tcp46      0      0  *.61616                *.*                    LISTEN

```

也可以访问web终端[http://localhost:8161/admin](http://localhost:8161/admin)来查看和管理ActiveMQ。（默认用户名密码是admin/admin，你也可以修改配置，其在ActiveMQ安装目录下的libexec/conf/jetty-real.properties文件中）。

ActiveMQ支持xml文件格式对其进行配置。其实我们运行`activemq start`时，ActiveMQ就是默认使用了其安装目录下的libexec/conf/activemq.xml文件。 

```bash

$:/usr/local/Cellar/activemq/5.8.0/libexec/conf$ ls
activemq-command.xml                 broker.ks
activemq-demo.xml                    broker.ts
activemq-dynamic-network-broker1.xml camel.xml
activemq-dynamic-network-broker2.xml client.ks
activemq-jdbc.xml                    client.ts
activemq-scalability.xml             credentials-enc.properties
activemq-security.xml                credentials.properties
activemq-specjms.xml                 jetty-demo.xml
activemq-static-network-broker1.xml  jetty-realm.properties
activemq-static-network-broker2.xml  jetty.xml
activemq-stomp.xml                   jmx.access
activemq-throughput.xml              jmx.password
activemq.xml                         log4j.properties
broker-localhost.cert                logging.properties 

```

我们当然可以使用自定义的配置文件，比如我们改用activemq-demo.xml。

```bash

$:/usr/local/Cellar/activemq/5.8.0/libexec$ activemq start xbean:./conf/activemq-demo.xml
INFO: Loading '/Users/twer/.activemqrc'
INFO: Using java '/System/Library/Frameworks/JavaVM.framework/Home/bin/java'
INFO: Starting - inspect logfiles specified in logging.properties and log4j.properties to get details
INFO: pidfile created : '/usr/local/Cellar/activemq/5.8.0/libexec/data/activemq-bowen-huang.local.pid' (pid '51375’) 

```

ActiveMQ在5.8.0版本及之后在安装包中包含了一些demo来演示对ActiveMQ的使用。使用方式很简单，首先采用activemq-demo.xml配置文件来启动ActiveMQ，然后访问[http://localhost:8161/demo/](http://localhost:8161/demo/)尽情探索把。

这些demo的源码都在ActiveMQ安装目录下的libexec目录中，里面有个`user-guide.html`，可以用浏览器直接打开，它详细描述了该如何使用这些demo。 
 

