---
layout: post
title: 云时代基础设置自动化管理利器： Chef
date: 2013-09-16 23:29
comments: true
categories: Cloud
tags: [Chef, Cloud]
---

{% img /images/migrate_to_cloud.png %}

云时代的到来势不可挡。尤其作为程序员，我们每天或多或少的直接或间接的使用者各种云服务。云平台有很多种，如云软件（SaaS， Software as a service）、云平台（PaaS, Platform as a service）、云设备(IaaS, Infrastructure as a service)。云计算由于其价格低廉、按需提高、使用方便等特点，越来越受到人们的欢迎。

<!-- more -->


## Chef是什么？


Chef的出现正是顺应了云潮流。如果你是一个公司的devops成员，每天配置服务器上的软件和服务，为了给服务器新加一个节点而通宵作业，为了解决服务器上的一个奇诡问题而想破脑袋。
这时候，你应该考虑使用Chef。

> Chef is built to address the hardest infrastructure challenges on the planet. By modeling IT infrastructure and application delivery as code, Chef provides the power and flexibility to compete in the digital economy.

通过这段话，可以总结出Chef的几个特点。

1. Chef是为了解决基础设施难题。

2. Chef通过建模将基础设施及应用程序交付抽象为代码。

3. Chef具有强大的能力及灵活性.
4. 由于配置即代码，基础设施即代码，Chef自动具有了版本控制功能，同时添加复制服务器也变得更容易。

Chef主要包括三大块：Workstation、Chef Server、Chef Client。（另外还有个chef-solo，是个简化版的Chef-Client，不在本文讨论范围。）

以下是Chef的架构图。

{% img /images/chef_overview.png 600 %}


## Workstation

Workstation可以简单地认为是自己的工作电脑，在上面需要建立一个chef-repo。chef-repo管理了cookbooks、recipes、roles、environment等数据。cookbooks、recipes、roles是Chef对infrastructure做的一层抽象。可以打个这样的比喻，cookbooks可以理解为一个菜系，recipes就是这个菜系里面的一道道菜，比如宫保鸡丁，roles则是一桌丰富的宴席，比如满汉全席。而nodes则是一个个盛菜的桌子。我们可以来一个满汉全席（直接给这个node设置一个role），也可以从菜系里抽一些菜品来做一到家常小菜（给指定node设置一个run list，里面包括指定的recipe）。recipe就是一系列的资源，比如在node上需要安装jvm，那么安装jvm的包就是一个recipe。

在Workstation上主要通过knife这个命令行工具来创建和管理这些资源。

```bash 

$ knife help list
Available help topics are:
  bootstrap
  chef-shell
  client
  configure
  cookbook
  cookbook-site
  data-bag
  environment
  exec
  index
  knife
  node
  role
  search
  shef
  ssh
  status
  tag

```
knife是由ruby写的一个gem。它的API很有表现力。

```bash 

# 创建一个recipe
$ knife cookbook create myRecipe
** Creating cookbook myRecipe
** Creating README for cookbook: myRecipe
** Creating CHANGELOG for cookbook: myRecipe
** Creating metadata for cookbook: myRecipe

#从cookbook server上下载recipe
$ knife cookbook site install apache2

#将本地的recipe上传到服务器上
$ knife cookbook upload myRecipe


#查看服务上当前注册的所有的node
$ knife node list
bowenhuang-starter 

#查看bowenhuang-starter node的详细信息
$ knife node show bowenhuang-starter
Node Name:   bowenhuang-starter
Environment: _default
FQDN:        bowenhuang-starter
IP:          10.0.2.15
Run List:    recipe[apt], recipe[apache2]
Roles:
Recipes:     apt, apache2
Platform:    ubuntu 12.04
Tags:

#将指定IP或主机名的机器注册到服务器上
$ knife bootstrap IP \
  --ssh-user USERNAME \
  --ssh-password PASSWORD \
  --ssh-port PORT \
  --sudo

```

在cehf-repo下需要建立一个隐藏的文件夹.chef，该文件夹中包含三个重要的文件：USER.pem, ORGANIZATION-validator.pem, knife.rb。USER.pem是一个私钥，用于workstation与chef server通讯。ORGANIZATION-validator.pem是另一个私钥，用于bootstrap一个新node时该node第一次与服务器通讯。knife.rb则是knife的配置的文件，比如客户端key文件路径，chef server的api地址，cookbook的路径等。


## Chef Server

Chef Server用来存储workstaton上传的各种资源，包括cookbooks，roles，environments，nodes等。我们可以使用公有的Server，如opscode,也可以通过开源软件架设自己的私服。Chef server提供了一系列的api，用于与workstation和nodes传输资源和数据。opscode上的server需要注册，注册以后需要建立一个organisation, 并从server上下载生成的USER.pem私钥和ORGANISATION-validitor.pem私钥。Chef server也提供了一个search的API，可以通过workstation根据attributes检索注册在服务器上的node。

Chef Server本来是使用ruby写的，后来为了保持高并发和稳定性，能够同时服务一定数量级的node，Chef Server内核采用了支持高并发的Erlang程序，而前端则仍然使用ruby on rails。

## Nodes

在bootstrap一个node时候，首先需要在该node上安装chef-client包，并将workstation上的ORGANIZATION-validator.pem文件拷贝到node节点上，供node与chef server建立连接。chef server通过验证后会发给node一个新的私钥，以后node就可以通过这个新的私钥与chef server交互。在node的`etc\chef`的目录下会生成四个文件：client.pem, client.rb, first-boot.json, validation.pem。vlidation.pem就是从workstation拷贝过来的秘钥，client.pem则是服务器为该node新生成的秘钥，client.rb则定义了服务器的API地址，秘钥文件路径等信息，first-boot.json则存放了bootstrap该node节点时的配置信息，如run list信息，role信息等。

chef-client是一个可定期的后台运行的命令行程序。chef-client会收集当前node的各种信息，如操作信息型号版本等，和chef server建立连接，获取chef server上对该节点的配置信息，并安装指定的recipe，运行指定的服务。

-----------------------------------------------------------------------

通过Chef，可以一键更新所有的服务器，在指定的服务器上安装指定的软件。如果有新同事入职，可以很轻松的setup一台开发机；如果服务器节点需要扩展，也只需要几个命令就可搞定。运筹帷幄，一切皆在掌控之中。














