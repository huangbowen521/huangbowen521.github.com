---
layout: post
title: 使用微博自动记录俯卧撑个数
date: 2016-02-02 10:07:42 +0800
comments: true
categories: Weibo
tags: [workout]
---

根据SMART原则我制定了2016年的目标。每个月都有一个小目标，每个目标都是specific(具体)、Measurable(可度量)、Attainable(可实现)、Relevant(相关性)、Time-bound(时限)的。1月份的目标是跑步200公里，其中包含4个半程马拉松。1月底验收的时候发现这个目标轻松达成，整个1月份我总共跑了220公里+，其中跑了4个半程马拉松。而且第二次的马拉松打破我的个人记录，成绩为1小时43分30秒，把我的个人最好成绩提高了2分钟。

<!-- more -->

{% img /images/201601_run_record.jpg 300 %}

2月份我的目标的是做4000个俯卧撑+撰写4篇技术博客。跑步的时候我可以使用跑步软件（咕咚或者悦跑圈）来记录我的跑步里程，而记录俯卧撑虽然有一些现成的软件(比如Push-Ups)，但是我感觉太重量级，想要一种轻量的方式来记录。后来我想到了一种方式，只需在命令行终端输入一条简单的命令，比如`pushups 30`，那么我的微博会自动多出来一条博文，记录我本次做了多少俯卧撑，本月已经完成了多少俯卧撑，距离目标还剩下多少俯卧撑。这样子每做完一组，我只需敲一行命令就可以轻松记录下来，并且还有广大网友进行监督。

这个主意很好，可是怎么实现那？其实整个过程并不复杂，我周末花了两个小时就完成了。新浪微博提供了一个[微博开放平台](http://open.weibo.com/wiki/%E9%A6%96%E9%A1%B5)，在微博开放平台上其开放了[一系列API](http://open.weibo.com/wiki/API%E6%96%87%E6%A1%A3)，其中发送微博就属于其中一个。我们只需把我们要发送的内容组装好，编写程序调用其发送微博的API即可。

发送微博的API文档[在这里](http://open.weibo.com/wiki/Statuses/update)。通过文档可以看出其实只要发送一个http请求，包含相应的内容就好。其中有两个字段比较重要，一个是access token，一个是status。access token是认证令牌，确定是哪个应用向哪个微博发送内容，status是需要推送的微博正文。

获取access_token的过程比较复杂，需要你了解OAuth2.0认证流程,详情请看[授权机制说明](http://open.weibo.com/wiki/%E6%8E%88%E6%9D%83%E6%9C%BA%E5%88%B6%E8%AF%B4%E6%98%8E)。简单来说就是用你的微博账号登陆微博开放平台，注册一个应用，然后得到一个应用Id，然后用该应用Id调用相应的API来授权访问你的个人微博，最后得到一个access token。

如果调用这个API那？因为之前曾经写过一个插件向微博推送我的博客信息，所以只需把相关代码拿出来重用即可。相关代码采用Ruby写的。代码如下：

```ruby WeiboPoster

require 'faraday'
require 'yaml'
require 'json'

class WeiboPoster
  def initialize
    @weibo_config = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/weibo-config.yml'))
    @pushups = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/pushups.yml'))
  end

  def post_weibo(number)
    @number = number
    conn = Faraday.new(:url => "https://api.weibo.com")

    result = conn.post '/2/statuses/update.json',
                       :access_token => @weibo_config['access_token'],
                       :status => generate_post

    responseJSON = JSON.parse result.body
    if responseJSON['error_code']
      puts 'post error:' + responseJSON['error']
    else
      puts "post to weibo successfully"
    end
  end

  private

  def generate_post

    total = get_history
    total = total + @number.to_i
    number_rest = 4000 - total

    save_to_history total
    post_template = @weibo_config['post_template'].force_encoding("utf-8")
    post_template % {:number_done => @number, :total => total,:number_rest => number_rest}
  end

  def get_history
    @pushups['total']
  end

  def save_to_history(total)
    @pushups['total'] = total
    File.open('pushups.yml','w') do |h|
    h.write @pushups.to_yaml
    end
  end
end

poster = WeiboPoster.new
poster.post_weibo ARGV[0]

```

整个逻辑就是先从一个配置文件中读出当前完成的俯卧撑个数，再配合通过命令行参数传入的当前组做的个数，结合微博模板生成微博内容，再调用API发送HTTP请求。

accecs token和微博模板存放在weibo-config.yml文件中。

```yaml weibo-config.yml

# Sina Weibo Post
access_token: YOUR_ACCESS_TOKEN
post_template: 刚才做了%{number_done}个俯卧撑，2月份总共完成了%{total}个俯卧撑，距离4000个俯卧撑目标还差%{number_rest}个
```
然后我在Rakefile中配置了一个任务，用于调用WeiboPoster类。

```ruby Rakefile

require "rubygems"
require "bundler/setup"
require "stringex"

desc "post pushups to weibo"
task :pushups, :number do |t, args|
    args.with_defaults(:number => 50)
    number = args.number
    system "ruby post_weibo.rb " + number

end

```

最后再用一个shell脚本封装一下，支持shell调用。

```bash pushups

#!/bin/sh
rake pushups[$1]

```

OK这样就齐活了。做完一组俯卧撑之后，只需在命令行输入`pushups 35`,然后就可以看到我的微博多了一篇推文。

最终效果如下。

{% img /images/weibo_pushups.png 600 %}

我的微博地址：[@无敌北瓜](http://www.weibo.com/hbw0925)
