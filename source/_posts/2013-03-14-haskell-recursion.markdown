---
layout: post
title: Haskell函数式编程之递归
date: 2013-03-14 21:46
comments: true
categories: 编程开发
tags: [haskell, functional, recursion] 
---

在Haskell的世界中，没有变量赋值，流程跳转，如果要实现一些简单的功能，比如求一个数组中的最大值，都需要借助递归实现。

**递归函数的定义:**

**A function may be partly defined in terms of itself.**
**即如果一个函数的定义中使用了其自身，这个函数就叫做递归函数。**


## 普通递归(traditional recursion)

我们就写一个简单的对数组求和的函数。

```haskell

sum' :: (Num a) => [a] -> a 
sum' (x:xs) = x + sum' xs
sum' [] = 0

```

<!-- more -->

第一行定义了了一个名为`sum'`的函数的参数及返回值。这个函数接收一个类型为Num的数组并返回一个Num型的数值。（这里的`'`是函数名的一部分，因为Haskell允许`'`作为函数名的一部分。由于系统已经有了sum函数，所以我们加个`'`与标准sum函数区分开。）

第二行的(x:xs)就是我们传入的数组参数。我们这里使用了Haskell的pattern matching。x表示的是数组中的第一个元素，xs表示数组中的其它元素。我们可以描述求数组中值的和的行为为：数组中的第一个元素与数组中剩余元素的和。所以这就是我们的实现。

第三行则说明了如果给一个空的数组则直接返回0。这也叫做递归的退出条件，否则递归会没完没了。

第二行和第三行共同完成了这个`sum'`函数的定义。当你传递给它一个参数时，它会根据参数的情况自动选择调用那个实现。

假设我们这样调用它：`sum'  [1,2,3]`,程序的执行过程是这样子的：

```console

sum' [1,2,3] ->

1 + sum' [2,3] ->

1 + (2 + sum' [3]) ->

1 + (2 + (3 + sum' [])) ->

1 + (2 + (3 + 0)) ->

1 + (2 + 3) ->

1 + 5 ->

6

```

这种递归有个问题就是我们一直到等到递归结束才进行算术运算，这样在执行过程既要保存函数调用的堆栈，还要保存中间计算结果的堆栈，如果递归过深，很容易引起stackOverFlow.

## **尾递归**(tail recursion)

针对上述问题，我们可以换种写法。

```haskell

sum' :: (Num a) => [a] -> a -> a 

sum' (x:xs) temp = sum' xs x+ temp 

sum' [] temp = temp

```

我们这样调用它: `sum' [1,2,3] 0`。

它的执行顺序是这样的:

```console

sum' [1,2,3] 0 ->

sum' [2,3] 1 ->

sum' [3] 3 ->

sum' []  6 ->

6

```

第二种写法其实就是尾递归。

**尾递归的定义：**

**A recursive function is tail recursive if the final result of the recursive call is the final result of the function itself.**

**即:如果一个递归函数，它的最终的递归调用结果就是这个函数的最终结果，那它就是尾递归的。**

所以我们可以明显看出，第一个不是尾递归，第二个是。

###尾递归优化(tail recursion optimization)

在大多数编程语言中，调用函数需要消费堆栈空间，一个实现了尾递归的递归函数在进行递归调用时，其实只关心递归调用的结果，所以当我们调用下层函数时，可以舍去上层函数的堆栈调用情况，下层递归调用可以重用这个堆栈空间，这种就叫做**尾递归优化**。一个可能的实现方式是：只需要把汇编代码call改成jmp, 并放弃所有 局部变量压栈处理，就可以了。

尽管尾递归比递归更节省堆栈空间，但并非所有的递归算法都可以转成尾递归的，因为尾递归本质上执行的是迭代的计算过程。这与并非所有的递归算法都可以转成迭代算法的原因是一样的。

## 互递归(mutual recursion)

互递归就是多个递归函数之间相互调用。互递归的一个简单的例子就是判断一个自然数是偶数还是还是奇数。

```haskell

isOdd :: Int -> Bool
isOdd x
 | x == 0 = False
 | otherwise = isEven (x-1)


isEven :: Int -> Bool
isEven x
 | x == 0 = True
 | otherwise = isOdd (x-1)

```
这个实现很有意思。

任何一个互递归都可以被转变为**直接递归**(direct recursion)，即将另一个调用inline到当前递归函数中。

下面是isOdd和isEven的**直接递归**版本。

```haskell

isOdd :: Int -> Bool
isOdd x
 | x == 0 = False
 | x == 1 = True
 | otherwise = isOdd (x-2)


isEven :: Int -> Bool
isEven x
 | x == 0 = True
 | x == 1 = False
 | otherwise = isEven (x-2)

```





















