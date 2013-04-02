---
layout: post
title: 修改方法签名的重构手法
date: 2013-04-03 00:19
comments: true
categories: refactor
tags: [重构, reactor, signature]
---

今天看到同事写的一篇博客[《依赖快捷键做重构是不行的》](http://xiaodao.github.com/2011/03/15/correct-refactoring/)。里面讲了一个这样的案例：本来有一方法，假设叫methodA。

<!-- more -->

```java
public void methodA(){   
  // blablabla... 
}
```
后来由于需求变动，需要增加一个参数,姑且看做这个样子。

```java
public void methodA(String param){  
//  blablabla... 
}
```

他本来想直接修改方法签名（[Intellij]中快捷键是Ctrl+F6）。但这样会导致所有调用此方法的地方由于缺乏对新加参数的处理，会导致单元测试甚至编译失败。他得出结论说依赖快捷键做重构是不行的。


我想说的是并不是依赖快捷键做重构不行，而恰恰是没有快捷键做重构会异常痛苦。如果没有方便的快捷键的话，依靠手工做重构会大大增加重构的时间成本及出错成本。正是由于重构快捷键的越来越便利，才导致重构不再是奢侈品，而成了家常便饭。


其实针对这种情况是使用快捷键的思路不对。我们的目标是对methodA添加一个参数，看似直接采用修改方法签名的快捷键就可以直接搞定。但其实这种想法是大大错误的。
结合他在文中给出的另一个实现方式，修改方法签名的一个正确的顺序应该是这样的。

1. 新写一个methodA2,这个方法相当于重构后的methodA。如果实现需要调用methodA，可以直接调用。

2. 使用查找所有用例的快捷键(Ctrl+Alt+F7)查找methodA的所有用例，并逐一修改为调用methodA2的实现。期间每改一处要运行一下测试，防止修改破坏了原有功能。

3. 如果methodA2调用了methodA方法，使用inline method快捷键(Ctrl+Alt+N)将methodA inline到methodA2中。

4. 使用safe delete快捷键(Alt+Delete)删除methodA方法。如果仍然有指向methodA的方法调用，IDE会进行提示。

5. 使用rename的快捷键(Shift+F6)将methodA2方法重名为methodA。

我们可以看到，这五步中有四步都需要IDE的快捷键支持。如果脱离了IDE的快捷键，你会发现连一个小小的rename都会花上大量的时间。

而这种方式与一上去就直接修改方法签名的方式好在那里？

* 基本不会出现编译错误。直接修改方法签名会陷入修复编译错误的泥潭。

* 小步前进，随时可以停下而不担心程序构建失败。方式一会将程序带入一个漫长的不稳定的状态。

学会重构手法固然重要，但是掌握IDE提供的重构快捷键也不能轻视。如果你是Java程序员，推荐使用[Intellij]，里面的重构快捷键比[eclipse]多出不少，而且效果更好。如果你是c#程序员，推荐给你的Visual Studio装上[ReShaper]。注意[Intellij]和[ReShaper]都是[JetBrains]出品的。要知道程序员挑选IDE就跟女生使用化妆品一样挑剔，但是[JetBrains]赢得了广大程序员的心。

PS:我知道这两款产品都不是免费的，但是对于程序员来说，节省了时间就是节省了金钱，对于工具，当然要用最好的。

[Intellij]: http://www.jetbrains.com/idea/
[eclipse]: http://www.eclipse.org/
[ReShaper]: http://www.jetbrains.com/resharper/
[JetBrains]: http://www.jetbrains.com/

