---
layout: post
title: Haskell函数式编程之List操作
date: 2013-04-05 01:20
comments: true
categories: Haskell
tags: [haskell, list, fold]
---


List在函数式语言中是一个重要的抽象，很多事情离了它就很难做到。函数式语言的鼻祖Lisp名称就来自List processing。

Haskell本身也给List操作提供了一系列的操作符以及库函数。

<!-- more -->

## 对列表操作的运算符

**`:`将一个元素放置到列表的前端。**

```bash
Prelude> 1 : []
[1]
Prelude> 2 : [3,4,5]
[2,3,4,5]
Prelude> 'a' : ['g','h','d']
"aghd"
Prelude> 'a' : "ghd"
"aghd"
```
从上面例子可以看出一个字符串其实就是Char型的列表。
我们可以这样验证。

```bash
Prelude> "abc" == ['a','b','c']
True
```

**`++` 连接两个列表。**
```bash
Prelude> [1,2,3] ++ [4,5,6]
[1,2,3,4,5,6]
Prelude> "abc" ++ "efg"
"abcefg"
```
## 使用Range

如果要声明一个1到20的数组，除了将这些数字一一列举出来，我们还可以使用Range来实现，操作符是`..`。

```bash
Prelude> [1..10]
[1,2,3,4,5,6,7,8,9,10]
Prelude> ['a'..'h']
"abcdefgh"
```

Range的默认步长是1，我们可以指定其步长。方法就是给出前两个元素再加上结尾元素，Haskell会根据前两个元素推断出步长，并应用。

```bash
Prelude> [1,3..21]
[1,3,5,7,9,11,13,15,17,19,21]
Prelude> [1,3..20]
[1,3,5,7,9,11,13,15,17,19]
Prelude> ['a','c'..'k']
"acegik"
Prelude> [20,18..0]
[20,18,16,14,12,10,8,6,4,2,0]
```

## 使用集合生成新的列表

Haskell对List的操作还有一种神奇的方式。下面是一个数学公式，我们在初中肯定学过。

```console
S = { x | x ∈ N, x < 10}
```

S是一个目标集合，N是源集合，S中的元素是属于集合N,并且小于10的元素。

而在Haskell中可以直接使用这种语法。

```bash
Prelude> let list = [1,2,3,4,5,6]
Prelude> [x | x <- list, x < 3]
[1,2]
Prelude> [x | x <- list, x < 3, x > 1]
[2]
Prelude> [x * 2 | x <- list, x < 3]
[2,4]
```

## 常用的列表操作函数

在[《Haskell函数式编程之特性篇》](http://huangbowen.net/blog/2013/03/17/haskell-functional-programming-feature/)中我们定义了一个map函数。它就是对列表的每个元素进行一个函数元素生成另一个列表。

```haskell

map' :: (a -> b) -> [a] -> [b]

map' f [] = []
map' f (x:xs) =f x : map' f xs

```

我们可以再定义一个filter函数，用于对列表进行过滤。

```haskell

filter' :: (a -> Bool) -> [a] -> [a]

filter' f [] = []
filter' f (x:xs)
     | f x       = x : filter' f xs
     | otherwise = filter' f xs

```

除此之外，Haskell还有大量的库函数用于对list进行操作。我们可以自己一一实现它。

head函数用于获取列表的第一个元素。

```haskell
head' (x:xs) = x
```

tail函数获取列表的除第一个元素外的所有元素。

```haskell
tail' (x:xs) = xs
```

last函数是获取列表的最后一个元素。

```haskell
last' (x:xs)
     | null xs = x
     | otherwise = last' xs
```

init函数返回列表中除最后一个的其他元素。

```haskell
init' (x:xs)
     | null xs = []
     | otherwise = x : init' xs
```

你看使用Haskell实现这样的函数是如此的简单。注意这些函数都没有做对空列表的处理。如果给这些函数传递一个空列表会抛出异常。使用Haskll提供的库函数也一样。

```haskell
Prelude> head []
*** Exception: Prelude.head: empty list
```

## fold

对list的操作中我们经常会有这样一个情况，就是给定一个初始值，对list的每个元素进行一个操作，最后得出一个结果,这就像将列表折叠起来一样。比如求数组的最大值、最小值、求和都是这样的模式。Haskell中有相应的函数来实现这种pattern。我们可以自己实现一下。

```haskell

foldl' :: (a -> b -> a) -> a -> [b] -> a

foldl' f s [] = s
foldl' f s (x:xs) = foldl' f (f s x) xs

```

foldl'函数接收一个函数（这个函数接收一个a类型的值，b类型的值，并返回一个a类型值），一个a类型的值，一个b类型的列表，返回值为a类型的值。 （注意其中的a，b类型并不是确定的类型，它只是代表某类型，这有点像其他编程语言中的泛型。a,b的具体类型是由调用fold'时传入的具体参数推断出来的。）

我们可以用它来计算一个数组的和。

```bash
*Main> foldl' (\ s x -> s + x)  0 [1,2,3]
6
```

它与我们在Haskell函数式编程之2中提到的sum' 函数是等价的。
注意这是一个左flod。即它是对列表的每个元素按照从左到右的顺序进行函数运算。

我们也可以实现一个右fold。

```haskell

foldr' :: (a -> b -> a) -> a -> [b] -> a
foldr' f s [] = s
foldr' f s (x:xs) = f (foldr' f s xs) x
```

```bash
*Main> foldr' (\ s x -> s + x)  0 [1,2,3]
6
```

在右fold中，对列表进行函数运算的顺序是从右到左。其实我们可以使用左fold来构造一个右fold。

```haskell
foldr2 f s [] = s
foldr2 f s (x:xs) = f s (foldl' f x xs)
```

```bash
*Main> foldr2 (\ s x -> s + x)  0 [1,2,3]
6
```

只不过这个右fold有个局限性，那就是a，b两个必须是同一个类型。

我们甚至可以用fold来实现map及filter等函数。

使用左fold实现map和filter。

```haskell
map2 :: (a -> b) -> [a] -> [b]
map2 f xs =foldl' (\s x -> s ++ [f x]) [] xs

filter2 :: (a -> Bool) -> [a] -> [a]
filter2 f [] = []
filter2 f (x:xs) = foldl' (\s x -> if f x then s ++ [x] else s ) [] xs
```

使用右fold来实现map和filter。

```haskell
map3 :: (a -> b) -> [a] -> [b
map3 f xs =foldr' (\s x -> f x : s) [] xs

filter3 :: (a -> Bool) -> [a] -> [a]
filter3 f [] = []
filter3 f (x:xs) = foldr' (\s x -> if f x then x : s else s) [] xs
```

由于`++`效率没有`:`高，所以生成结果为list的时候最好使用右fold。

以上就是关于List操作的各种知识了。其实Haskell中的列表就是一个函数，一个包装了一系列元素的函数。我们甚至可以自己实现自己的List函数。等有空的时候一起实现下。

另外，本篇文章所有源码被我放置在github中，地址是<https://github.com/huangbowen521/HaskellLearning>,想要源码的可以自行下载。