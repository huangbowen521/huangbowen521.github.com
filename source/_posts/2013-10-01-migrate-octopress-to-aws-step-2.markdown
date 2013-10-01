---
layout: post
title: 将我的博客迁移到亚马逊云端（2）
date: 2013-10-01 21:54
comments: true
categories: AWS
tags: [octopress, AWS] 
---


{% img /images/edgelocation.png %}

上篇文章中讲了将我的Octopress博客部署到亚马逊的S3上。而这篇文章则主要讲如何使用亚马逊提供的CloudFront作为内容分发并将自己的独立域名绑定到此CloudFront上。

<!-- more -->


首先，需要启用亚马逊的CloudFront。我刚开始以为只需要‘sign up’就行。但是当我在'AWS Management Console'中点击‘Services’中的CloudFront时，却得到了‘Account Blocked’错误。

{% img /images/accountblocked.png 780 %} 

这个问题很奇怪，CloudFront明明已经在' Services You're Signed Up For' list中了，但是咋个无法使用那？我只好使用gmail给Amazon客服中心发了邮件询问，结果客服中心告诉我需要使用一个business email(商业邮箱)来发送激活申请。我只好使用公司邮箱发送了申请，过了几个小时就收到了回信，告诉我已经可以使用了。

登陆'AWS Management Console'后，点击'Services'中的‘CloudFront’，就可以看到控制界面了。

{% img /images/cloudfront.png 780 %}


点击'Create Distribution'按钮，Delivery method选择Download。 Download主要针对一些html，css,js等静态文件，而Streaming则主要是一些音视频文件。

{% img /images/deliverymethod.png 780 %}

下一步，要选择Origin,即要进行内容分发的源。虽然亚马逊会自动列出你的S3 bucket，但是千万不要选。而是自己手动输入example.com这个Bucket的Endpoint(Endpoint在S3 Console的Properties标签下的Static Website hosting里看得到)。为什么不直接选S3 bucket那?这是因为当我们访问一个目录时，我们期望能返回默认的object。虽然CouldFront有个Default Root Object设置，只是对根目录起作用，对子目录不起作用。如果使用Bucket的Endpoint，再加上之前已经给该Bucket配置了Default Object，就可以解决这个问题。

{% img /images/originname.png 780 %}

在CNAMEs项中输入自己的域名，多个域名以逗号分隔。

{%img /images/alternatedomain.png 780 %}

这样子CoudFront就算配置好了。通过管理页面也可以配置Error page等。

{% img /images/cloudfrontoverview.png 780 %}


接下来，需要登录自己域名的提供商的管理后台，添加一条自己独立域名的转发，转发到这个CloudFront的Domain Name上。

{% img /images/domainnamechange.png 780 %}

一般需要10分钟到2个小时等待新的域名转发设置生效。

另外要专门提一下CloudFront的cache机制。CloudFront主要通过检测Origin中的http header中的cache-control属性。根据cache-control的值来设置cache时间。但是CloudFront最长只保留24小时的cache，过后就会清空并重新cache。对于我的小博客来说24小时太长了，那如何给Octopress注入cache-control这个http header那？其实在上篇文章已经提过了。S3支持给每个object设置 http header，我们可以通过s3cmd来自动设置，这就是为什么在S3 task中要加入这个参数。

```ruby


desc "Deploy website via s3cmd"
task :s3 do
  puts "## Deploying website via s3cmd"
  ok_failed system("s3cmd sync --acl-public --reduced-redundancy --add-header \"Cache-Control: max-age=#{s3_cache_secs}\"  public/* s3://#{s3_bucket}/")
end

```


其中S3\_cache\_secs就是设置cache时间，我把它设置为3600,也就是一个小时。


至此，我的Octopress博客已经在云端了。感觉访问速度比以前快不少。以前我是部署在github pages，服务器放置在美国。现在使用了CloudFront，亚马逊会自动将请求转发到最近的CloudFront edge location。接下来我再研究下 Amazon Route 53,看看有什么好玩的。


我的博客地址: <http://www.huangbowen.net>

 








