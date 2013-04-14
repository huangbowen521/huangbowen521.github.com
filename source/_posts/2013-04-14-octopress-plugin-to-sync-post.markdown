---
layout: post
title: 一款Octopress插件用于同步博客到其他站点
date: 2013-04-14 22:05
comments: true
categories: plugin
tags: [plugin, octopress, sync]
---

即使用octopress写博客又需要同步到其他站点的同学们有福了。本人写了一个octopress下的插件，用于将octopress中的最新的一篇博客同步到支持MetaWeblog API的博客站点中去。（wordpress、博客园、CSDN、51CTO、新浪、网易......）

这款插件源码被host在github上，地址是https://github.com/huangbowen521/octopress-syncPost。

<!-- more -->

下面介绍下如何配置和使用。

## 配置

1. 迁出源码，将源码里的_custom文件夹及其里面的文件拷贝到你的octopress根目录中。

2. 在Gemfile中加入这两个依赖.

	```ruby
	  gem 'metaweblog', '~> 0.1.0'
	  gem 'nokogiri', '~> 1.5.9'
	```
	(The first gem is used to send post with MetaWeblog API.
	The second gem is used to parse html.)

	然后在终端下运行`bundle install` 安装这两个Gem.

3. 在_config.yml文件中加入MetaWeblog的配置。

	```xml

	# MetaWeblog
	MetaWeblog_username: *YOURUSERNAME*
	MetaWeblog_password: *YOURPASSWORD*
	MetaWeblog_url: *YOURBLOGMETAWEBLOGURL*
	MetaWeblog_blogid: *BlogID*  //can be any number

	``` 
下面是配置[cnblogs]的一个示例。

	```xml

	# MetaWeblog
	MetaWeblog_username: huang0925
	MetaWeblog_password: XXXXXXXXXX
	MetaWeblog_url: http://www.cnblogs.com/huang0925/services/metaweblog.aspx
	MetaWeblog_blogid: 145005

	```

4. 在Rakefile加入这个task。

	```ruby

	desc "sync post to MetaWeblog site"
	task :sync_post do
	  puts "Sync the latest post to MetaWeblog site"
	  system "ruby _custom/sync_post.rb"
	end

	```

## 如何使用

1. 运行 `rake generate` 生成最新的站点文件。

2. 运行 `rake sync_post` 将最新的一篇博客同步到你的站点。

**请注意:** 

1. 发布完后请检查image的链接是否正确（如果原博客使用的image链接是相对路径则需要进行修正）。

2. 一些站点需要你启用MetaWeblog功能。（如[cnblogs]的管理页面有这个设置选项。）

## 如何保持相应的样式。

使用[cnblogs]作为一个例子.

1. 将你的octopress中的screen.css通过博客园提供的文件管理上传到博客园中.

2. 在博客设置中的'页首html代码'中加入对screen.css文件的使用.


## 一些支持MetaWeblog API的站点.

* Wordpress

	If your WordPress root is http://example.com/wordpress/, then you have:
	Server: http://example.com/ (some tools need just the 'example.com' hostname part)
	Path: /wordpress/xmlrpc.php
	complete URL (just in case): http://example.com/wordpress/xmlrpc.php

* 51CTO.com

	URL：http://<yourBlogUrl>/xmlrpc.php（example: http://magong.blog.51cto.com/xmlrpc.php）

* 博客大巴

	URL：http://www.blogbus.com/<accountName>/app.php（example: http://www.blogbus.com/holly0801/app.php

* CSDN

	URL：http://hi.csdn.net/<accountName>/services/metablogapi.aspx（example: http://hi.csdn.net/bvbook/services/metablogapi.aspx）

* 博客园

	URL：http://www.cnblogs.com/<accountName>/services/metaweblog.aspx（example: http://www.cnblogs.com/bvbook/services/metaweblog.aspx）

* 网易

	URL: http://<accountName>.blog.163.com/ (example: http://huang0925.blog.163.com/).

[cnblogs]: http://www.cnblogs.com/
