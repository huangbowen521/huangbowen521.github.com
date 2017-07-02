---
layout: post
title: HashiCorp Vault介绍
date: 2017-07-02 22:00:44 +0800
comments: true
categories: 
---

HashiCorp Vault是一款企业级私密信息管理工具。说起Vault，不得不提它的创造者HashiCorp公司。HashiCorp是一家专注于DevOps工具链的公司，其旗下明星级产品包括Vagrant、Packer、Terraform、Consul、Nomad等，再加上Vault，这些工具贯穿了持续交付的整个流程。

<!-- more -->

{% img /images/hashicorp_list.png 800 %}



HashiCorp Vault在2016年四月进入了ThoughtWorks技术雷达，位于Tools分类，处于ACESS级别。在2017年3月份最新一起Tech Radar中，HashiCorp Vault已经处于TRIAL级别。

{% img /images/vault_tech_radar.png 600 %}

https://www.thoughtworks.com/radar/tools/hashicorp-vault

## 为什么要使用HashiCorp Vault？

在企业级应用开发过程中，团队每时每刻都需要管理各种各样的私密信息，从个人的登陆密码、到生产环境的SSH Key以及数据库登录信息、API认证信息等。通常的做法是将这些秘密信息保存在某个文件中，并且放置到git之类的源代码管理工具中。个人和应用可以通过拉取仓库来访问这些信息。但这种方式弊端很多，比如跨团队分享存在安全隐患、文件格式难以维护、私密信息难以回收等。

尤其是微服务大行其道的今天，如何让开发者添加私密信息、应用程序能轻松的获取私密信息、采用不同策略更新私密信息、适时回收私密信息等变得越来越关键。所以企业需要一套统一的接口来处理私密信息的方方面面，而HashiCorp Vault就是这样的一款工具。

## HashiCorp Vault的特性

HashiCorp Vault作为集中化的私密信息管理工具，具有以下特点：

存储私密信息。 不仅可以存放现有的私密信息，还可以动态生成用于管理第三方资源的私密信息。所有存放的数据都是加密的。任何动态生成的私密信息都有租期，并且到期会自动回收。

滚动更新秘钥。用户可以随时更新存放的私密信息。Vault提供了加密即服务（encryption-as-a-service）的功能，可以随时将密钥滚动到新的密钥版本，同时保留对使用过去密钥版本加密的值进行解密的能力。 对于动态生成的秘密，可配置的最大租赁寿命确保密钥滚动易于实施。

审计日志。 保管库存储所有经过身份验证的客户端交互的详细审核日志：身份验证，令牌创建，私密信息访问，私密信息撤销等。 可以将审核日志发送到多个后端以确保冗余副本。

另外，HaishiCorp Vault提供了多种方式来管理私密信息。用户可以通过命令行、HTTP API等集成到应用中来获取私密信息。HashiCorp Vault也能与Ansible、Chef、Consul等DevOps工具链无缝结合使用。

## HashiCorp 架构

HashiCorp对私密信息的管理进行了合理的抽象，通过优良的架构实现了很好的扩展性和高可用。

{% img /images/hashicorp_vault_art.png 600 %}


Storage backend: 存储后端，可以为内存、磁盘、AWS等地方。

Barrier：隔离受信区域和非授信区域，保证内部数据的安全性。

HTTP API：通过HTTP API向外暴露服务，Vault也提供了CLI，其是基于HTTP API实现的。

Vault提供了各种Backend来实现对各种私密信息的集成和管理。比如Authentication Backend提供鉴权，Secret Backend用于存储和生成私密信息等。

## 总结

HashiCorp Vault作为私密信息管理工具，比传统的1password等方式功能更强大，更适合企业级的应用场景。在安全问题越来越严峻的今天，值得尝试HashiCorp Vault。



