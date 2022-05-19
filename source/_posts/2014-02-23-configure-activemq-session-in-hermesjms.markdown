---
layout: post
title: ActiveMQ第四弹:在HermesJMS中创建ActiveMQ session
date: 2014-02-23 15:03
comments: true
categories: ActiveMQ
tags: [ActiveMQ, HermesJMS] 
---

Hermes JMS是一个开源免费的跨平台的JMS消息监听工具。它可以很方便和各种JMS框架集成和交互，可以用来监听、发送、接收、修改、存储消息等。这篇文章将讲解HermesJMS如何集成ActiveMQ并与其交互。

<!-- more -->

ActiveMQ在通过命令行运行时会自动启动一个Web终端，默认地址是[http://localhost:8161/admin](http://localhost:8161/admin)，默认用户名/密码为admin/admin。通过这个web终端可以监控和操作ActiveMQ。但是这个Web终端有两个缺陷，第一是功能较弱，有些需求不能满足；第二是只有通过命令行启动ActiveMQ才会启动这个Web终端，如果是使用内置的broker，则无法使用该Web终端。而HermesJMS恰好弥补了这两个缺陷。

要想使用HermesJMS，首先要下载它。HermesJMS的官方网站是[http://www.hermesjms.com/confluence/display/HJMS/Home](http://www.hermesjms.com/confluence/display/HJMS/Home)。其源码放置在sourceforge上。目前最新版本是1.14，已经两年多没推出新版本了。下载地址:[http://sourceforge.net/projects/hermesjms/files/hermesjms/1.14/](http://sourceforge.net/projects/hermesjms/files/hermesjms/1.14/)。MAC系统的要下载dmg文件，其余系统可下载jar文件。

下载完成以后，要配置ActiveMQ到provider去。打开Hermes，点击`create new session`按钮，然后在界面下方选中Providers tab，添加对ActiveMQ的配置。我们以ActiveMQ5.8.0版本为例。首先创建一个名为ActiveMQ5.8.0的group，然后向其添加两个jar包:activemq-all-5.8.0.jar及geronimo-j2ee-management_1.1_spec_1.0.1.jar。这两个jar包都可以在ActiveMQ安装目录下找到。

{% img /images/setupProvider.png 800 %}

然后就可以创建一个ActiveMQ的Session了。点击Sessions tab，输入以下配置信息。

{% img /images/setupSession.png 800 %}

设置Plugin为ActiveMQ是为了能够自动检测当前Provider中的Queue和Topic信息。

然后启动一个ActiveMQ broker。

```bash

$:/usr/local/Cellar/activemq/5.8.0/libexec$ activemq console xbean:./conf/activemq-demo.xml 

```

这样就可以通过hermesJMS和其进行交互了。双击左侧菜单树中的msgQueue节点，可以查看该Queue中的信息。右键点击该节点选择`send message`向Queue中发送信息。

{% img /images/sendMessage.png 800 %}

然后刷新Queue就可以看到消息已经在Queue里了。

{% img /images/monitorQueue.png 800 %}

我们也可以打开ActiveMQ的Web终端向msgQueue中发送消息。地址:[http://localhost:8161/admin/queues.jsp](http://localhost:8161/admin/queues.jsp)

{% img /images/webconsole.png 800 %}

然后在HermesJMS中刷新即可看到新的消息。

{% img /images/msgFromWebConsole.png 800 %}
  
Hermes JMS还支持将消息存储到一个JDBC数据库中，具体可以查阅官方文档。

在使用Hermes JMS的过程中可以说到处是坑，软件弹出异常的次数不少于20次。可以说这个软件在健壮性、和兼容性方面还需要增强。


