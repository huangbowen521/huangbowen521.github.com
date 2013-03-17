---
layout: post
title: "避免每次输入bundler exec命令"
date: 2013-02-04 00:24
comments: true
categories: 编程开发
tags: ruby rvm bundler
---

bundle在ruby的世界里是个好东西，它可以用来管理应用程序的依赖库。它能自动的下载和安装指定的gem，也可以随时更新指定的gem。

[rvm](https://rvm.io/)则是一个命令行工具，能帮助你轻松的安装，管理多个ruby环境。每个环境可以指定一系列的gem。它允许你为每一个项目指定其ruby的版本，需要的gem的版本。这能最大限度的避免由于ruby环境的差异，或者不同版本的gem造成的各种问题。

当我在项目中引入了rvm后，使用rake命令时，每次都会出现这样的异常。

```bash
rake aborted!
You have already activated rake 10.0.0, but your Gemfile requires rake 0.9.2.2. Using bundle exec may solve this.
/usr/local/rvm/gems/ruby-1.9.3-p194/gems/bundler-1.2.3/lib/bundler/runtime.rb:31:in `block in setup'
/usr/local/rvm/gems/ruby-1.9.3-p194/gems/bundler-1.2.3/lib/bundler/runtime.rb:17:in `setup'
/usr/local/rvm/gems/ruby-1.9.3-p194/gems/bundler-1.2.3/lib/bundler.rb:116:in `setup'
/usr/local/rvm/gems/ruby-1.9.3-p194/gems/bundler-1.2.3/lib/bundler/setup.rb:7:in `<top (required)>'
/Users/twer/sourcecode/octopress/Rakefile:2:in `<top (required)>'
(See full trace by running task with --trace)
```

<!-- more -->

从这个异常中我们可以看到，由于我在自己机器上已经安装了rake的`10.0.0`版本，但是这个项目中配置的rake版本却是`0.9.2.2`，所以在执行rake命令时应该使用Gemfile的。

而`bundle exec`可以在当前bundle的上下文中执行一段脚本。通过它可以调用本项目中指定的rake版本来执行命令。

下面是官方文档的说明。

>In some cases, running executables without bundle exec may work, if the executable happens to be installed in your system and does not pull in any gems that conflict with your bundle. However, this is unreliable and is the source of considerable pain. Even if it looks like it works, it may not work in the future or on another machine.

所以我们只要每次执行命令的时候加上`bundle exec`的前缀就可以额。但是这样搞的很烦人，试想每天都要敲上百次这样的字符，而且还常常忘记。

有一个方法可以避免每次都要键入`bundle exec`作为前缀。

安装[rubygems-bundler](https://github.com/mpapis/rubygems-bundler)。
```bash
$ gem install rubygems-bundler
```
然后运行：
```bash
$ gem regenerate_binstubs
```

启用RVM hook:
```bash
$ rvm get head && rvm reload
$ chmod +x $rvm_path/hooks/after_cd_bundler
```
为自己的项目创建bundler stubs.
```bash
$ cd your_project_path
$ bundle install --binstubs=./bundler_stubs
```

最后重新打开terminal就可以直接执行ruby命令，不需要加上`bundler exec`前缀。

如果想禁用次bundler的话，只需要在命令前面加上`NOEXEC_DISABLE=1`前缀。更详细的信息可以看[rubygems-bundler]的[文档](https://github.com/mpapis/rubygems-bundler)。



