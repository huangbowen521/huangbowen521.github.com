---
layout: post
title: SVN中Branch的创建于合并
date: 2013-08-13 00:59
comments: true
categories: SVN
---

{% img /images/branch_trunk.jpg %}

在使用源代码版本控制工具时，最佳实践是一直保持一个主干版本。但是为了应付实际开发中的各种情况，适时的开辟一些分支也是很有必要的。比如在持续开发新功能的同时，需要发布一个新版本，那么就需要从开发主干中建立一个用于发布的分支，在分支上进行bug fix，维护版本的稳定，并适时的将一些改动合并回主干。目前大红大紫的源代码版本控制工具git很受大家推崇，原因之一就是其在这方面的功能相当强大。其实老牌的SVN也是有这样的功能的，接下来就给大家讲解下。

<!-- more -->

# Branch的创建

在SVN中主干代码一般是放置在Trunk目录下的，如果要新建Branch的话则放置在Branchs目录下。(注意这是一种约定，SVN并不强制你这样做)注意Branhs和Trunk目录要平级，不能有嵌套，要不会引起混乱。

```bash

  myproject/
      trunk/
      branches/
      tags/
```

创建一个Branch也相当简单，只需要一条命令即可。

```bash
svn copy http://example.com/repos/myproject/trunk http://example.com/repos/myproject/branches/releaseForAug -m 'create branch for release on August'

```

这条命令是指给myproject这个repo创建一个名为releaseForAug的branch，使用-m来加入描述。


之后你就可以通过 `svn checkout http://example.com/repos/myproject/branches/releaseForAug`来迁出你的Branch源文件，在上面进行修改和提交了。

其实SVN并没有Branch的内部概念。我们只是创建了一个repo的副本，并自己赋予这个副本作为Branch的意义，所以这与git中的Branch有很大不同。

需要注意的是Branch和Trunk使用同一套版本号，也就是说无论在Branch还是Trunk的提交都会引起主版本号的增加。这是因为`svn copy`只支持同一个repository内的文件copy，并不支持跨repository的copy，所以新创建的Branch和Trunk都属于同一个repository。

# 合并

既然要创建分支也需要合并分支。基本的合并也是蛮简单的。

假设现在Branch上fix了一系列的bug，现在我们想把针对Branch的改变同步到Trunk上，那么应该怎么做那？

1. 保证当前Branch分支是clean的，也就是说使用svn status看不到任何的本地修改。

2. 命令行下切换到Trunk目录中，使用 `svn merge  http://example.com/repos/myproject/branches/releaseForAug` 来将Branch分支上的改动merge回Trunk下。

3. 如果出现merge冲突则进行解决，然后执行`svn ci -m 'description'`来提交变动。

当然在merge你也可以指定Branch上那些版本变更可以合并到Trunk中。

```bash

svn merge  http://example.com/repos/myproject/branches/releaseForAug -r150:HEAD

```

示例中是将Branch的从版本150到当前版本的所有改动都合并到Trunk中。

你也可以将Trunk中的某些更新合并到Branch中，还是同样的方法。

# 查看当前Branch和Trunk的合并情况

可以使用`svn mergeinfo`来查看merge情况。

查看当前Branch中已经有那些改动已经被合并到Trunk中:

```bash
# cd to trunk directory
svn mergeinfo http://example.com/repos/myproject/branches/releaseForAug

```

查看Branch中那些改动还未合并。

```bash
#cd to trunk directory

svn merginfo http://example.com/repos/myproject/branches/releaseForAug --show-revs eligible

```

