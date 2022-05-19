---
layout: post
title: 亚马逊云服务之CloudFormation
date: 2013-10-23 16:07
comments: true
categories: AWS
tags: [AWS, CloudFormation] 
---

亚马逊的Web Service其实包含了一套云服务。云服务主要分为三种:

* IaaS: Infrastructure as a service,基础设施即服务。

* PaaS: Platform as a service, 平台即服务。

* SaaS: Software as a service, 软件即服务。

而亚马逊提供的云服务至少涵盖了前面两种。以下是亚马逊提供的各种服务。

<!-- more -->


{% img /images/cloudformation1.png 680 %}

以上的图中S3、EC2等就属于IaaS，RDS、DynamoDB等就属于PaaS。

今天分享的是亚马逊的CloudFormation，亚马逊将其归类为Deployment&Management（部署及管理类别）。为什么亚马逊要推出这项服务那？我们可以假设一个场景。如果你要将一个WordPress网站部署到亚马逊上，你需要以下几步:创建一个EC2实例->在此EC2实例上配置WordPress->创建RDS数据库实例->在WordPress中配置与该RDS的连接。整个过程耗时耗力，需要在亚马逊不同的云服务间跳转。这些操作关联性很强，不具备自动化。如果你使用了CloudFormation以后，只需要在页面上点几个按钮，输入一些参数，就可以创建一个博客，省时省力,甚至完全不用任何UI，直接通过命令行完成。

**CloudFormation给予了用户一种简单的方法来创建和管理一系列有关联的AWS的资源,可以有序的及可预见的初始化和更新这些资源。**

要了解CloudFomation之前，先要了解几个概念。

### Template - 模板

Template是CloudFormation的一个重要概念。Template本质上是一个json格式的文件。该文件定义了你需要使用那些AWS的资源，并且如何初始化这些资源。CloudFormation支持的资源如下图所示。

{% img /images/cloudformation2.png 680 %}

一个Template文件至少包含一下几个属性:

```json

{
    "AWSTemplateFormatVersion" : "2010-09-09",  //Template版本

    "Description" : "描述该Template的用途",

    "Parameters": {        // 应用该Template需要配置的参数
    },

    "Resources" : {        // 使用到的AWS的资源及它们之间的关系
    },

    "Outputs" : {        // stack创建完毕后的一系列返回值
    }
}

```

这个Template就是用来创建一个EC2的虚拟机。

```json

{ "AWSTemplateFormatVersion" : "2010-09-09",
  "Description" : "Create an EC2 instance running the Amazon Linux 32 bit AMI.",
  "Outputs" : { "InstanceId" : { "Description" : "The InstanceId of the newly created EC2 instance",
          "Value" : { "Ref" : "Ec2Instance" }
        } },
  "Parameters" : { "KeyPair" : { "Description" : "The EC2 Key Pair to allow SSH access to the instance",
          "Type" : "String"
        } },
  "Resources" : { "Ec2Instance" : { "Properties" : { "ImageId" : "ami-3b355a52",
              "KeyName" : { "Ref" : "KeyPair" }
            },
          "Type" : "AWS::EC2::Instance"
        } }
}

```

AWS官方提供了很多Template的资源，我们可以直接使用，当然也可以按需修改，甚至自己手动编写自己的Template。<http://aws.amazon.com/cloudformation/aws-cloudformation-templates/ >列出了一系列可供使用的Template。

### Stack - 堆

Template只是一个json格式的文件，如果想要使用它的话，需要创建一个Stack,在Stack中指定你要使用的Template,然后亚马逊才会按照Template中的定义来创建及初始化资源。可以在AWS Management Console中或通过命令行调用API的方式来创建Stack。

## 实战

接下来，我们就通过AWS Management Console，使用CloudFormation来创建一个部署在EC2上、使用RDS作为数据库的WordPress网站。

首先，需要登录到AWS Management Console，选择EC2服务，点击左侧菜单的Key Pair,创建一个Key Pair。这个Key Pair将在接下来被使用，主要使AWS能够ssh到创建的EC2机器上。当然你也可以使用已有的Key Pair。

{% img /images/cloudformation3.png 680 %}

然后选择CloudFormation服务，点击`Create Stack`按钮。

然后输入Stack名称，并选择一个Template。由于我们要创建一个WordPress的站点，可以选择`use a sample temple`,并选择WordPress这个模板。

{% img /images/cloudformation4.png 680 %}

{% img /images/cloudformation5.png 680 %}

然后点击`continue`按钮，配置相关的参数。注意在KeyName一项中输入我们第一步创建的Key Pair。

{% img /images/cloudformation6.png 680 %}


然后点击`continue`按钮，配置此Stack的标签，这个是可选项，可以跳过。再点一下`continue`，将会再次确认想要的创建的资源信息，继续后就可以看到资源正在创建了。

{% img /images/cloudformation7.png 680 %}

页面下半部分有很多标签，你可以随时查看该Stack的描述、资源、事件、参数、输出等各项信息。

等待大约20分钟，Stack就会执行完毕，在Outputs标签中你会看到有一个url。

{% img /images/cloudformation8.png 680 %}


这个就是我们创建的WordPress的入口地址，访问该链接会进入WordPress的初始化设置页面。

{% img /images/cloudformation9.png 680 %}

配置完以后，一个新的WordPress就诞生了，重新访问URL，你会看到你的博客首页。

{% img /images/cloudformation10.png 680 %}

## CloudFormer

提到CloudFormation就不得不说CloudFormer。CloudFormer是亚马逊提供的一个工具，用来给已有的AWS资源创建CloudFormation Template。这样你在以后创建相同的AWS资源时就可以直接使用这个Template了。

要使用CloudFormer首先要创建一个Stack，CloudFormer就被部署到一台EC2机器上，通过这个Stack返回的Outputs的URL我们可以一步步勾选使用到的资源，最终生成一个Template，该Template会自动放置到你的S3中。

首先创建Stack,Template选择use a sample template,并选择CloudFormer。

{% img /images/cloudformation11.png 680 %}

然后点击`continue`，配置其他参数，直到走完创建Stack这个流程。

{% img /images/cloudformation12.png 680 %}

等待这个Stack创建完毕后，就可以从Outputs标签得到一个URL。这个URL是执行CloudFormer工具的入口地址。

{% img /images/cloudformation13.png 680 %}


点击此URL,即可按照配置一步步配置自己的Template。

{% img /images/cloudformation14.png 680 %}

流程走完后，生成的Template会存放到你的S3 bucket中。

------------------------------------------------------------

由于CloudFormation支持对几乎所有的AWS资源进行创建和配置，并且能够按照指定顺序创建，其Template简洁易懂、容易配置、可重用，所以是你使用AWS的不可多得的好帮手。