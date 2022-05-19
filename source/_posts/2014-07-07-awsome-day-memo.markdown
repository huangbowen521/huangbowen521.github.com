---
layout: post
title: 成都亚马逊AWSome Day回顾
date: 2014-07-07 13:54:42 +0800
comments: true
categories: Cloud
---

昨天我和公司同仁一起参加了亚马逊在成都的第一场AWSome Day活动。整个活动时间异常紧促，短短一天包含了7堂session，讲师的狂轰乱炸使得我们同学们普遍觉得比上班累多了。好了，废话不多说，让我们来回顾一下昨天都讲了那些东西。

<!-- more -->

第一个session主题是AWS技术推动的创新。听名称就知道给亚马逊云服务打广告了。里面讲述了AWS各种服务的牛逼，讲师说AWS计算量=其余15家云计算平台总计算量 * 5。是不是吹牛不得而知了。还有一点是AWS自从2006年发布以来经历了43次主动降价。就我个人使用AWS服务而言，感觉价格还是挺公道的。我的个人博客使用了AWS的Route53，S3，CloudFrond等服务，一个月收费也不过1刀多。这个session一句话来总结就是我们最牛B，其它的都是渣渣。当然亚马逊讲师这样说毕竟还是有一定底气的。

第二个session主题是AWS服务概览。讲师带领我们对AWS的服务做了一个整体回顾。其计算服务主要包括EC2，存储服务包括S3，EBS，Glacier。数据库服务包括Redshift，DynamoDB，RDS，ElasticCache。部署与自动化服务包括CloudFormation，BeanStalk，OpsWorks。认证与访问服务IAM。网络服务VPC，Route53，ELB，Direct Connect。分布式计算服务包括Amazon EMR, Auto Scaling。内容传输服务CloudFront。大家看到这里是不是有点头晕了？

第三个session主题是AWS存储服务。讲师仔细介绍了S3，EBS，Glacier三种存储服务的不同与适用场景。S3的容灾率最高，可用性最高，并且每个存储文件附带一个url，可以直接访问。EBS价格公道，需要配合S3或EC2来访问使用。而Glacier相当于存档文件，可以保存10年以上，价格最低。如果你上存储的数据大于1TB，甚至PB级别，亚马逊还贴心的提供了数据Import/Export服务，那速度是杠杠的，可以达到几十GB的传输速率。那么亚马逊是如何达到这样的带宽那？方法是你把你的硬盘邮寄给亚马逊数据中心，亚马逊数据中心直接外挂你的硬盘进行数据导入。

吃了免费的午餐，下午的一大波session又来袭了。

下午第一场session是关于AWS计算服务和网络。讲师介绍了最常用的EC2服务，还有用于大数据分析和挖掘的EMR系统。并且顺带讲述了CloudFront，Rout53，ELB等是如何协作来提供网络应用程序的访问速度的。还有亚马逊那神奇的Auto Scalling技术。安全是云服务的重中之重。亚马逊采用了IAM来统一管理和分配对云上的资源的各种访问。用户可以创建用户名和密码，创建access key，创建用户组等多种方式来控制对各种资源的访问。亚马逊也提供了VPC和路由机制来实现公网和私有局域网的的隔离和访问。

第二场session是关于AWS管理的服务和数据库。亚马逊提供DynamoDB，RDS，Redshift，ElasticCache等与数据库有关的服务。其中DynamoDB是亚马逊自护研发的no sql数据库系统，自然少不了一番大吹特吹。RDS数据库支持mysql，Oracle，sql server等。这些数据库服务都支持自动备份，每隔5分钟备份一次，备份文件可保存0-35天。用户也可以手动备份，将备份文件放置到S3中永久保存。Redshift是亚马逊提供的数据仓库服务，可帮助你使用现有的商业智能工具进行大数据分析和处理。ElasticCache是亚马逊内置的缓存服务，DynamoDB，RDS数据库都可使用，可有效提高数据库吞吐量。

第三场session是AWS的部署和管理。CloudWacth可以检测云上的资源，并根据配置的policy来自动进行scale out和scale in。比如如果CloudWatch发现EC2实例的cpu占用率在90%以上并保持5分钟，则会自动setup新的EC2服务器并注册到ELB上。使用的好的话运维人员再也不同半夜从床上爬起来解决问题了。而CloudFormation，Elastic Beanstalk，OpsWorks都是DevOps工具箱中不可缺少的工具，如果要实现inforstructure as code，这些工具可助你一臂之力。

最后一个session是AWS解决方案参考架构概览。这里主要说明了你的应用程序如果要放到云上，在设计架构的时候需要遵守一定的准则，否则无法使用到云的优势，结果适得其反。比如AWS提供给你菜刀切肉，水果刀切水果。你偏偏拿个水果刀切肉还直吆喝着不好使，那就不对了。总之一句话，架构设计时一定要SOA，SOA，SOA。


OK，大概内容就是这样了。听了以后是不是想亲自动手。什么？还有没有AWS账号？什么？还没有信用卡？什么？不知道哪里有详细的学习文档？

统统忘掉这些吧。AWS祭出了神器：[https://run.qwiklabs.com](https://run.qwiklabs.com)。这是一个用于学习和演练亚马逊各种服务的实验室，只需花一分钟注册即可使用。里面有各种服务的详细操作文档，并且支持真实演练。当你选择一堂课后，qwiklabs会自动给你生成一个AWS账号，你可以使用该账号登陆到真实的亚马逊云服务终端中进行各种破坏而不花费你一毛钱。想当年我自己play with AWS各种云服务时可没少花冤枉钱。

熟悉了亚马逊云，学习其它云还不是小菜一碟。







