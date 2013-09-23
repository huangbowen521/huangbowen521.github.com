---
layout: post
title: 升级ruby版本那"不堪回首的经历"
date: 2013-09-23 13:53
comments: true
categories: 编程开发
tags: [Ruby]
---



前段时间在玩Chef-一个IT基础设施自动化工具。由于Chef是由Ruby写的一个gem，那么就需要安装Ruby。当然Ruby我早就安装了，并且使用rvm来管理Ruby及Gem。本来一切看似正常，但是不会预料后面会遇到那么多的坑。

<!-- more -->

Chef本地的repo包中有一个vagrant虚拟机的模板文件，通过它可以setup一个虚拟机，然后使用Chef来操作这个节点。那么就使用vagrant命令来setup这个虚拟机把。

```bash

$ vagrant up --no-color
Vagrant failed to initialize at a very early stage:

It appears that you've ran a newer version of Vagrant on this
computer. Unfortunately, newer versions of Vagrant change internal
directory layouts that cause older versions to break. This version
of Vagrant cannot properly run.

If you'd like to start from a clean state, please remove the
Vagrant state directory: /Users/twer/.vagrant.d

Warning that this will remove all your boxes and potentially corrupt
existing Vagrant environments that were running based on the future
version.

```

console中说Vagrant版本有问题，那么就按说明删除.vagrant.d文件夹把。

```bash

$ rm -rf ~/.vagrant.d/
$ vagrant up --no-color
/Users/twer/sourcecode/chef-repo/Vagrantfile:8:in `<top (required)>': undefined method `configure' for Vagrant:Module (NoMethodError)
     from /usr/local/rvm/gems/ruby-1.9.3-p194/gems/vagrant-1.0.7/lib/vagrant/config/loader.rb:115:in `load'
     from /usr/local/rvm/gems/ruby-1.9.3-p194/gems/vagrant-1.0.7/lib/vagrant/config/loader.rb:115:in `block in procs_for_source'
     from /usr/local/rvm/gems/ruby-1.9.3-p194/gems/vagrant-1.0.7/lib/vagrant/config.rb:41:in `block in capture_configures'

```

窝里个去，又出新问题了。那好吧，看看当前ruby的版本。

```bash

$ rvm list

rvm rubies

   ruby-1.9.2-p320 [ x86_64 ]
=* ruby-1.9.3-p194 [ x86_64 ]

# => - current
# =* - current && default
#  * - default

```

试着将Ruby的版本切换到1.9.2-p320再试试。

```bash

$ rvm use ruby-1.9.2-p320
Using /usr/local/rvm/gems/ruby-1.9.2-p320
$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
[default] Setting the name of the VM...
[default] Clearing any previously set forwarded ports...
[default] Creating shared folders metadata...
[default] Clearing any previously set network interfaces...
[default] Preparing network interfaces based on configuration...
[default] Forwarding ports...
[default] -- 22 => 2222 (adapter 1)
[default] Booting VM...
[default] Waiting for VM to boot. This can take a few minutes.
[default] VM booted and ready for use!
[default] Setting hostname...
[default] Mounting shared folders...
[default] -- /vagrant

```
搞定。看来问题是当前使用的ruby的版本有问题。

老是使用旧版本也不是个事，把Ruby升级到最新版本看还有这个问题不。

```bash

$ rvm list known
# MRI Rubies
[ruby-]1.8.6[-p420]
[ruby-]1.8.7[-p374]
[ruby-]1.9.1[-p431]
[ruby-]1.9.2[-p320]
[ruby-]1.9.3[-p448]
[ruby-]2.0.0-p195
[ruby-]2.0.0[-p247]
[ruby-]2.0.0-head
ruby-head

```

看来ruby的1.9.3已经有p448了，那么就升级到p448。

```bash

$ rvm install 1.9.3
Checking requirements for osx.
Installing requirements for osx.
Updating system.
Installing required packages: libksba, openssl..........
Error running 'requirements_osx_brew_libs_install gcc libksba openssl',
please read /usr/local/rvm/log/1379843991_ruby-1.9.3-p448/package_install_gcc_libksba_openssl.log
Requirements installation failed with status: 1.

```

升级失败，那么看看log。

```bash

==> make bootstrap
configure: error: cannot compute suffix of object files: cannot compile
See `config.log' for more details.
make[2]: *** [configure-stage1-target-libgcc] Error 1
make[1]: *** [stage1-bubble] Error 2
make: *** [bootstrap] Error 2

READ THIS: https://github.com/mxcl/homebrew/wiki/troubleshooting

There were package installation errors, make sure to read the log.

Try `brew tap --repair` and make sure `brew doctor` looks reasonable.

```

通过看log是gcc编译失败，并且通过log可以看出rvm是通过homebrew来安装必备文件的。

通过一番查资料后，找到了解决办法。那就是将Xcode升级到最新版本，然后在Preference里选择Downloads标签，然后安装Command Line Tools。

{% img /images/developerTools.png 600 %}


安装完毕后再用Homebrew安装gcc49。

```bash

$ brew install gcc49
==> Downloading ftp://gcc.gnu.org/pub/gcc/snapshots/4.9-20130915/gcc-4.9-20130915.tar.bz2
Already downloaded: /Library/Caches/Homebrew/gcc49-4.9-20130915.tar.bz2
==> ../configure --build=x86_64-apple-darwin12.5.0 --prefix=/usr/local/Cellar/gcc49/4.9-20130915/gcc
==> make bootstrap
==> make install
==> Caveats
This is a snapshot of GCC trunk, which is in active development and
supposed to have bugs and should not be used in production
environment.
==> Summary
🍺  /usr/local/Cellar/gcc49/4.9-20130915: 977 files, 93M, built in 21.6 minutes

```

成功安装GCC。

继续回到安装Ruby的任务上来。由于在安装Ruby前会先安装必备文件，那么干脆直接先安装必备文件的了。

```bash

$ rvm requirements 
Checking requirements for osx.
Installing requirements for osx.
mkdir: /usr/local/rvm/log/1379829979_ruby-1.9.3-p448: Permission denied
tee: /usr/local/rvm/log/1379829979_ruby-1.9.3-p448/update_system.log: No such file or directory
tee: /usr/local/rvm/log/1379829979_ruby-1.9.3-p448/update_system.log: No such file or directory

```

我勒个去，貌似是权限问题，那么用sudo解决。

```bash

$ sudo rvm requirements

Checking requirements for osx.
Installing requirements for osx.
Updating system.
Installing required packages: libksba, openssl..........
Error running 'requirements_osx_brew_libs_install libksba openssl',
please read /usr/local/rvm/log/1379843991_ruby-1.9.3-p448/package_install_libksba_openssl.log
Requirements installation failed with status: 1.

```

又失败，看看错误日志吧。

```bash

current path: /Users/twer
command(3): requirements_osx_brew_libs_install libksba openssl
Error: No such keg: /usr/local/Cellar/libksba
Error: Cowardly refusing to `sudo brew install`
You can use brew with sudo, but only if the brew executable is owned by root.
However, this is both not recommended and completely unsupported so do so at
your own risk.
There were package installation errors, make sure to read the log.

Try `brew tap --repair` and make sure `brew doctor` looks reasonable.

```

看了日志貌似明白了，使用brew安装libksba由于加了sudo所以出问题了。那么直接在命令行使用sudo试试。

```bash

$ sudo brew install libksba
Error: Cowardly refusing to `sudo brew install`
You can use brew with sudo, but only if the brew executable is owned by root.
However, this is both not recommended and completely unsupported so do so at
your own risk.

```

窝里个去，不使用sudo吧rvm requirements执行不成功。加上sudo吧rvm requirements调用的brew install又不行。好吧，就按上面说的将brew转换到root模式。

```bash

ls -al /usr/local/bin/brew
-rwxr-xr-x  1 twer  admin  703 Mar 14  2013 /usr/local/bin/brew
$ sudo chown root:admin /usr/local/bin/brew
Password:
$ ls -al /usr/local/bin/brew
-rwxr-xr-x  1 root  admin  703 Mar 14  2013 /usr/local/bin/brew

```

OK。再执行吧。

```bash

$ sudo rvm requirements
Password:
Checking requirements for osx.
Certificates in '/usr/local/etc/openssl/cert.pem' already are up to date.
Requirements installation successful.

```

搞定。把brew再切换到原来的用户和组。

```bash

$ sudo chown twer:admin /usr/local/bin/brew

```

绕了一大圈了终于可以安装Ruby了。

```bash

$ rvm install 1.9.3
Searching for binary rubies, this might take some time.
No binary rubies available for: osx/10.8/x86_64/ruby-1.9.3-p448.
Continuing with compilation. Please read 'rvm help mount' to get more information on binary rubies.
Checking requirements for osx.
Certificates in '/usr/local/etc/openssl/cert.pem' already are up to date.
Requirements installation successful.
Installing Ruby from source to: /usr/local/rvm/rubies/ruby-1.9.3-p448, this may take a while depending on your cpu(s)...
ruby-1.9.3-p448 - #downloading ruby-1.9.3-p448, this may take a while depending on your connection...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:02 --:--:--     0Warning: Failed to create the file ruby-1.9.3-p448.tar.bz2: Permission denied
  0 9816k    0   745    0     0    320      0  8:43:34  0:00:02  8:43:32  2623
curl: (23) Failed writing body (0 != 745)
There was an error(23).
Checking fallback: http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p448.tar.bz2
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0Warning: Failed to create the file ruby-1.9.3-p448.tar.bz2: Permission denied
  0 9816k    0  3329    0     0   4578      0  0:36:35 --:--:--  0:36:35  8853
curl: (23) Failed writing body (0 != 3329)
There was an error(23).
Failed download
There has been an error fetching the ruby interpreter. Halting the installation.

```

又有错。走到这步上了，继续解决吧。经过分析貌似是下载文件有问题，可能又是权限问题。

```bash

sudo rvm install 1.9.3
Password:
Searching for binary rubies, this might take some time.
No binary rubies available for: osx/10.8/x86_64/ruby-1.9.3-p448.
Continuing with compilation. Please read 'rvm help mount' to get more information on binary rubies.
Checking requirements for osx.
Certificates in '/usr/local/etc/openssl/cert.pem' already are up to date.
Requirements installation successful.
Installing Ruby from source to: /usr/local/rvm/rubies/ruby-1.9.3-p448, this may take a while depending on your cpu(s)...
ruby-1.9.3-p448 - #downloading ruby-1.9.3-p448, this may take a while depending on your connection...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 9816k  100 9816k    0     0   422k      0  0:00:23  0:00:23 --:--:--  154k
ruby-1.9.3-p448 - #extracting ruby-1.9.3-p448 to /usr/local/rvm/src/ruby-1.9.3-p448
ruby-1.9.3-p448 - #extracted to /usr/local/rvm/src/ruby-1.9.3-p448
ruby-1.9.3-p448 - #configuring...............................................................................................................................................................................................................................................................................................................................................................................................................................................................................
ruby-1.9.3-p448 - #post-configuration
ruby-1.9.3-p448 - #compiling...............................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................
ruby-1.9.3-p448 - #installing.........................................................................................................
curl: (35) Unknown SSL protocol error in connection to rubygems.org:443
There was an error while trying to resolve rubygems version for 'latest'.
Halting the installation.

```

前面那个错没了，但是新来了一个错。貌似是ssh到rubygems.org网站有问题，突然想起在rvm requirements时安装了openssl，应该是ssl设置的问题。从网上查了下，貌似要重置macport。
```bash

$ sudo rm -rf /opt/local

$ sudo rm -rf $rvm_path/usr
$ sudo rm -rf $rvm_path/bin/port
sudo: cannot get working directory
$ sudo rvm autolibs homebrew

```

最后，再重新安装Ruby。

```bash

$ sudo rvm reinstall 1.9.3
Removing /usr/local/rvm/src/ruby-1.9.3-p448...
Removing /usr/local/rvm/rubies/ruby-1.9.3-p448...
Searching for binary rubies, this might take some time.
No binary rubies available for: osx/10.8/x86_64/ruby-1.9.3-p448.
Continuing with compilation. Please read 'rvm help mount' to get more information on binary rubies.
Checking requirements for osx_brew.
Certificates in '/usr/local/etc/openssl/cert.pem' already are up to date.
Requirements installation successful.
Installing Ruby from source to: /usr/local/rvm/rubies/ruby-1.9.3-p448, this may take a while depending on your cpu(s)...
ruby-1.9.3-p448 - #downloading ruby-1.9.3-p448, this may take a while depending on your connection...
ruby-1.9.3-p448 - #extracting ruby-1.9.3-p448 to /usr/local/rvm/src/ruby-1.9.3-p448
ruby-1.9.3-p448 - #extracted to /usr/local/rvm/src/ruby-1.9.3-p448
ruby-1.9.3-p448 - #configuring...............................................................................................................................................................................................................................................................................................................................................................................................................................................................................
ruby-1.9.3-p448 - #post-configuration
ruby-1.9.3-p448 - #compiling...............................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................
ruby-1.9.3-p448 - #installing.........................................................................................................
Retrieving rubygems-2.1.4
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  356k  100  356k    0     0  11672      0  0:00:31  0:00:31 --:--:-- 20611
Extracting rubygems-2.1.4 ...
Removing old Rubygems files...
$LANG was empty, setting up LANG=en_US, if it fails again try setting LANG to something sane and try again.
Installing rubygems-2.1.4 for ruby-1.9.3-p448............................................................................................................................................
Installation of rubygems completed successfully.
Saving wrappers to '/usr/local/rvm/wrappers/ruby-1.9.3-p448'........

ruby-1.9.3-p448 - #adjusting #shebangs for (gem irb erb ri rdoc testrb rake).
ruby-1.9.3-p448 - #importing default gemsets, this may take time.......................
Install of ruby-1.9.3-p448 - #complete
Making gemset ruby-1.9.3-p448 pristine....
Making gemset ruby-1.9.3-p448@global pristine....

```

终于安装上了。

```bash

$ rvm list

rvm rubies

   ruby-1.9.2-p320 [ x86_64 ]
 * ruby-1.9.3-p194 [ x86_64 ]
=> ruby-1.9.3-p448 [ x86_64 ]

# => - current
# =* - current && default
#  * - default

$ rvm use ruby-1.9.3-p448
$ rvm list

rvm rubies

   ruby-1.9.2-p320 [ x86_64 ]
 * ruby-1.9.3-p194 [ x86_64 ]
=> ruby-1.9.3-p448 [ x86_64 ]

# => - current
# =* - current && default
#  * - default

$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
[default] VirtualBox VM is already running.

```

终于将Ruby升级到1.9.3-p448了。回顾这整个过程，都是泪啊。本来是想装个虚拟机玩玩，哪想到惹出这么多事情来。不过好歹问题是解决了。






