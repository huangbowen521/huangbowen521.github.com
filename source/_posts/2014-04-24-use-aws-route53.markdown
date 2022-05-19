---
layout: post
title: 使用亚马逊的Route53服务
date: 2014-04-24 01:36:22 +1000
comments: true
categories: AWS
---


自从自己的博客从github迁移到AWS以上，再也不用担心Github被墙了。再加上CloudFront的CDN功能，那访问速度真是杠杆的，无论是在中国内陆，还是澳洲海边，秒开无压力。

<!-- more -->

但是这几天突然发现博客打不开了。这可是切换到AWS上这么久以来的头一次。仔细研究了一下发现是自己的独立域名解析不到地址。我的独立域名买的是国内某公司的，使用的DNS服务器也是他们默认提供的。给他们技术人员反映以后，发现问题更有意思了。我在澳洲无法访问，而他在国内访问一切正常。这真是奇葩啊。

痛定思痛，决定将自己的域名解析服务迁移到AWS上来，使用Route53服务。


进入AWS Management Console以后，选择Route 53.

{% img /images/route53.png 700 %}


在主界面点击`Create Hosted Zone`，输入Domain name和comments。Domain name是你的域名，comments是描述。

{% img /images/create_hosted_zone.png 800 %}

完成以后就会看到有一个条目显示在表格中。双击这条记录。可以看到AWS已经为你创建了NS和SOA两种类型的Record Set。NS类型中的4个地址以后会用到，需要将你的域名提供商的DNS服务器换为这里列出的四个。

{% img /images/hosted_zone_list.png 800 %}


我们先为WWW创建一个Rcord Set。点击`Create Record Set`按钮，在在右侧输入相应的信息。

{% img /images/create_record_set.png 800 %}

AWS支持多种类型，由于我想让www.huangbowen.net指向我cloudfront的endpoint，所以选择CNAME，Value为我cloud front中的endpoint。最后点击`create`按钮。

这样在AWS这边就配置完成了。最后是需要登录到域名提供商的后台中，将域名解析服务器给换掉。

{% img /images/change_DNS.png 800 %}

在这里，将DNS换为之前AWS自动生成的NS地址。

这样就大功告成了，要等待2小时到1天来让新的解析方式生效。这下可以达到全年99.99%可访问率了吧。
