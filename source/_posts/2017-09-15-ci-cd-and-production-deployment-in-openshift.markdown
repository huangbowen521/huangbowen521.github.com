---
layout: post
title: OpenShift中的持续交付
date: 2017-09-15 18:04:42 +0800
comments: true
categories: OpenShift
---

上一文中讲述了如何在AWS下搭建OpenShift集群。这篇文章将目光转向如何在OpenShift中实现CI/CD以及产品环境的部署。

<!-- more -->

## 持续交付

如果要打造一个持续交付的流水线，首先要考虑多环境的问题。一般一个应用程序会有多个环境，比如开发环境、集成测试环境、系统测试环境、用户验收测试环境、类生产环境、生产环境。如何在OpenShift中隔离并建立对这些环境的部署流程有多种方案可以选择。

1. 同一个project中使用label和唯一名称来区分不同的环境；
2. 集群中的不同project来隔离环境；
3. 跨集群来隔离环境。

我们以第二种方式为例，演示下多环境管理问题。

{% img /images/oc_mutl_env.png 500 %}

在上图中，我们有一个build project。build project包含了一组相互依赖性比较强的应用，每个应用对应一个build config，产生的Image Stream存放在image register中。而每个环境各对应一个project，其中包含了该应用的deployment config，其镜像输入是build config产生的Image Stream。之所以这样做，有以下几点考虑：

1. 不同的环境分布在不同的project中，可以很好的借助project的特性进行环境隔离。比如sys project的容器只能部署在label为sys的node上，prod project的容器只能部署在label为prod的node上。

2. 不同的project可以分别定义权限访问和控制。比如只有QA才能操作sys project中的资源，运维工程师才能操作prod project中的资源。

3. 不同的环境共用一个Image Stream，保证了应用程序镜像在不同环境中的是完全一致的，防止由于测试环境和生产环境不一致而引入缺陷。

那么大家共用同一个Image Stream，如何实现应用的promotion那？解决方案就是使用tag。

{% img /images/oc_promotion.png 500 %}

如上图所示，一个image stream里面有多个版本的镜像，而OpenShift可以为版本添加自定义tag。在不同的project里面，我们配置image的来源为”ImageStreamTag”，名称为”applicationName:environmentName”。比如sys project的镜像名为”App1:sys”，prod project的镜像为”App1:prod”。如果想将version 3的镜像推送到sys环境，只需要简单的给version 3的镜像打上sys的tag，这样部署sys环境时就会自动使用version 3的镜像。

```bash
oc tag App1:latest App1:sys
```

如果在Deployment Config里面配置了自动监听tag的变动的操作，那么一旦你修改了ImageStream的tag，就会自动触发对应环境的部署。

由于应用程序镜像在不同的环境中是一致的，那么变动的部分都被抽取到了外部配置中。如何根据不同的环境来加载对应的外部配置那？实现方式有很多种，这里介绍了使用Spring Cloud Config的方案。

{% img /images/oc_config.png 500 %}

首先我们将针对不同环境的配置放置在一个git仓中，然后通过Spring Cloud Config Server将其转换为http服务。而我们在应用中嵌入Spring Cloud Config Client，其会接收一个环境变量来拉取指定环境的配置。而该环境变量可以通过Deployment Config来进行注入。

```bash
oc env dc/sys PROFILE=sys
```

使用Spring Cloud Config给予了我们更多的灵活性。我们可以选择在应用程序第一次启动的时候拉取配置，也可以设置每隔一段时间自动更新配置，从而实现热更新。

OpenShift虽然提供了构建和部署的能力，我们有时也需要使用Jenkins之类的工具来可视化以及编排整个流水线。

{% img /images/oc_jenkins.png 500 %}

既然OpenShift是个容器化的管理平台，那么我们完全也可以将Jenkins作为一个应用纳入到OpenShift中来托管，这样Jenkins的Master和Slave都是容器化的。OpenShift官方提供了一个Jenkins2.0的镜像，其预装了OpenShift pipeline插件，可以很方便地进行构建、部署等操作。

## 生产环境的部署

OpenShift在产品环境的部署默认是rolling的方式。

{% img /images/oc_rolling.png 500 %}

每次部署时，它会启动一个新的Replica Controller，部署一个pod，然后削减旧的Replica Controller的pod，如此往复，直到旧的Replica Controller中的所有pod都被销毁，新的Replica Controller的所有pod都在线。整个过程保证了服务不宕机以及流量平滑切换，对用户是无感知的。

而有的时候部署场景要负责些，比如我们想在产品环境对新版本做了充分的PVT（product version testing）才切换到新版本。那么就可以使用蓝绿部署的方式。

{% img /images/oc_blue_green.png 500 %}

蓝绿部署方案的关键点在于一个Router对应两个Service。而Route作为向外界暴露的服务端口是不变的，两个Service分别对应我们的生产蓝环境和生产绿环境。同时只有一个Service能接入Router对外服务，另一个Service用来进行PVT测试。切换可以简单的修改Router的配置即可。

```bash
port:
  targetPort: app-blue-http
to:
  kind: Service
  name: app-blue
```

## 结语

OpenShift在应用的构建以及部署方面为我们提供了大量开箱即用的功能和解决方案,所以实现持续交付不再那么艰难。我们可以将更多的精力花费在提升应用程序质量以及架构方面，交付更好的产品。