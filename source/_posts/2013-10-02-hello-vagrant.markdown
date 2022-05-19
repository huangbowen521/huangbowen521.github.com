---
layout: post
title: "hello Vagrant"
date: 2013-10-02 23:50
comments: true
categories: 
---

回想以前，想要安装个虚拟机是多么的麻烦。先要费尽心机找到想要的操作系统镜像文件，然后安装虚拟化软件，按照其提供的GUI界面操作一步步创建,整个过程费时费力。但是，自从使用了Vagrant以后，咱腰不酸了，腿不痛了，一口气起5个虚拟机还不费劲。

<!-- more -->

## Vagrant是什么？

这是[官网](http://www.vagrantup.com/)上Vagrant的介绍。

> Create and Configure lightweight, reproducible, and portable development environments.

即用来创建和配置轻量级、可重现的、便携式的开发环境。

使用Vagrant可以将创建虚拟机的整个过程自动化起来,并具有高度的重用性。假如你是个开发者，你可以很容易为每个团队成员创建一模一样的开发环境，从根本上防止‘在我的机器上可以工作’之类的bug。假如你是个测试人员，可以一键创建多个一模一样的测试环境并行跑测试，并且跑完测试后还可以一键销毁这些测试环境，达到真正的按需创建。如果你是devops成员，需要和AWS、Chef之类的工具打交道，那么Vagrant是个很好的结合点。你可以通过Vagrant在AWS上直接创建虚拟机，并且自动运行Chef的脚本配置你的新虚拟机。

## 几个概念

正式介绍Vagrant功能之前先了解一下Vagrant使用的一些概念。

* Provider - 供应商，在这里指Vagrant调用的虚拟化工具。Vagrant本身并没有能力创建虚拟机，它是调用一些虚拟化工具来创建，如VirtualBox,VMWare，甚至AWS。

* Box - 可被Vagrant直接使用的虚拟机镜像文件。针对不同的Provider，Box文件的格式是不一样的。

* Vagrantfile - Vagrant根据Vagrantfile中的配置来创建虚拟机。在Vagrantfile文件中你需要指明使用哪个Box,需要预安装哪些软件，虚拟机的网络配置等。


## Vagrant的安装

安装Vagrant非常简单，可以在[Downloads](http://downloads.vagrantup.com/ )页面选择最新的版本安装。Vagrant支持Windows、Linux、Mac等平台。

## Box管理

使用Vagrant之前先要给Vagrant添加Box，也就是可供Vagrant使用的虚拟机镜像文件。Vagrant官网本身维护了一些镜像文件，我们可以直接使用。<http://www.vagrantbox.es/>上面有更多的box可以供我们使用。 

```bash

#添加名为precise32的box文件
 $ vagrant init precise32 http://files.vagrantup.com/precise32.box
$ vagrant box list
precise32 (virtualbox)

$ vagrant box remove precise64 virtualbox

```

可以看到Box与Provider是相关的，每个Box都必须指定Provier，只有使用对应的Provier才能正确使用Box。

## 创建并运行虚拟机

```bash

$ vagrant box list
precise32 (virtualbox)
$ vagrant init precise32
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.
$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
[default] Importing base box 'precise32'...
[default] Matching MAC address for NAT networking...
[default] Setting the name of the VM...
[default] Clearing any previously set forwarded ports...
[default] Creating shared folders metadata...
[default] Clearing any previously set network interfaces...
[default] Preparing network interfaces based on configuration...
[default] Forwarding ports...
[default] -- 22 => 2222 (adapter 1)
[default] Booting VM...
[default] Waiting for machine to boot. This may take a few minutes...
[default] Machine booted and ready!
[default] Mounting shared folders...
[default] -- /vagrant


```

`vagrant init precise32`会在当前目录下生成一个Vagrantfie文件，其使用precise32作为box。`vagrant up`则是使用virtual box这个provider来初始化并启动precise32这个虚拟机。

我们可以详细的看看Vagrantfile这个文件。

```ruby Vagrantfile

# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API及语法版本
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # 使用的box
  config.vm.box = "precise32"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network :forwarded_port, guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network :private_network, ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network :public_network

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file precise32.pp in the manifests_path directory.
  #
  # An example Puppet manifest to provision the message of the day:
  #
  # # group { "puppet":
  # #   ensure => "present",
  # # }
  # #
  # # File { owner => 0, group => 0, mode => 0644 }
  # #
  # # file { '/etc/motd':
  # #   content => "Welcome to your Vagrant-built virtual machine!
  # #               Managed by Puppet.\n"
  # # }
  #
  # config.vm.provision :puppet do |puppet|
  #   puppet.manifests_path = "manifests"
  #   puppet.manifest_file  = "site.pp"
  # end

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  # config.vm.provision :chef_solo do |chef|
  #   chef.cookbooks_path = "../my-recipes/cookbooks"
  #   chef.roles_path = "../my-recipes/roles"
  #   chef.data_bags_path = "../my-recipes/data_bags"
  #   chef.add_recipe "mysql"
  #   chef.add_role "web"
  #
  #   # You may also specify custom JSON attributes:
  #   chef.json = { :mysql_password => "foo" }
  # end

  # Enable provisioning with chef server, specifying the chef server URL,
  # and the path to the validation key (relative to this Vagrantfile).
  #
  # The Opscode Platform uses HTTPS. Substitute your organization for
  # ORGNAME in the URL and validation key.
  #
  # If you have your own Chef Server, use the appropriate URL, which may be
  # HTTP instead of HTTPS depending on your configuration. Also change the
  # validation key to validation.pem.
  #
  # config.vm.provision :chef_client do |chef|
  #   chef.chef_server_url = "https://api.opscode.com/organizations/ORGNAME"
  #   chef.validation_key_path = "ORGNAME-validator.pem"
  # end
  #
  # If you're using the Opscode platform, your validator client is
  # ORGNAME-validator, replacing ORGNAME with your organization name.
  #
  # If you have your own Chef Server, the default validation client name is
  # chef-validator, unless you changed the configuration.
  #
  #   chef.validation_client_name = "ORGNAME-validator"
end

```

从上述的文件可以看出Vagrantfile可以配置很多东西，比如使用的Box，需要转发的端口，同步指定的目录，使用Chef、puppet等对虚拟机进行预配置等。

如果修改了Vagrantfile中的配置，只需要执行`vagrant reload`来应用新配置。

## 同步目录

虚拟机启动起来以后就可以ssh上去了。

```bash

$ vagrant ssh
Welcome to Ubuntu 12.04 LTS (GNU/Linux 3.2.0-23-generic-pae i686)

 * Documentation:  https://help.ubuntu.com/
Welcome to your Vagrant-built virtual machine.
Last login: Wed Oct  2 09:41:08 2013 from 10.0.2.2
vagrant@precise32:~$ who
vagrant  pts/0        2013-10-02 09:47 (10.0.2.2)
vagrant@precise32:~$ hostname
precise32
vagrant@precise32:~$

```

Vagrant会自动给虚拟机根目录下创建一个名为vagrant的目录。这个目录可以与主机Vagrantfile所在的目录保持同步。这个同步是相互的，无论改动了主机目录中的文件，还是虚拟机目录中的文件，都可以自动同步到另一方。

```bash

vagrant@precise32:~$ cd /vagrant/
vagrant@precise32:/vagrant$ ls
Vagrantfile
vagrant@precise32:/vagrant$ touch test.txt
vagrant@precise32:/vagrant$ exit
logout
Connection to 127.0.0.1 closed.
$ ls
Vagrantfile test.txt

```

## 多机器管理

其实Vagrantfile支持配置多台机器，如果你需要设置多台服务器及数据库环境，可以用一个Vagrantfile搞定。

```ruby Vagrantfile

Vagrant.configure("2") do |config|  config.vm.provision "shell", inline: "echo Hello"  config.vm.define "web" do |web|    web.vm.box = "apache"  end  config.vm.define "db" do |db|    db.vm.box = "mysql"  end 
end

```

这个文件配置了两个box，一个叫web，一个叫db。现在启动虚拟机就需要加上虚拟机名了。

```bash

#启动web虚拟机
$ vagrant up web

#启用db虚拟机
$ vagrant up db

#默认启动所有的虚拟机
$ vagrant up 

```

## 关闭虚拟机

Vagrant提供了好几种方法来关闭虚拟机，你可以根据不同的情况选择不同的方式。

`vagrant suspend`将虚拟机置于休眠状态。这时候主机会保存虚拟机的当前状态。再用`vagrant up`启动虚拟机时能够返回之前工作的状态。这种方式优点是休眠和启动速度都很快，只有几秒钟。缺点是需要额外的磁盘空间来存储当前状态。

`vagrant halt`则是关机。如果想再次启动还是使用`vagrant up`命令，不过需要多花些时间。

`vagrant destroy`则会将虚拟机从磁盘中删除。如果想重新创建还是使用`vagrant up`命令。


另外1.2以上版本的Vagrant还引用了插件机制。可以通过`vagrant plugin`来添加各种各样的plugin，这给Vagrant的应用带来了更大的灵活性和针对性。比如可以添加`vagrant-windows`的插件来增加对windows系统的支持，通过添加`vagrant-aws`插件来实现给AWS创建虚拟机的功能。你也可以编写自己的插件。由于Vagrant是ruby写的一个gem，其插件的编写也是使用的Ruby语言。这里就不多做介绍了。感兴趣的可以去[官网](http://www.vagrantup.com/)查看。


