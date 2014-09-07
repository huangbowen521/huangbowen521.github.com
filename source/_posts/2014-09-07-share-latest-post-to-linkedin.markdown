---
layout: post
title: 分享最新的博客到LinkedIn Timeline
date: 2014-09-07 18:14:16 +1000
comments: true
categories: Octopress
tags: [Octopress, LinkedIn, Plugin]
---

使用Octopress作为我的博客框架有两年了。使用起来一直很顺手，这个工具真正的把博客跟写代码等同起来，非常酷炫。再加上各种各样的定制化，简直是随心所欲。我针对自己的需求对Octopress框架进行了一些定制化，比如编写了一些插件自动将博客同步到博客园，以及部署时将博客部署到亚马逊云的S3上等。这个周末闲着无事，写了一个插件将最新的博客信息推送到LinkedIn的timeline上去。

<!-- more -->

代码已经放置到了Github上了，地址是[https://github.com/huangbowen521/octopress-linkedin](https://github.com/huangbowen521/octopress-linkedin)。

先给一张图看看效果：

{% img /images/sharesample.png %}

使用这个插件也挺简单。要做这么几步。

首先clone该repo，并复制repo里的_custom目录到你的Octopress根目录。

然后在[LinkedIn Developer Network](https://developer.linkedin.com/)上[注册一个应用程序](https://www.linkedin.com/secure/developer?newapp=)，注册完毕后在应用程序页面可以得到生成的api_key, api_secret, user_token, user_secret信息，把这些信息填到`_custom\linkedin_config.yml`文件中。

```text _custom\linkedin_config.yml

api_key: YOUR_API_KEY
api_secret: YOUR_API_SECRET
user_token: YOUR_USER_TOKEN
user_secret: YOUR_USER_SECRET

```

**注意:不要把linkedin_config.yml文件迁入到源代码管理工具中，因为这里面的数据不能泄露。**

在`Rakefile`文件中加入一个新的task。

```ruby

desc "Post the title and url of latest blog to LinkedIn"
task :linkedin do
  puts "Post the title and url of latest blog to LinkedIn"
  system "ruby _custom/post_linkedin.rb"
end

```

在`Gemfile`文件中添加一个新依赖: `gem oauth`，然后运行`bundle install`。

OK，大功告成，只需运行`rake linkedin`命名可以把最新的博客信息分享到你的LinkedIn中去。

你也可以定制化显示在LinkedIn上的信息，只需修改`_custom\linkedin.xml`文件即可。该文件的进一步解释可以参见[LinkedIn Share API文档](https://developer.linkedin.com/documents/share-api#toggleview:id=xml)。


