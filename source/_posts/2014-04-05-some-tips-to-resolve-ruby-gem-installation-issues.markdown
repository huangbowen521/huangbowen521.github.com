---
layout: post
title: 使用ruby过程中遇到安装gem失败的一些通用解决方案
date: 2014-04-05 21:45:31 +1000
comments: true
categories: ruby
---


ruby语言升级还是比较勤快的。但是数量众多的版本使得程序库的兼容性成了大问题。有些gem表示明确不支持某个特定版本以前的ruby，而有些gem则与较高的版本不兼容。再加上gem本身也有版本，简直是乱成了一锅粥。即使使用了rvm、rbenv之类ruby版本管理工具也避免不了掉入坑中。并且时不时的一些其它环境设置也给你捣乱。所以一般使用ruby程序时，对升级ruby版本或各种gem版本都是比较慎重的，避免一时手贱掉入坑中。

<!-- more -->

当然你也不能因此就做缩头乌龟，某些情况下还是不得不升级的。比如想使用ruby或gem新版本的特性。而我本人无论使用什么软件都喜欢升级到最新版本，ruby程序也不例外。时间久了栽的次数多了也慢慢摸索出了一些经验。这里分享一下，希望大家都能避免这些坑，大胆的升级。

由于本人使用的操作系统是mac，所以这些tips都是基于MAC系统的。

当运行ruby脚本或者bundle install时，出错了首先一定要仔细看错误日志。如果有明确的出错日志，自己能解决的就可以着手解决，不知如何解决的可以选取关键词google之，一般也能找到解决方案。怕就怕google一圈以后还是不知如何是好。那么可以尝试下下面的几种方法。


## 升级ruby的小版本。

首先将当前的rvm升级到最新版本。

```bash

$ rvm get stable

```

然后查看当前使用的ruby版本和服务端可用的ruby版本。

```bash

$ rvm list

$ rvm list known

```

虽然不打算升级ruby主版本，但是小版本是可以尝试升级下，看是否能解决问题。比如当前你的ruby使用的是ruby-1.9.3-p448，但是查看到目前可用的1.9.3最新版本为ruby-1.9.3-p545。那么可以尝试切换到这个新版本下看能否解决问题。

```bash

$ rvm install ruby-1.9.3-p545

$ rvm use ruby-1.9.3-p545

```


## 确保Xcode及Command line developer tools为最新版本

请确保本机的Xcode的 command line developer tools已经安装并且是最新版本。把Xcode升级到最新版本以后，在命令行下输入：

```bash

$ xcode-select —install

```

这样会弹出来一个升级对话框来升级相应的软件。

## 确保GCC为最新版本

查看目前电脑的gcc的版本。

```bash

$ gcc -v

```

如果需要更新gcc的话推荐通过homebrew来更新。首先更新homebrew。

```bash

$ brew update

```

然后输入下列命令。

```bash

$ brew tap homebrew/dupes 
$ brew search gcc

```

brew会告诉你当前最新的gcc版本。例如是apple-gcc42。然后安装新版本gcc。

```bash

$ brew install apple-gcc42

```

然后查看系统是否应用了这个版本的gcc。

```bash

$ which gcc-4.2
/usr/local/bin/gcc-4.2

```

基本上以上的一些检查会解决掉一批由于ruby环境造成的问题。










