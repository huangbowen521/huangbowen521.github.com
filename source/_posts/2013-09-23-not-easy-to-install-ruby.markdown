<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
---
layout: post
title: 升级ruby版本那"不堪回首的经历"
date: 2013-09-23 13:53
comments: true
categories: 编程开发
tags: [Ruby]
---

=======
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">

  <title><![CDATA[Tag: ruby | 黄博文的地盘]]></title>
  <link href="http://www.huangbowen.net/blog/tags/ruby/atom.xml" rel="self"/>
  <link href="http://www.huangbowen.net/"/>
  <updated>2014-12-31T17:09:42+08:00</updated>
  <id>http://www.huangbowen.net/</id>
  <author>
    <name><![CDATA[黄博文]]></name>
    <email><![CDATA[huangbowen521@gmail.com]]></email>
  </author>
  <generator uri="http://octopress.org/">Octopress</generator>

  
  <entry>
<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
    <title type="html"><![CDATA[升级ruby版本那"不堪回首的经历"]]></title>
    <link href="http://www.huangbowen.net/blog/2013/09/23/not-easy-to-install-ruby/"/>
    <updated>2013-09-23T13:53:00+08:00</updated>
    <id>http://www.huangbowen.net/blog/2013/09/23/not-easy-to-install-ruby</id>
    <content type="html"><![CDATA[<p>前段时间在玩Chef-一个IT基础设施自动化工具。由于Chef是由Ruby写的一个gem，那么就需要安装Ruby。当然Ruby我早就安装了，并且使用rvm来管理Ruby及Gem。本来一切看似正常，但是不会预料后面会遇到那么多的坑。</p>
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml


前段时间在玩Chef-一个IT基础设施自动化工具。由于Chef是由Ruby写的一个gem，那么就需要安装Ruby。当然Ruby我早就安装了，并且使用rvm来管理Ruby及Gem。本来一切看似正常，但是不会预料后面会遇到那么多的坑。

<!-- more -->

Chef本地的repo包中有一个vagrant虚拟机的模板文件，通过它可以setup一个虚拟机，然后使用Chef来操作这个节点。那么就使用vagrant命令来setup这个虚拟机把。

<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
```bash

=======
<pre><code class="bash">
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml
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
<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown

```
=======
</code></pre>
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml

console中说Vagrant版本有问题，那么就按说明删除.vagrant.d文件夹把。

<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
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

=======
<pre><code class="bash">
$ rm -rf ~/.vagrant.d/
$ vagrant up --no-color
/Users/twer/sourcecode/chef-repo/Vagrantfile:8:in `&lt;top (required)&gt;': undefined method `configure' for Vagrant:Module (NoMethodError)
     from /usr/local/rvm/gems/ruby-1.9.3-p194/gems/vagrant-1.0.7/lib/vagrant/config/loader.rb:115:in `load'
     from /usr/local/rvm/gems/ruby-1.9.3-p194/gems/vagrant-1.0.7/lib/vagrant/config/loader.rb:115:in `block in procs_for_source'
     from /usr/local/rvm/gems/ruby-1.9.3-p194/gems/vagrant-1.0.7/lib/vagrant/config.rb:41:in `block in capture_configures'
</code></pre>

<p>窝里个去，又出新问题了。那好吧，看看当前ruby的版本。</p>

<pre><code class="bash">
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml
$ rvm list

rvm rubies

   ruby-1.9.2-p320 [ x86_64 ]
=* ruby-1.9.3-p194 [ x86_64 ]

<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
# => - current
# =* - current && default
#  * - default

```
=======
# =&gt; - current
# =* - current &amp;&amp; default
#  * - default
</code></pre>
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml

试着将Ruby的版本切换到1.9.2-p320再试试。

<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
```bash

=======
<pre><code class="bash">
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml
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
[default] -- 22 =&gt; 2222 (adapter 1)
[default] Booting VM...
[default] Waiting for VM to boot. This can take a few minutes.
[default] VM booted and ready for use!
[default] Setting hostname...
[default] Mounting shared folders...
[default] -- /vagrant
<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown

```
搞定。看来问题是当前使用的ruby的版本有问题。
=======
</code></pre>

<p>搞定。看来问题是当前使用的ruby的版本有问题。</p>
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml

老是使用旧版本也不是个事，把Ruby升级到最新版本看还有这个问题不。

<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
```bash

=======
<pre><code class="bash">
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml
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
<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown

```
=======
</code></pre>
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml

看来ruby的1.9.3已经有p448了，那么就升级到p448。

<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
```bash

=======
<pre><code class="bash">
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml
$ rvm install 1.9.3
Checking requirements for osx.
Installing requirements for osx.
Updating system.
Installing required packages: libksba, openssl..........
Error running 'requirements_osx_brew_libs_install gcc libksba openssl',
please read /usr/local/rvm/log/1379843991_ruby-1.9.3-p448/package_install_gcc_libksba_openssl.log
Requirements installation failed with status: 1.
<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown

```
=======
</code></pre>
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml

升级失败，那么看看log。

<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
```bash

==> make bootstrap
=======
<pre><code class="bash">
==&gt; make bootstrap
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml
configure: error: cannot compute suffix of object files: cannot compile
See `config.log' for more details.
make[2]: *** [configure-stage1-target-libgcc] Error 1
make[1]: *** [stage1-bubble] Error 2
make: *** [bootstrap] Error 2
<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown

READ THIS: https://github.com/mxcl/homebrew/wiki/troubleshooting

There were package installation errors, make sure to read the log.

Try `brew tap --repair` and make sure `brew doctor` looks reasonable.

```

通过看log是gcc编译失败，并且通过log可以看出rvm是通过homebrew来安装必备文件的。
=======

READ THIS: https://github.com/mxcl/homebrew/wiki/troubleshooting

There were package installation errors, make sure to read the log.

Try `brew tap --repair` and make sure `brew doctor` looks reasonable.
</code></pre>
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml

通过一番查资料后，找到了解决办法。那就是将Xcode升级到最新版本，然后在Preference里选择Downloads标签，然后安装Command Line Tools。

{% img /images/developerTools.png 600 %}


安装完毕后再用Homebrew安装gcc49。

<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
```bash

$ brew install gcc49
==> Downloading ftp://gcc.gnu.org/pub/gcc/snapshots/4.9-20130915/gcc-4.9-20130915.tar.bz2
=======
<pre><code class="bash">
$ brew install gcc49
==&gt; Downloading ftp://gcc.gnu.org/pub/gcc/snapshots/4.9-20130915/gcc-4.9-20130915.tar.bz2
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml
Already downloaded: /Library/Caches/Homebrew/gcc49-4.9-20130915.tar.bz2
==&gt; ../configure --build=x86_64-apple-darwin12.5.0 --prefix=/usr/local/Cellar/gcc49/4.9-20130915/gcc
==&gt; make bootstrap
==&gt; make install
==&gt; Caveats
This is a snapshot of GCC trunk, which is in active development and
supposed to have bugs and should not be used in production
environment.
<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
==> Summary
🍺  /usr/local/Cellar/gcc49/4.9-20130915: 977 files, 93M, built in 21.6 minutes

```
=======
==&gt; Summary
🍺  /usr/local/Cellar/gcc49/4.9-20130915: 977 files, 93M, built in 21.6 minutes
</code></pre>
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml

成功安装GCC。

继续回到安装Ruby的任务上来。由于在安装Ruby前会先安装必备文件，那么干脆直接先安装必备文件的了。

<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
```bash

=======
<pre><code class="bash">
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml
$ rvm requirements 
Checking requirements for osx.
Installing requirements for osx.
mkdir: /usr/local/rvm/log/1379829979_ruby-1.9.3-p448: Permission denied
tee: /usr/local/rvm/log/1379829979_ruby-1.9.3-p448/update_system.log: No such file or directory
tee: /usr/local/rvm/log/1379829979_ruby-1.9.3-p448/update_system.log: No such file or directory
<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown

```
=======
=======
    <title type="html"><![CDATA[避免每次输入bundler exec命令]]></title>
    <link href="http://www.huangbowen.net/blog/2013/02/04/bi-mian-mei-ci-shu-ru-bundler-execming-ling/"/>
    <updated>2013-02-04T00:24:00+08:00</updated>
    <id>http://www.huangbowen.net/blog/2013/02/04/bi-mian-mei-ci-shu-ru-bundler-execming-ling</id>
    <content type="html"><![CDATA[<p>bundle在ruby的世界里是个好东西，它可以用来管理应用程序的依赖库。它能自动的下载和安装指定的gem，也可以随时更新指定的gem。</p>

<p><a href="https://rvm.io/">rvm</a>则是一个命令行工具，能帮助你轻松的安装，管理多个ruby环境。每个环境可以指定一系列的gem。它允许你为每一个项目指定其ruby的版本，需要的gem的版本。这能最大限度的避免由于ruby环境的差异，或者不同版本的gem造成的各种问题。</p>

<p>当我在项目中引入了rvm后，使用rake命令时，每次都会出现这样的异常。</p>

<pre><code class="bash">rake aborted!
You have already activated rake 10.0.0, but your Gemfile requires rake 0.9.2.2. Using bundle exec may solve this.
/usr/local/rvm/gems/ruby-1.9.3-p194/gems/bundler-1.2.3/lib/bundler/runtime.rb:31:in `block in setup'
/usr/local/rvm/gems/ruby-1.9.3-p194/gems/bundler-1.2.3/lib/bundler/runtime.rb:17:in `setup'
/usr/local/rvm/gems/ruby-1.9.3-p194/gems/bundler-1.2.3/lib/bundler.rb:116:in `setup'
/usr/local/rvm/gems/ruby-1.9.3-p194/gems/bundler-1.2.3/lib/bundler/setup.rb:7:in `&lt;top (required)&gt;'
/Users/twer/sourcecode/octopress/Rakefile:2:in `&lt;top (required)&gt;'
(See full trace by running task with --trace)
>>>>>>> 09615b67c1384817f01948313cc9bfa79d82b402:blog/tags/ruby/atom.xml
</code></pre>
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml

我勒个去，貌似是权限问题，那么用sudo解决。

<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
```bash

$ sudo rvm requirements

=======
<pre><code class="bash">
$ sudo rvm requirements

>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml
Checking requirements for osx.
Installing requirements for osx.
Updating system.
Installing required packages: libksba, openssl..........
Error running 'requirements_osx_brew_libs_install libksba openssl',
please read /usr/local/rvm/log/1379843991_ruby-1.9.3-p448/package_install_libksba_openssl.log
Requirements installation failed with status: 1.
<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown

```
=======
</code></pre>
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml

又失败，看看错误日志吧。

<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
```bash

=======
<pre><code class="bash">
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml
current path: /Users/twer
command(3): requirements_osx_brew_libs_install libksba openssl
Error: No such keg: /usr/local/Cellar/libksba
Error: Cowardly refusing to `sudo brew install`
You can use brew with sudo, but only if the brew executable is owned by root.
However, this is both not recommended and completely unsupported so do so at
your own risk.
There were package installation errors, make sure to read the log.

Try `brew tap --repair` and make sure `brew doctor` looks reasonable.
<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown

```
=======
</code></pre>
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml

看了日志貌似明白了，使用brew安装libksba由于加了sudo所以出问题了。那么直接在命令行使用sudo试试。

<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
```bash

=======
<pre><code class="bash">
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml
$ sudo brew install libksba
Error: Cowardly refusing to `sudo brew install`
You can use brew with sudo, but only if the brew executable is owned by root.
However, this is both not recommended and completely unsupported so do so at
your own risk.
<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown

```
=======
</code></pre>
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml

窝里个去，不使用sudo吧rvm requirements执行不成功。加上sudo吧rvm requirements调用的brew install又不行。好吧，就按上面说的将brew转换到root模式。

<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
```bash

=======
<pre><code class="bash">
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml
ls -al /usr/local/bin/brew
-rwxr-xr-x  1 twer  admin  703 Mar 14  2013 /usr/local/bin/brew
$ sudo chown root:admin /usr/local/bin/brew
Password:
$ ls -al /usr/local/bin/brew
-rwxr-xr-x  1 root  admin  703 Mar 14  2013 /usr/local/bin/brew
<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown

```
=======
</code></pre>
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml

OK。再执行吧。

<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
```bash

=======
<pre><code class="bash">
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml
$ sudo rvm requirements
Password:
Checking requirements for osx.
Certificates in '/usr/local/etc/openssl/cert.pem' already are up to date.
Requirements installation successful.
<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown

```
=======
</code></pre>
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml

搞定。把brew再切换到原来的用户和组。

<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
```bash

$ sudo chown twer:admin /usr/local/bin/brew

```
=======
<pre><code class="bash">
$ sudo chown twer:admin /usr/local/bin/brew
</code></pre>
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml

绕了一大圈了终于可以安装Ruby了。

<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
```bash

=======
<pre><code class="bash">
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml
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
<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown

```
=======
</code></pre>
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml

又有错。走到这步上了，继续解决吧。经过分析貌似是下载文件有问题，可能又是权限问题。

<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
```bash

=======
<pre><code class="bash">
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml
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
<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown

```
=======
</code></pre>
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml

前面那个错没了，但是新来了一个错。貌似是ssh到rubygems.org网站有问题，突然想起在rvm requirements时安装了openssl，应该是ssl设置的问题。从网上查了下，貌似要重置macport。
```bash

$ sudo rm -rf /opt/local

$ sudo rm -rf $rvm_path/usr
$ sudo rm -rf $rvm_path/bin/port
sudo: cannot get working directory
$ sudo rvm autolibs homebrew

<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
```

最后，再重新安装Ruby。

```bash

$ sudo rvm reinstall 1.9.3
Removing /usr/local/rvm/src/ruby-1.9.3-p448...
Removing /usr/local/rvm/rubies/ruby-1.9.3-p448...
=======
<pre><code>
最后，再重新安装Ruby。
</code></pre>

<p>$ sudo rvm reinstall 1.9.3
Removing /usr/local/rvm/src/ruby-1.9.3-p448&hellip;
Removing /usr/local/rvm/rubies/ruby-1.9.3-p448&hellip;
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml
Searching for binary rubies, this might take some time.
No binary rubies available for: osx/10.8/x86_64/ruby-1.9.3-p448.
Continuing with compilation. Please read &lsquo;rvm help mount&rsquo; to get more information on binary rubies.
Checking requirements for osx_brew.
Certificates in &lsquo;/usr/local/etc/openssl/cert.pem&rsquo; already are up to date.
Requirements installation successful.
Installing Ruby from source to: /usr/local/rvm/rubies/ruby-1.9.3-p448, this may take a while depending on your cpu(s)&hellip;
ruby-1.9.3-p448 - #downloading ruby-1.9.3-p448, this may take a while depending on your connection&hellip;
ruby-1.9.3-p448 - #extracting ruby-1.9.3-p448 to /usr/local/rvm/src/ruby-1.9.3-p448
ruby-1.9.3-p448 - #extracted to /usr/local/rvm/src/ruby-1.9.3-p448
ruby-1.9.3-p448 - #configuring&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;.
ruby-1.9.3-p448 - #post-configuration
ruby-1.9.3-p448 - #compiling&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;..
ruby-1.9.3-p448 - #installing&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;
Retrieving rubygems-2.1.4
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
100  356k  100  356k    0     0  11672      0  0:00:31  0:00:31 --:--:-- 20611
Extracting rubygems-2.1.4 ...
Removing old Rubygems files...
=======
100  356k  100  356k    0     0  11672      0  0:00:31  0:00:31 &ndash;:&ndash;:&ndash; 20611
Extracting rubygems-2.1.4 &hellip;
Removing old Rubygems files&hellip;
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml
$LANG was empty, setting up LANG=en_US, if it fails again try setting LANG to something sane and try again.
Installing rubygems-2.1.4 for ruby-1.9.3-p448&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;..
Installation of rubygems completed successfully.
<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
Saving wrappers to '/usr/local/rvm/wrappers/ruby-1.9.3-p448'........

ruby-1.9.3-p448 - #adjusting #shebangs for (gem irb erb ri rdoc testrb rake).
ruby-1.9.3-p448 - #importing default gemsets, this may take time.......................
Install of ruby-1.9.3-p448 - #complete
Making gemset ruby-1.9.3-p448 pristine....
Making gemset ruby-1.9.3-p448@global pristine....

```

终于安装上了。

```bash
=======
Saving wrappers to &lsquo;/usr/local/rvm/wrappers/ruby-1.9.3-p448&rsquo;&hellip;&hellip;..</p>

<p>ruby-1.9.3-p448 - #adjusting #shebangs for (gem irb erb ri rdoc testrb rake).
ruby-1.9.3-p448 - #importing default gemsets, this may take time&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;&hellip;..
Install of ruby-1.9.3-p448 - #complete
Making gemset ruby-1.9.3-p448 pristine&hellip;.
Making gemset ruby-1.9.3-p448@global pristine&hellip;.</p>

<pre><code>
终于安装上了。
</code></pre>
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml

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




<<<<<<< HEAD:source/_posts/2013-09-23-not-easy-to-install-ruby.markdown
=======
<p>$ vagrant up
Bringing machine &lsquo;default&rsquo; up with &lsquo;virtualbox&rsquo; provider&hellip;
[default] VirtualBox VM is already running.</p>
>>>>>>> b3de9a0dc5638d86b43bb607c665e95f3c151147:blog/tags/ruby/atom.xml


=======
<!-- more -->


<p>从这个异常中我们可以看到，由于我在自己机器上已经安装了rake的<code>10.0.0</code>版本，但是这个项目中配置的rake版本却是<code>0.9.2.2</code>，所以在执行rake命令时应该使用Gemfile的。</p>

<p>而<code>bundle exec</code>可以在当前bundle的上下文中执行一段脚本。通过它可以调用本项目中指定的rake版本来执行命令。</p>

<p>下面是官方文档的说明。</p>

<blockquote><p>In some cases, running executables without bundle exec may work, if the executable happens to be installed in your system and does not pull in any gems that conflict with your bundle. However, this is unreliable and is the source of considerable pain. Even if it looks like it works, it may not work in the future or on another machine.</p></blockquote>

<p>所以我们只要每次执行命令的时候加上<code>bundle exec</code>的前缀就可以额。但是这样搞的很烦人，试想每天都要敲上百次这样的字符，而且还常常忘记。</p>

<p>有一个方法可以避免每次都要键入<code>bundle exec</code>作为前缀。</p>

<p>安装<a href="https://github.com/mpapis/rubygems-bundler">rubygems-bundler</a>。
<code>bash
$ gem install rubygems-bundler
</code>
然后运行：
<code>bash
$ gem regenerate_binstubs
</code></p>

<p>启用RVM hook:
<code>bash
$ rvm get head &amp;&amp; rvm reload
$ chmod +x $rvm_path/hooks/after_cd_bundler
</code>
为自己的项目创建bundler stubs.
<code>bash
$ cd your_project_path
$ bundle install --binstubs=./bundler_stubs
</code></p>

<p>最后重新打开terminal就可以直接执行ruby命令，不需要加上<code>bundler exec</code>前缀。</p>

<p>如果想禁用次bundler的话，只需要在命令前面加上<code>NOEXEC_DISABLE=1</code>前缀。更详细的信息可以看[rubygems-bundler]的<a href="https://github.com/mpapis/rubygems-bundler">文档</a>。</p>
]]></content>
  </entry>
  
</feed>
>>>>>>> 09615b67c1384817f01948313cc9bfa79d82b402:blog/tags/ruby/atom.xml
