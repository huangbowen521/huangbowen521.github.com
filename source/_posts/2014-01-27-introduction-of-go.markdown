---
layout: post
title: 持续集成及部署利器:Go
date: 2014-01-27 18:39
comments: true
categories: 持续集成
tags: [Go, Agent]
---

Go是一款先进的持续集成和发布管理系统,由ThoughtWorks开发。（不要和Google的编程语言Go混淆了！）其前身为Cruise,是ThoughtWorks在做咨询和交付交付项目时自己开发的一款开源的持续集成工具。后来随着持续集成及持续部署的火热，ThoughtWorks专门成立了一个项目组，基于Cruise开发除了Go这款工具。

<!-- more -->

Go的官方网站是[http://www.thoughtworks.com/products/go-continuous-delivery/](http://www.thoughtworks.com/products/go-continuous-delivery/),其文档是[http://www.thoughtworks.com/products/docs/go/13.3/help/welcome_to_go.html](http://www.thoughtworks.com/products/docs/go/13.3/help/welcome_to_go.html)。

在我目前的项目中，持续集成及部署工具使用的就是Go这款工具。使用Go来建立起一个项目的持续部署pipeline是非常快的，非常方便。

## Go的架构设计

Go使用了Server-Agent的模式。Server用来展示和配置pipeline的DashBoard，并存放构建出来的Artifacts（存档文件，比如一个war包); Agent则用来执行真正的构建操作，一个Server可以和多个Agent建立连接，Agent支持多个主流的操作系统。

{% img /images/Server-Agent.png %}

这样的好处是：

1. 测试可以运行在不同的平台上，保证你的软件在多个平台都能良好的工作；

2. 你可以将测试划分为不同的群组并并行的运行在多个Agent上，节省运行测试时间；

3. 可以方便的管理Agent，及时响应不同的环境要求。

## Agent的lifecycle

下图是Agent工作的生命周期。

{% img /images/AgentLifeCycle.png %}

每一台Go的构建节点机器上都需要安装Go Agent软件（这个名字蛋痛，不是翻墙的那个软件），其用来建立起与Go Server的连接。
Go Agent会以轮询的方式来询问Go Server是否有当前有构建工作。如果有的话，Go Server会将其分配给处于ready状态的Agent。该Agent会在自己机器目录上创建一个目录，并下载同步最新的材料（比如配置的SVN repo地址）,然后执行指定的task，比如构建项目，运行单元测试或功能性测试等。如果配置了artifacts（比如构建的结果，一个war包），Agent执行完毕后将这个artifacts发布到Go Server上，这样artifacts就会被接下来的stage用到。

## Go中的一些概念

Go对复杂的构建和部署活动进行了合理的抽象，并提供了GUI和XML两种方式来配置pipeline。

{% img /images/GoConcepts.png %}

在Go的世界中，多个pipeline可以共同组成一个group，这叫做pipeline group。没个pipeline又由多个stage组成。假设一个pipeline需要做如下事情： 构建项目->部署到测试环境->部署到生产环境。那么每一个环节都可以设置为一个stage。而一个stage则由1个或多个job组成。比如构建项目这个stage，可能会分为编译及验证->功能性测试，每一步可以作为一个job。job则由一个或多个task组成。比如功能性测试这个job可以分为两个task来完成，先将artifacts部署到测试机上，再运行功能性测试。

## Go和Jenkins的比较

Go在设计之初就是一款持续部署工具，而Jenkins其实只是一款持续集成工具，如果要实现持续部署需要安装相应的插件。
Go由于是收费软件，有一定售后服务，而Jenkins作为开源软件，虽然免费，但是出现问题要么自己动手解决，要么等待维护社区修复。
Jenkins作为开源产品，社区比较活跃，文档资料和插件都比较多，而Go的文档或资料较少。

---------------------------------

Go的设计思想还是挺前卫的，在别人还在做持续集成这一步时，它已经做到了持续部署这个层次。但是目前就国内而言能做到持续部署的公司真的不多，甚至很多公司连持续集成这个实践都没有达到。所以Go作为一款收费产品很难在国内打开市场。

我觉得Go可以做出一个免费版来让个人试用，提供一些基本功能。然后为企业应用定制一些高级功能，放置到收费版中，可以扩大自己的市场占用率。








