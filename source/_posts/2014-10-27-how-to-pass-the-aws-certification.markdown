---
layout: post
title: AWS助理架构师认证考经
date: 2014-10-27 21:06:36 +0800
comments: true
categories: Cloud
tags: [aws, cloud]
---

上周考了亚马逊的解决方案架构师-助理级别的认证考试并顺利通过。这也算是对自己AWS服务熟悉程度的一种检验。在准备考试的过程中，把自己学习到的AWS知识都梳理了一遍，也算是收获颇丰。这次特意分享了该认证考经。

<!-- more -->

## 什么是AWS认证？

AWS 认证是对其在 AWS 平台上设计、部署和管理应用程序所需的技能和技术知识的一种认可。获得证书有助于证明您使用 AWS 的丰富经验和可信度，同时还能提升您所在的组织熟练使用基于 AWS 云服务应用的整体水平。

目前亚马逊推出了Solutions Architect,Developer和SysOps Administrator三个方向的认证。每个方向又分为Associate Level(助理级)，Professional Level（专家级）和Master Level（大师级）。当然目前只有Solutions Architect开放了Professional Level,其他层级会逐步开放中。

{% img /images/cert_roadmap_Q214_EN.png %}

## 我的AWS使用经验

* 本人于2013年注册了AWS账号，开始只是做些小实验玩，后来把自己的整个博客都迁移到了AWS上，使用了Route53，S3，CloudFront等服务。

* 在办公室做过Chef，CloudFormation，AWS云服务Overview等session。

* 2014年参加过亚马逊在成都举办的AWSome day活动，也算是对AWS云服务有了一个系统性了解。

* 使用Qwiklabs动手实验室在里面做过所有免费的实验，也借助里面的资源做了一些其它实验。

* 参加了一次亚马逊的在线课堂，内容是Auto Scaling。 

## 考前准备

* 仔细研究了[AWS助理架构师考试大纲](http://awstrainingandcertification.s3.amazonaws.com/production/AWS_certified_solutions_architect_associate_blueprint.pdf)，明确了自己和大纲要求的差距。

* 仔细研读了样题，了解了考试体型和方式，并且写了篇文章解析了样题。地址：[http://www.huangbowen.net/blog/2014/10/22/aws-cert-sample-question/](http://www.huangbowen.net/blog/2014/10/22/aws-cert-sample-question/)

* 进行过两次模拟考试。每次模拟考试20美元，每次有20道题。第一次是考前一周做的，只对了9道，惨败。第二次是考试前一天做的，对了14道，过关。

* 根据模拟考试的薄弱环节进行了补强，深入了解了VPN，IAM，Data Security等方面的知识。

* 大量查阅了[AWS的文档](http://aws.amazon.com/cn/documentation/)

## 考试

考试地点还是比较高大上的，在春熙路附近一座写字楼里。考试中心其实地方很小，就一个前台和一个办公室。前台接待我过后，就在会议室电脑上连接上了考试系统，然后她就出去了。也就是说基本算无人监考。正式考试有55道题，考试时间80分钟，全英文。题目都是选择题，有单选与多选，题目会明确告诉你有几个正确选项（如果没说就只有一个）。

可以说这些考题综合性非常强。有些很考察动手经验，有些则会考察具体服务的应用场景。如果只是对AWS云服务有肤浅认识的话，绝对是过不了的。我用了50多分钟时间做完了全部55道题，有25道题不确定答案。这给我留下了20多分钟来对这20多道题再进行斟酌。时间还是挺充裕的。有些题目你不知道就是不知道，除非能查阅相应文档或者动手做一下实验看一下，光想是想不出来的。

80分钟后自动交卷，这次正确率是65%，涉险过关（听别人说拿证的最低正确率就是65%）。我感觉做对的比例要高于65%的，可能还是自己对AWS有些知识点不熟悉。

交卷以后会立马知道成绩，邮箱里也会收到认证证书与可以使用的认证logo。

## 一些Tips

接下来是一些Tips给想要考取该证的人。

* 首先了解AWS认证:[http://aws.amazon.com/certification/](http://aws.amazon.com/certification/)，了解助理架构师考试大纲：[http://awstrainingandcertification.s3.amazonaws.com/production/AWS_certified_solutions_architect_associate_blueprint.pdf](http://awstrainingandcertification.s3.amazonaws.com/production/AWS_certified_solutions_architect_associate_blueprint.pdf)

* 阅读考试常见问题：[http://aws.amazon.com/cn/certification/faqs/](http://aws.amazon.com/cn/certification/faqs/)

* 必须读AWS白皮书：[http://media.amazonwebservices.com/AWS_Overview.pdf](http://media.amazonwebservices.com/AWS_Overview.pdf)

* 熟悉考试样题：[http://awstrainingandcertification.s3.amazonaws.com/production/AWS_certified_solutions_architect_associate_examsample.pdf](http://awstrainingandcertification.s3.amazonaws.com/production/AWS_certified_solutions_architect_associate_examsample.pdf)

* 动手做实验，可以使用动手实验室，免费蹭资源：[https://run.qwiklab.com](https://run.qwiklab.com)

* AWS文档中主要的service必须要过一遍，比如EC2，S3，VPC，EBS等。[http://aws.amazon.com/cn/documentation/](http://aws.amazon.com/cn/documentation/)

* 阅读各种云服务的常见问题：[http://aws.amazon.com/cn/faqs/](http://aws.amazon.com/cn/faqs/)

* 最好做一次模拟考试，熟悉考试的方式，题目类型，记住不熟悉的知识点然后加强。

* 这是从网上找的一个部分题目，可以了解下。[http://quizlet.com/35935418/detailed-questions-flash-cards/](http://quizlet.com/35935418/detailed-questions-flash-cards/)

----------------------------

总体来说AWS助理级架构师考试不算很难，但前提是你做好了充分准备的基础了。虽然你有可能长期使用AWS服务，但并不保证你能裸考过关。因为这是架构师认证，有些问题和场景可能你并没有经历过，有些服务你并没有使用过，在考试中这些缺点都会被放大。













