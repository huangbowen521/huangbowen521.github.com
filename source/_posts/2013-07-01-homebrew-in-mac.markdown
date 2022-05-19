---
layout: post
title: Homebrew- MAC上的包管理利器
date: 2013-07-01 14:33
comments: true
categories: [Homebrew]
---

{% img /images/lotsOfDogs.jpg %}

包管理器是神马东西?让我们看看[wikipedia](http://en.wikipedia.org/wiki/Package_management_system)上的介绍。

> In software, a package management system, also called package manager, is a collection of software tools to automate the process of installing, upgrading, configuring, and removing software packages for a computer's operating system in a consistent manner.


简单的来说，包管理器就是一个提供对一系列软件包的安装、卸载、升级的自动化工具。
包管理器大体分为两种，一种是管理预编译好的软件（Binary installation/Precomplied packages)，如MAC上的App Store，Windows下的Windows installer。另一种是基于源码的安装包，通过编译脚本来安装软件（Sourcecode-based installation/installing using compile scripts），如MAC上的[Homebrew]，Linux上的apt-build。

<!-- more -->

今天就给大家讲解下[Homebrew]。

[Homebrew]官网上称自己为:

> The missing package manager for OS X

即自己弥补了在OS X上无包管理器的缺陷。

## 需求环境

1. OS X 10.5及其以上版本。

2. 安装XCode里的[开发者工具](https://developer.apple.com/downloads)。主要是因为开发者工具中有mac下的gcc编译器，很多软件需要它。

3. ruby。[Homebrew]使用ruby写的，所以ruby不可或缺。

## 安装[Homebrew]

只需要在terminal下敲这样一行代码就行。

```bash

ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"

```

brew会被默认安装到/usr/local文件夹中。从上述命令可以看出homebrew是基于ruby的一款包管理器，并且host在github上。

## 使用

在[Homebrew]中支持安装的软件被称为Formula。 

* 查看所有支持的Formual。可以在[这里](https://github.com/mxcl/homebrew/tree/master/Library/Formula/)查看。如果不能上网的话可以通过`brew server`来在本地开启一个server来查看。

* `brew search [Formula]`, 搜索某个Formula是否被支持。 

* `brew install [Formula]`, 安装某个Formula。

* `brew upgrade [Formula]`, 升级某个Formula。

* `brew uninstall [Formula]`, 删除某个Formula。

* `brew update`, 更新brew支持的Formula列表。

所有的软件都会默认被安装到`/usr/local/Cellar`目录下，然后将部分可执行脚本文件通过软链接链接到`/usr/local\bin`目录下，这样我们就可以在Terminal下使用这些软件。

[Homebrew]对于Formula的管理是基于git的。你可以在`/usr/local/`下发现有一个`.git`的文件夹。通过查看`.git`目录下的`config`文件，可以知道其实目录是被链接到github上的一个repository。

```xml config

[core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
        ignorecase = true
        autocrlf = false
[remote "origin"]
        url = https://github.com/mxcl/homebrew.git
        fetch = +refs/heads/*:refs/remotes/origin/*

```



你也可以为自己的软件加入到[Homebrew]的支持列表中。只需要写一个ruby脚本check in到其[github](https://github.com/mxcl/homebrew)中。
下面是一个脚本示例。

```ruby

require 'formula'

class Wget < Formula
  homepage 'http://www.gnu.org/wget/'
  url 'http://ftp.gnu.org/wget-1.12.tar.gz'
  md5 '308a5476fc096a8a525d07279a6f6aa3'

  def install
    system "./configure --prefix=#{prefix}"
    system 'make install'
  end
end

```

当然[Homebrew]接收这些软件也是有一定条件的，可以看[这个文档](https://github.com/mxcl/homebrew/wiki/Acceptable-Formulae)。

[Homebrew]: http://mxcl.github.io/homebrew/

