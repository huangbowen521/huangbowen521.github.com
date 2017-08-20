---
layout: post
title: 在AWS中部署OpenShift平台
date: 2017-08-20 22:55:47 +0800
comments: true
categories: OpenShift
tags: [AWS, OpenShift]
---

OpenShift是RedHat出品的PAAS平台。OpenShift做为PAAS平台最大的特点是它是完全容器化的PAAS平台，底层封装了Docker和Kubernetes，上层暴露了对开发者友好的接口来完成对应用程序的集成、部署、弹性伸缩等任务。

<!-- more -->

Docker提供了对打包和创建基于Linux的轻量级容器的抽象。而Kubernetes提供了多主机集群管理和Docker容器编排。OpenShift基于Docker和Kubernetes加入了新的功能：

* 源代码管理、构建和部署
* 在系统中集成镜像的管理
* 按需扩展的应用程序管理
* 在大型开发者组织中进行团队管理和用户追踪

OpenShift直接提供支持的应用程序镜像有：

{% img /images/oslanguage.png 700 %}

OpenShift直接提供支持的数据库镜像有：

{% img /images/osdatabase.png 700 %}

除此之外，OpenShift还让你通过一键点击便生成相应的应用，比如几秒之内搭建好一个Jenkins服务。包括以下：

{% img /images/osapplication.png 700 %}

## OpenShift架构概览

{% img /images/openshiftart.png 700 %}

从上图可以看出，OpenShift的典型用户分为两种，开发人员和运维人员。开发人员可以通过现有的代码管理工具和持续集成、交付工具利用OpenShift完成对应用程序的打包、部署、扩容操作。而运维人员可以利用现有的自动化工具实现对OpenShift平台的维护。

OpenShift中的Kubernetes用来管理跨宿主机（或容器）的容器化应用程序，并提供部署、维护和应用程序扩容机制。对于一个Kubernetes集群来说，它包括一个或多个master以及一组node。

Master主机托管了API服务器、controller manager服务器以及etcd实例。Master管理Kubernetes集群中的节点并控制运行在节点上的pod。

Node则提供了容器的运行时环境。Kubernetes节点中的每个node会运行受Master管理的服务，当然也包括Docker、Kubelet及serverice proxy服务。node可以为云机器、物理系统或者虚拟系统。Kubelet用来更新node上的运行的容器状态。Service Proxy用于运行一个简单的网络代理，来反映定义在node的API中的服务，从而使node可以跨后端进行简单的TCP和UDP流转发。

## OpenShift架设要求

如果想自己架设OpenShift平台作为商业用途，必须要获取OpenShift Enterprise的付费订阅。目前OpenShift Enterprise的最新版本为3.6版。对于Master和Node节点的系统要求如下。

Master:

* 物理或虚拟机，或者运行于公有云或私有云之上的实例
* 基础操作系统为Red Hat企业版Linux（RHEL）7.1，并包含最小的安装选项
* 2核CPU
* 最小8GB内存
* 最小30GB硬盘空间

Node：

* 物理或虚拟机，或者运行于公有云或私有云之上的实例
* 基础操作系统为Red Hat企业版Linux（RHEL）7.1，并包含最小的安装选项
* Docker 1.6.2及以上版本
* 1核CPU
* 最小8GB内存
* 最小15GB硬盘空间
* 另外最小15GB的未分配空间，需要通过docker-storage-setup进行配置


### 环境要求：

* 需要一个DNS zone来解析OpenShift router的IP地址。比如\*.cloudapps.example.com. 300 IN  A 192.168.133.2
* Master和Node之间必须要有共享的网络，两者之间可以互相通讯。
* 需要一个Git Server和能够访问该Server的账号。


## AWS中部署OpenShift平台


下图是一个在AWS中的OpenShift集群的示例。

{% img /images/refarch-ocp-on-aws-v3.png 700 %}

* Master节点：包含3个Master实例，实现高可用，上面运行etcd、通过一个external load balancer向外暴露服务。

* Infra Node: 由三个实例组成，这三个实例用来运行支撑OpenShift集群服务的一系列容器。

* App Node：用于运行应用程序容器的实例，可以按需进行扩展。

* Bastion：用于限制对集群中实例的ssh访问，增强安全性。

* 存储：OpenShift使用EBS作为实例的文件系统并用于持久化容器的存储；另外还使用S3这个对象存储服务作为OpenShift registry的存储。
ELB：总共有三个.一个用来在集群外访问OpenShift API、OpenShift console。一个在集群内访问OpenShift API。另一个用来访问通过route暴露的部署在集群中的应用程序服务。最后通过AWS的Route53来管理DNS。

## 部署OpenShift集群的三个阶段

在AWS中部署OpenShift集群包括三个阶段：

* 第一阶段：在AWS中设置好基础设施
* 第二阶段： 在AWS上部署OpenShift Container平台
* 第三阶段： 部署后的环境检查

关于整个部署活动绝大多数都是可以自动化的。RedHat提供了一个GitHub repo：openshift-ansible-contrib。openshift-ansible-contrib提供了将OpenShift集群部署到不同的Cloud供应商的解决方案，当然也包括了AWS。里面包含了相应的文档、代码以及脚本。RedHat提供了一个叫做openshift-ansible-playbooks的RPM包，openshift-ansible-contrib利用该RPM包来完成阶段1和阶段2，在阶段3中我们可以利用一些现有的脚本工具实现环境检查和认证。

### 对AWS环境的要求

选择部署的AWS区域需要至少有三个可用区以及2个EIP。该OpenShift平台需要新建三个公共子网和三个私有子网。
由于需要新建一大批的AWS资源，所以必须要提供一个有适当权限的AWS用户，包括创建账号、使用S3、Route53、ELB、EC2等。

六个子网需要在一个VPC中。Ansible脚本会建立一个NAT Gateway用来供内部的EC2实例访问外网。同时也会建立8个Security Groups来限制不同的实例、ELB和外部网络间的访问。

openshift-ansible-contrib提供了部署基础设施、安装和配置OpenShift以及扩展router和registry的功能。运行Ansible的机器必须是RHEL7操作系统。具体的安装过程可参见https://access.redhat.com/documentation/en-us/reference_architectures/2017/html/deploying_openshift_container_platform_3.5_on_amazon_web_services/deploying_openshift。

安装完毕后的环境检查可以参见https://access.redhat.com/documentation/en-us/reference_architectures/2017/html/deploying_openshift_container_platform_3.5_on_amazon_web_services/operational-management。


## 总结

在AWS上部署OpenShift平台并不是一件轻松的事情，一方面需要对AWS的各种服务了如执掌，一方面也需要对OpenShift的架构和核心概念有所了解。虽然RedHat提供了一些Ansible脚本和RPM包来简化安装，但整个过程也绝非一片坦途。安装完备之后，如何和企业现有的应用程序开发流程、持续交付流水线结合起来无缝过度，也是一件非常考验人的事情。下一篇文章会对这些方面进行揭秘。



