---
layout: post
title: 将我的博客迁移到亚马逊云端(1)
date: 2013-09-30 14:09
comments: true
categories: Cloud
tags: [AWS, Cloud, Octopress] 
---

{% img /images/cloudcompute.png 400 %}

[Octopress]已经被公认为Geeker的博客框架。它所拥有的特性都很符合Geeker的癖好:强大的命令行操作方式、简洁的MarkDown语法、灵活的插件配置、美轮美奂的theme（自带响应式设计哦）、完全可定义的部署......

一般大家都喜欢把博客部署到github pages上，免费速度快，与[Octopress]无缝结合。但是自己最近迷上了AWS，就捉摸着将自己的[Octopress]博客部署到AWS的S3上，使用CloudFront做CDN，使用Amazon Route 53做域名映射。倒腾了两天，终于搞定了，也学到了很多东西。不敢私藏，拿出来和大家分享。

<!-- more -->

这篇文章主要讲如何将Octopress博客部署到S3上去。下一篇文章会讲如何将CloudFront做CDN,并与现有域名绑定。

在此之前先普及一些概念。

AWS - Amazon Web Service,亚马逊提供的云服务简称。

S3 - Amazon Simple Storage Service, 亚马逊提供的一种存储静态资源（如css、js、html文件，音视频文件）的服务。

CDN - Content Delivery Network, 内容分发网络。

Amazon CloudFront - 亚马逊提供的一种内容分发服务，提高你的网站访问速度。

Amazon Route 53 - 亚马逊提供的一种稳定高效的域名解析系统。

第一步，注册一个亚马逊的账号，注册地址是<https://portal.aws.amazon.com/gp/aws/developer/registration/index.html>。注意注册的时候需要提供一张具备外币功能的信用卡。

第二步，登陆到Amazon management console里，单击右上角的名称，选择Security Credentials标签，然后点击左侧标签按照向导创建一个group,一个从属于这个group的user，并为该user生成一个Access key，记录下来Access key Id 及 Secret Access Key。亚马逊的文档还是非常详细的，不懂的可以多看看提示信息和帮助文档。


第三步，在Amazon management console里选择Services -> S3 service，并创建两个bucket。假如你的博客域名为example.com，那么两个bucket的名称分别为example.com,www.example.com。为什么要创建两个那？是因为我们要保证用户无论输入www.example.com还是example.com都可以访问我们的网站。

{% img /images/twobucket.png 780 %}

第四步，选择www.example.com这个bucket，点击properties标签，在Static Website Hosting中选择Redirect all requests to another host name，并配置‘Redirect all requests to:’为example.com。这样来自www.example.com bucket的访问都会自动转发给example.com这个bucket。我们只需为example.com这个bucket同步我们的博客文件即可。 

{% img /images/redirectrequest.png 780 %}


第五步，选择example.com这个bucket，在Static Website Hosting中选择‘Enable Website Hosting’,并配置Index Document，我的是index.html。这个Index Document是默认返回的object名称。比如如果用户直接访问bucket的某个目录，系统会检测该目录下是否存在Index Document中配置的文件名，如果有则会自动返回这个object。

{% img /images/staticwebsitehosting.png 780 %}

第六步，选择'Permissions'标签，点击’add bucket policy‘按钮，加入如下的policy.

```javascript

{
     "Version": "2008-10-17",
     "Statement": [
          {
               "Sid": "AddPerm",
               "Effect": "Allow",
               "Principal": {
                    "AWS": "*"
               },
               "Action": "s3:GetObject",
               "Resource": "arn:aws:s3:::example.com/*"
          }
     ]
}

```

这个policy其实是给所有匿名用户访问该bucket里面文件的权限。

{% img /images/bucketpolicy.png 780 %}

第七步，还是在’Permissions‘标签里，点击’Add CORS configuration‘按钮，加入如下的配置：

```xml

<?xml version="1.0" encoding="UTF-8"?>
<CORSConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
    <CORSRule>
        <AllowedOrigin>*</AllowedOrigin>
        <AllowedMethod>GET</AllowedMethod>
        <MaxAgeSeconds>3000</MaxAgeSeconds>
        <AllowedHeader>Authorization</AllowedHeader>
    </CORSRule>
</CORSConfiguration>

```

这个是用来配置跨域访问的权限，即是否允许其他网站访问这个bucket上的资源。由于Octopress博客集成了很多插件，比如google analiycis, github等，都需要跨域加载JavaScript文件，执行JavaScript文件，所以要加入这些配置。

{% img /images/corsconfiguration.png 780 %}


第八步，下载安装[s3cmd]。[s3cmd]是一款操作AWS S3的命令行工具。通过它可以创建或删除bucket，上传或下载object，我们在部署octopress博客时，主要就是通过它来将博客上传到S3上去。如果是mac系统化可以通过HomeBrew直接安装。

```bash

# brew install s3cmd

```

如果是windows系统可以从[官网](http://s3tools.org/s3cmd )下载安装包进行安装。

第九步，配置[s3cmd]与你的S3的连接。在命令行下输入`s3cmd --configure`，按照向导来配置与S3的连接。这时候在前面保存的Access key就派上用场了。所有的配置信息其实都存在当前用户名下的.s3cfg文件中。你也可以随后修改这些信息。运行`s3cmd ls`来检测是否配置成功。


```bash

$ s3cmd ls #列出所有的bucket
2013-09-27 05:05  s3://huangbowen.net
2013-09-28 03:24  s3://www.huangbowen.net

```


第十步，配置Octopress支持向S3的部署。在Octopress目录下找到Rakefile文件，修改或添加下述配置。 


```xml

deploy_default = "s3"   #部署task
s3_bucket = "example.com" # bucket名称

s3_cache_secs = 3600  # header中的cache controll属性，即缓存时间，后面CloudFront要用到

```

然后添加一个新的task。

```ruby

desc "Deploy website via s3cmd"
task :s3 do
  puts "## Deploying website via s3cmd"
  ok_failed system("s3cmd sync --acl-public --reduced-redundancy --add-header \"Cache-Control: max-age=#{s3_cache_secs}\"  public/* s3://#{s3_bucket}/")
end

```


OK，大功告成，运行`rake generate`
及` && rake deploy`就可以将生成的静态站点上传到S3中区。然后就可以通过S3的EndPoint来访问新站点了。（EndPoint可以在Amazon management console的S3 dashboard的
‘Static Website Hosting’ 标签中找到）

当然现在还不能使用自己的域名来访问，你可以通过配置CNAME来启用自己的域名。

下篇文章会讲如何将CloudFront作为内容分发，并且如何将自己的域名与CloudFront绑定。

现在我的博客已经在云端了，地址是<http://www.huangbowen.net>


[Octopress]: http://octopress.org/

[s3cmd]: http://s3tools.org/s3cmd


