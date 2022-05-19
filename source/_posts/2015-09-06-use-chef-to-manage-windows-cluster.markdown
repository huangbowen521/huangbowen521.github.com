---
layout: post
title: 使用Chef管理windows集群
date: 2015-09-06 12:06:23 +0800
comments: true
categories: Chef
---

但凡服务器上了一定规模（百台以上），普通的ssh登录管理的模式就越来越举步维艰。试想Linux发布了一个高危漏洞的补丁，你要把手下成百上千台机器都更新该补丁，如果没有一种自动化方式，那么至少要耗上大半天时间。虽然你编写了大量的shell（或python，perl）脚本来实现各种自动化场景，但最后会发现你又陷入了脚本的汪洋大海之中，管理和维护这么多的脚本的成本也不小。你需要一款基础设施自动化工具，希望它能具有以下功能。

<!-- more -->

1. **批量执行。**这个不多说了吧，试想要为每一台机器打补丁的情形吧。

2. **任务编排。**现在稍微复杂点的应用都需要N台服务器来部署，而部署的过程中肯定有个先后的依赖顺序。那么由此看来任务编排肯定必不可少。

3. **对业务场景的抽象，也就是DSL化。**之所以抛弃自己用shell(或其它语言的)脚本来实现各种自动化的原因之一就是这些脚本很难懂，除了你以外其他人几乎无法修改。而作为一个成熟的工具，自然对咱们复杂的应用场景要做抽象，比如对服务器节点、角色的抽象，对服务器上的各种安装、配置操作的抽象，对不同环境的抽象等。通过抽象出来的DSL，大家很容易达成一致，协同工作。

4. **安全机制。**既然是基础设施自动化工具，免不了包含各种敏感信息，如何去敏也是挺重要的。而且既然能控制整个服务器集群，控制方式也要绝对安全。

除了这几个基本功能以外，当然我们还希望有更多功能，比如脚本重用、审计功能、完善的文档等。这里就不多说了。

类似的工具肯定已经有了，现在市场上比较流行的开源软件有Puppet、Chef、Ansible、SaltStack等。关于它们的优劣不是这篇文章的重点。

而谈起集群管理，大家似乎默认的都是对Linux系统集群的管理，对于Windows集群则很少涉及。我想这大抵有两方面的原因，一方面是大部分公司中机器集群类型大都是Linux系统，另一方面是Windows机器在批量化管理方面天然有缺陷，比如缺乏各种方便的脚本命令、很难对机器配置完全脚本化等。但对Windows集群的管理问题无法回避，因为在企业中Windows集群的确存在。微软也在致力改善这些问题，比如Window PowerShell就是为了解决校本化的问题。

而笔者的上一个项目就涉及对数百台Windows和Linux集群的管理。Windows集群的主要操作系统是Windows Server 2008，Linux集群的主要操作系统是Ubuntu 12.04。要实现对这样的集群的自动化配置和管理，笔者积累了一些经验，特意分享给大家。

## 自动化工具的选型

凡是牵扯到工具选型的时候，如果你发现你处于一个非常纠结的地位，那可能是因为竞品工具没有一个能突出重围，导致你在它们各自的优缺点之间难以取舍。我也理解，工具选型要考虑的因素太多。这个项目的选型其实没经过太大波折，很快就决定使用Chef。原因我可以简单说一下，Puppet的API太不友好，ansible和salt对windows的支持程度未知，而根据我以前的经验，Chef对windows的支持还是比较成熟的。所以我们就快刀斩乱麻选择了Chef。

## 搭建Chef生态环境

既然决定了Chef，那么接下来很多问题都不得不考虑。

### 使用自建的Chef Server

原因很简单，因为客户不会把自己的node暴露在公共的chef server之上。所以我们在企业内网搭建了一个Chef server，放置在一台ubuntu机器上。

### workstation选择windows机器(windows 7)

考虑到我们要同时管理Linux集群和Windows集群，所以workstation的选择也很重要。在bootstrap一个node的时候，workstation和linux node的通讯方式是ssh，而和windows node的通讯方式是通过WinRM。如果使用Linux通过WinRM和Windows系统通讯，理论上是可行的，我们可以借助一些第三方工具实现，但过程肯定比较曲折。而如果使用Windows机器和Linux及Windows系统通讯，则没有太大问题。

### 搭建自己的软件仓库

对于Linux系统而言有很多成熟的包管理工具，想要安装什么软件基本上一条命令即可。而对于Windows系统而言，虽然有[chocolatey](https://chocolatey.org/)之类的工具，但在分发一些企业内部的软件方面仍捉襟见肘。所以我们选择搭建自己的软件仓库。刚开始为了简便起见就搭建了一个ftp服务器作为软件仓库。后期会考虑迁移到[Sonatype Nexus](http://www.sonatype.com/nexus/product-overview)之类能提供更多功能的包管理服务器上去。

创建Chef repo并纳入源代码管理之类的事情由于没有太多特殊性，所以这里就不展开了。

## 应用Chef管理windows集群

使用Chef来管理windows集群肯定没有像管理Linux集群那么容易，以下是几个需要注意的点。

### 配置Windows node开启WinRM服务

WinRM服务是微软提供的用于进行远程通讯的服务（Windows 7及以后的系统内置支持），你可以简单理解为Windows版的SSH。在Windows server 2008 R2操作系统中，WinRM服务默认是关闭的，我们需要启用它。首先需要修改两个组策略。在组策略的计算机配置->策略->Windows组件->Windows远程管理(WinRM)->WinRM服务中，选择“允许自动配置监听器”，把该策略选为启用，并修改IPv4和IPv6过滤器为*。然后在控制面板中选择windows防火墙，单击例外选项卡，选择Windows 远程管理复选框。如果看不到该复选框，请单击添加程序以添加 Windows 远程管理。
（具体请参见[http://www.briantist.com/how-to/powershell-remoting-group-policy/](http://www.briantist.com/how-to/powershell-remoting-group-policy/)）

这两项的配置也可以通过PowerShell脚本来实现。想要了解的可以参见这篇文章[https://powertoe.wordpress.com/2011/05/16/enable-winrm-with-group-policy-but-use-powershell-to-create-the-policy/](https://powertoe.wordpress.com/2011/05/16/enable-winrm-with-group-policy-but-use-powershell-to-create-the-policy/)。

然后就可以启用和配置WinRM了。只需要在PowerShell终端输入`winrm quickconfig -q`即可。另外Chef还推荐对WinRM进行一些进阶配置，具体请参见[https://github.com/Chef/knife-windows#requirementssetup](https://github.com/Chef/knife-windows#requirementssetup)。


### 使用windows cookbook

[windows](https://github.com/opscode-cookbooks/windows) cookbook是Chef专为windows平台写的cookbook。里面包含了非常多的针对windows平台特性的功能，是操纵windows平台不可或缺的利器。比如解压缩文件、执行batch(PowerShell)命令、安装认证、安装卸载windows包、配置执行计划任务......

使用方式也很简单，安装可以通过chef的supermarket执行，具体参见[https://supermarket.chef.io/cookbooks/windows#knife](https://supermarket.chef.io/cookbooks/windows#knife)。如果在其它cookbook需要使用该cookbook的模块，只需在其它cookbook的metadata.rb中加入`depends ‘windows’`即可。

### 升级Windows node上的PowerShell版本

PowerShell之于Windows就相当于shell之于Linux。Windows Server 2008 R2上的PowerShell默认版本是3.0，最好能够升级到高级版本。而[https://github.com/opscode-cookbooks/powershell](https://github.com/opscode-cookbooks/powershell)中的cookbook则可以方便的对Windows node的PowerShell进行升级和配置,以及安装各种PowerShell module，执行PowerShell脚本等。

### 实现对软件的静默安装

Linux上的每种软件基本都有通过命令行静默安装的方式。而Windows下的软件却不尽然。如果软件是以.msi方式打包的，那么可以使用Windows Installer来实现静默安装。如果是以.exe的方式来打包的，倒也不被惊慌，可以仔细分析其是否是以inno、NSIS、installshield等方式打包的，然后根据各自方式的静默方式实现自动化安装。如果以上皆不适用，则可以分析该软件是否为绿色软件，尝试把安装后的整个文件夹打包放置于软件仓库之上，以后安装只需要解压缩即可。如果软件既没有规范的打包方式，也不是绿色软件，那么就比较麻烦了，需要分析安装后创建了那些文件，以及执行了那些脚本，然后尝试把这些操作命令行化（不过这样的软件非常少，不必过于担心）。

### 使用push jobs功能

通常我们需要对节点进行批量化操作，而通过chef-client的方式功能有限。chef提供了push jobs这样的扩展功能，允许我们对节点进行随心所欲的批量操作。详情请参见[https://docs.chef.io/push_jobs.html](https://docs.chef.io/push_jobs.html)。

### 熟练使用PowerShell脚本

之前我说过，PowerShell在Windows上的地位就如同Shell在Linux上的地位。Windows PowerShell提供了对COM组建和WMI组件的完全访问，而且可以轻松调用.net framework框架中的功能，而且也包含强大的文档。如果你想配置一个DHCP服务器，或者配置一个IIS网站服务，抑或修改注册表，使用PowerShell能轻松让你达到目标，彻底摆脱图形化界面。

-------------------------

总体来说，Chef对于Windows平台的支持力度还是相当完善的，如果你想实现对Windows集群的自动化管理，那么Chef不失为一种可行的方案。至于其它几种自动化工具，笔者有时间也会进行深入调研，再出具报告。











