---
layout: post
title: 使用SOCKS5翻墙
date: 2016-02-29 22:53:29 +0530
comments: true
categories: SOCKS5
tags: [SOCKS5]
---

程序员离开了Google很难存活，尤其是现在被墙的网站越来越多，一批优秀的IT网站也深受影响。如果哪天GIHUB和StackOverFlow网站都被墙了，我估计整个中国的IT人员开发效率至少降低10个百分点吧。

<!-- more -->

之前一直使用的是公司提供的VPN来访问Google等站点。使用公司提供的VPN好处是不用交钱，不限流量，免费使用。坏处有两点：1是登录麻烦，每次都要输入冗长的密码，还要配合输入动态秘钥，这使得完全自动化变得异常困难；2是使用公司的VPN也不是任何网站都可以访问的，比如[http://www.slideshare.net/](http://www.slideshare.net/)这个站点通过公司VPN死活访问不了。

之前使用过免费的翻墙工具goAgent，通过google提供的GAE服务器作为中转站，流量是够了，但是速度稍感吃力。后来由于众所周知的原因GoAgent不再进行更新，功能也无法正常使用。

在同事的推荐下，我决定尝试一些收费的Proxy服务。同事向我介绍了使用SOCKS5进行翻墙的技术。并推荐了收费的Proxy服务器。我试用了一下觉得不错，现在把配置方式讲述一下。

1. 首先是在[枫叶主机](https://www.fyzhuji.com/)上购买Shadowsocks代理服务。

	[这里](https://www.fyzhuji.com/shadow.html)可以选择你的计划。Shaowsocks是基于SOCKS5开发的程序组件，分为客户端和服务器端。其实枫叶主机就是找了一批机器安装了Shadowsocks服务器端，作为服务器，然后我们购买了服务以后就可以通过给定的密码和端口连接到这些服务器上去。

	购买了以后可以查看自己可以使用服务器列表以及密码、端口等信息。

	{% img /images/fyzhuji.png 500 %}

	我买的是季度用户，40元三个月，60G的流量。

2. 然后去[shadowsocks](https://shadowsocks.org/en/download/clients.html)官网下载合适的客户端。

	不幸的是官网已经被封了，所以无法直接访问。想要下载翻墙工具，但翻墙工具的下载老巢被墙了，这真是个蛋痛的问题。不过我想聪明的你一定可以想到其它的下载方式的。ShadowSocks支持几乎所有主流的操作系统，也包括移动操作系统。不过比较蛋痛的是我在App Store没有找到它的IOS版客户端，可能被苹果下架了。整个安装过程非常简单，这里就不详述了。

3. 然后就是配置客户端，主要是将购买的服务器地址以及密码、端口等配置到客户端中。

	这个过程也不难，教程非常多。这里是枫叶主机提供的Windows上的配置教程：
	[https://www.fyzhuji.com/knowledgebase-12.html](https://www.fyzhuji.com/knowledgebase-12.html)。以下是OSX系统上的配置教程：[https://www.fyzhuji.com/knowledgebase-14.html](https://www.fyzhuji.com/knowledgebase-14.html)。主要注意的是ShadowSocks可以开启全局代理模式，它比普通的HTTP代理要强大的多。如果想要在Chrome下使用Shadowsocks的话，一种方式是讲Chrome的代理设置为默认使用系统代理；另一种方式就如Windows上配置教程一样使用SwitchySharp，并进行相应配置。

你可以将ShadowSocks客户端设置为开机自启动。这样以后打开电脑就可以直接无拘无束的网上冲浪了，不亦快哉。