---
layout: post
title: Haskell-函数式编程语言之初体验
date: 2013-03-02 14:55
comments: true
categories: 编程开发
tags: [Haskell, 函数式编程, Language]
---

如果你是使用面向对像语言进行编程的程序员，那么你应该去了解掌握一门动态语言。而动态语言的魔力之一就是函数式编程。而要学习了解函数式编程，那么haskell是一个不错的选择。

Haskell是是一门纯函数式编程语言(purely functional programming language)。在其世界中函数是第一等对象。并且在haskell中没有赋值，例如你指派a的值为5，然后你无法再给a分配其它的值。所以你不能像命令式语言那样命令电脑“要做什么”，而是通过函数来描述出问题“是什么”。


作为一个纯的函数式编程语言，它支持惰性求值、模式匹配、列表解析、类型类、类型多态……

别着急，让我们慢慢来解开函数式编程的面纱。


## 安装Haskell

1. 可以去[官网](http://www.Haskell.org/Haskellwiki/Haskell )下载安装包进行安装。

2. mac平台的用户可以通过[homebrew](http://mxcl.github.com/homebrew/ )进行安装。

在terminal下输入`brew install haskell-platform`即可。



## 使用Haskell

安装完毕后haskell platform的解释器GHC就已经在你的电脑上了。GHC可以解释执行Haskell脚本，即后缀名为.hs的文件。你可可以通过在terminal输入`ghci`进入交互模式。

``` bash

twer@bowen-huang:~$ ghci
GHCi, version 7.4.2: http://www.haskell.org/ghc/ :? for help
Loading package ghc-prim ... linking … done.
Loading package integer-gmp ... linking … done.
Loading package base ... linking … done.
Prelude> 1+2
3
Prelude> 3*4
12
Prelude> 5/1
5.0

```

关于Haskell的编辑器你可以使用任何喜欢的编辑器:Vim、Emacs、Sublime、TextMate…..我比较喜欢Sublime。因为在Sublime自带Haskell的快捷编译执行。只需要按Ctrl+B来直接运行Scripts脚本。

在ghci交互模式下可以使用`:l`命令来load一个Haskell脚本，然后就可以调用此脚本中的函数。我们先写一个'Hello world!’程序，然后通过ghci来load和调用.

``` haskell HelloWorld.hs

main = print $ "Hello world!"

```

``` bash
Prelude> :l HelloWorld.hs
[1 of 1] Compiling Main ( HelloWorld.hs, interpreted )
Ok, modules loaded: Main.
*Main> main
"Hello world!"

```

如果对文件进行了修改，也可以直接通过`:r`来重新加载文件。


## Haskell的基本语法



### 加减乘除操作

``` bash

Prelude> 1 + 2
3
Prelude> 3 - 1
2
Prelude> 3 * 4
12
Prelude> 5 / 1
5.0
Prelude> 10 / (-5)
-2.0

```

注意对负数进行操作时要将其用()括起来，否则系统会报错。

### 判等与比较操作

``` bash

Prelude> 5 == 5
True
Prelude> 10 == 8
False
Prelude> 5 /= 5
False
Prelude> 10 /= 8
True
Prelude> 5 >= 3
True
Prelude> 5 <= 3
False
Prelude> True && True
True
Prelude> True && False
False
Prelude> False || False
False
Prelude> True || False
True
Prelude> not True
False
Prelude> not False
True

```


### 控制流转

``` bash

Prelude> let isHello x = if x == "Hello" then True else False
Prelude> isHello "Hello"
True
Prelude> isHello "World"
False

```

注意这里的条件判断中的else是不可以省略的，这样保证条件语句总会返回一个值。所以我们可以将整个`if..then..else` pattern看做一个表达式。

如果在脚本文件中写的话不需要使用`let`关键字。并且也可以采用另一个写法。

``` haskell isHello.hs

isHello x
 | x == "Hello" = True
 | otherwise     = False

```

|表示或，otherwise关键字表示其它的情况。当然你也可以将这三行代码写成一行，这样也是能够正常运行的。分成三行只是为了更加可读。

还有第三种写法，实际上与面对对象语言中的`switch…case`语句有些类似。

``` haskell isHello.hs

isHello x = case x of
 "Hello" -> True
 otherwise -> False

```

这和第二种写法很类似。其实第二种写法本质上就是`case`语句，它只是`case`语句的一个语法糖而已。

另外，在Haskell中是没有各种循环语句的，如果要实现相似的特性当然要使用递归了。

第二节中，我们会讨论这个问题。



