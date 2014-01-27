---
layout: post
title: 记一次在StackOverFlow上问问题的经历
date: 2014-01-21 12:47
comments: true
categories: 
---

最近一直在做测试方面的事情，被测的一些功能需要连接到FTP服务器上。而我在做本地测试时为了方便，就使用java写了一个简单的ftp服务器，可以在命令行下直接启动运行。

<!-- more -->

当时在main函数里是这样写的。

```java

public class App {

    public static void main(String[] args) {
        FtpServer ftpServer = new FtpServer();
        ftpServer.start();
    }
} 

```

然后在命令行运行`java -jar ftpserver.jar`就可以启动这个FTP服务。一切都很完美。当我想关闭FTP服务时，直接按了`Ctrl` + `C`来终止了这个JVM实例。但是我发现ftpserver.jar这个文件删不了了,原因是虽然我终止了该JVM实例，但是FTP服务器并没有被正确的退出。

那么如何实现在按`Ctrl`+`C`终止该JVM实例时，能够让程序调用FtpServer中的stop方法来关闭FTP服务？我想在Google上寻找答案，但是连续换了几个关键词都没找到解决方案。

这个时候我都有点差点放弃了，心想反正也不是一个很严重的问题。后来想到不如在StackOverFlow上问一下吧。说实话虽然我经常上StackOverFlow，但是很少在上面问问题。

我在StackOverFlow上发布了这个问题，链接如下。
[http://stackoverflow.com/questions/21108059/stop-the-process-when-press-command-c-in-terminal](http://stackoverflow.com/questions/21108059/stop-the-process-when-press-command-c-in-terminal)

{% img /images/ftpquestion.png %}

过了不到20分钟，就收到了一个回答。

{% img /images/ftpanswer.png %}


从上面可以看出，其实我这个问题之前已经有人问过了，并且收到了满意的答案。我根据回答中提供的链接，很快实现了方法。

```java

public static void main(String[] args) {
        final FtpServer ftpServer = new FtpServer();

        Runtime.getRuntime().addShutdownHook(new Thread() {
            @Override
            public void run() {
                ftpServer.stop();
            }
        });

        ftpServer.start();
    } 

```

在oracle的官方文档中有对[addShutdownHook](http://docs.oracle.com/javase/1.5.0/docs/api/java/lang/Runtime.html#addShutdownHook%28java.lang.Thread%29 )方法的详细解释。

通过文档可以看出JVM在两种事件下会响应shutdown：

1. 程序正常退出，比如最后的非后台线程退出或System.exit方法被调用。

2. 用户终止了JVM，比如按下Ctrl+C，或者登出或关闭系统。

某些情况下JVM是不会响应shutdown的，比如直接用kill命令杀死进程。JVM在shutdown时，会自动触发注册的hook线程，并以并行的方式来运行，JVM并不保证这些hook的调用顺序。

通过这个小事件给了我两个启示：

1. 当碰到技术困难时，不要轻言放弃，努力找出解决方案。即使找不到完美的解决方案，也要想一些替代方案。

2. 在StackOverFlow上问问题时不要太着急，先查找下有没有类似的已经解决的问题，这样可以节省时间。
