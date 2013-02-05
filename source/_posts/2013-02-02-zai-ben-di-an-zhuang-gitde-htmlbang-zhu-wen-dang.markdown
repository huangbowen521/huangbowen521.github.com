---
layout: post
title: "在本地安装git的HTML帮助文档"
date: 2012-08-08 00:48
comments: true
categories: 编程开发
tags: git HTML 帮助文档
---

当我们想查询git某条指令如何使用时，[git](http://git-scm.com/documentation)官网有详尽的文档供我们查看。在命令行下我们也可以随时通过 git --help的方法查看某条命令的详细帮助。

相对于在Terminal中内置的帮助文档，HTML格式更清晰，更详尽。

但是如果我想在无法上网的情况下也能查看git官网的详尽的帮助文档，有没有办法那？当然有了，下面就教大家如何在本机搭建git的HTML帮助文档。

在Windows上设置很简单，主需要安装[Msysgit](http://code.google.com/p/msysgit/),就会自动为你设置起本地的HTML帮助文档。所以这篇文章主要讲在Mac和Linux下该如何实现。


**一，运行git help –-web commit查看git默认的保存html文件的路径。**

```bash
$ git help --web commit

#Attempt to open the html help for the commit command

#fatal: '/usr/local/git/share/doc/git-doc': not a documentationdirectory.
```


我们得到了git默认的存放html文件的路径是`/usr/local/git/share/doc/git-doc`。当然你得到的路径有可能和这个不一样。

**二，切换到这个路径下，迁出存放在git repo中的html文件。**

```bash
$ sudo mkdir -p /usr/local/git/share/doc
# Create the path for the docs to be installed to cd #/usr/local/git/share/doc
$ sudo git clone git://git.kernel.org/pub/scm/git/git-htmldocs.git git-doc
# Clone the git repo and check out the html documents branch
```

**三，运行 vim ~/.gitconfig 命令，在.gitconfig文件中加入如下配置。**

```xml
[help]

        format = web

[web]

        browser = open
```

当然也可以使用其他的编辑器来编辑.gitconfig文件。

只要这三步就设置起了本地的HTML帮助文档。你可以再次运行`git help -–web commit`，就可以查看在浏览器中自动打开的HTML帮助说明页面了。

如果git的帮助文档更新了，如何同步到本地那？很简单，运行`git pull`命令就行。

```bash
$ cd /usr/local/git/share/doc/git-doc
$ sudo git pull
```

如何查看这些帮助文档那？更简单了，例如：

```bash
$ git remote --help
```

就会自动在浏览器中打开针对remote的帮助文档。