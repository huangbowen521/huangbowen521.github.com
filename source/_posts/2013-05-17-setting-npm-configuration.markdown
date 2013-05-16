---
layout: post
title: npm的配置管理及设置代理 
date: 2013-05-17 00:17
comments: true
categories: JavaScript
tags: [npm, proxy]
---


npm全称为Node Packaged Modules。它是一个用于管理基于node.js编写的package的命令行工具。其本身就是基于node.js写的,这有点像gem与ruby的关系。

<!-- more -->

在我们的项目中，需要使用一些基于node.js的javascript库文件，就需要npm对这些依赖库进行方便的管理。由于我们的开发环境由于安全因素在访问一些网站时需要使用代理，其中就包括npm的repositories网站，所以就需要修改npm的配置来加入代理。

下面简要介绍下npm的配置以及如何设置代理。

## npm获取配置有6种方式，优先级由高到底。

1. 命令行参数。 `--proxy http://server:port`即将proxy的值设为`http://server:port`。

2. 环境变量。 以`npm_config_`为前缀的环境变量将会被认为是npm的配置属性。如设置proxy可以加入这样的环境变量`npm_config_proxy=http://server:port`。

3. 用户配置文件。可以通过`npm config get userconfig`查看文件路径。如果是mac系统的话默认路径就是`$HOME/.npmrc`。

4. 全局配置文件。可以通过`npm config get globalconfig`查看文件路径。mac系统的默认路径是`/usr/local/etc/npmrc`。

5. 内置配置文件。安装npm的目录下的npmrc文件。

6. 默认配置。 npm本身有默认配置参数，如果以上5条都没设置，则npm会使用默认配置参数。


## 针对npm配置的命令行操作

```bash
       npm config set <key> <value> [--global]
       npm config get <key>
       npm config delete <key>
       npm config list
       npm config edit
       npm get <key>
       npm set <key> <value> [--global]

```

在设置配置属性时属性值默认是被存储于用户配置文件中，如果加上`--global`，则被存储在全局配置文件中。


如果要查看npm的所有配置属性（包括默认配置），可以使用`npm config ls -l`。

如果要查看npm的各种配置的含义，可以使用`npm help config`。

## 为npm设置代理

```bash

$ npm config set proxy http://server:port  
$ npm config set https-proxy http://server:port
$ npm config set registry "http://registry.npmjs.org/"

```

如果代理需要认证的话可以这样来设置。

```bash

$ npm config set proxy http://username:password@server:port
$ npm config set https-proxy http://username:pawword@server:port

```











