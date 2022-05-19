---
layout: post
title: Haskell函数式编程之特性篇
date: 2013-03-17 12:46
comments: true
categories: 编程开发
tags: [Haskell, functional, curry, 高阶函数]
---

函数式编程的定义是：

In computer science, functional programming is a programming paradigm that treats computation as the evaluation of mathematical functions and avoids stateand mutable data. 
即：函数式编程是一种编程模型，他将计算机运算看做是数学中函数的计算，并且避免了引入状态及可变数据。

它更强调函数的应用，而不像命令式编程更强调状态的改变。


## 无副作用（side effect）

命令式函数可能会改变程序的状态，这就会对其产生**副作用**。在命令式编程中，在执行程序不同的状态下同一个函数的返回结果会发生改变。例如，下面是一个使用JavaScript写的函数。

```javascript

var state = true;
var getVal = function () [
     return state;
}

```
```javascript

console.log(getVal()); //true
state = false;
console.log(getVal()); // false

```
<!-- more -->

注意我们调用了两次getVal(),但是其输出了不同的结果。而在Haskell中，对变量只有声明，没有赋值。即如果声明了一个值为true的state变量，就无法再将其修改为false。这叫做**变量的不变性**。

而函数式编程中如果描述状态的变化那，就是将状态变化作为函数的参数进行传递。


## 延迟计算（lazy evaluation）


正因为函数式编程无副作用，所以**延迟计算**（又称为惰性求值）就成为可能。
**延迟计算**指将一个表达式的值推迟到直到被需要时才进行计算。（delays the evaluation of an expression until its value is needed ）

它的优点是：

* 避免了不需要的运算，从而提高的性能。
* 使创建无限的数据结构成为可能。


例如，我们写一个将指定参数放置到一个无限长的数组中的函数。

```haskell

repeat' :: a -> [a]
repeat' x = x : repeat' x

```

第一行是对repeat'参数及返回值的定义，它接收一个类型a,返回a的数组。
第二行是repeat'函数的实现，它将x放置到一个无穷大的数组中。

在没有延迟计算特性的编程语言中，这种函数是根本无法使用的。因为一旦调用就会陷入死循环。
即使在支持延迟计算的编程语言中，我们直接输出这个数组:`print $ repeat' 10`,也会进入死循环。那么如何使用它那？我们可以写一个take函数，其可以返回数组中前几位元素。

```haskell
take' :: Int -> [a] -> [a]
take' 1 (x:xs) = [x]
take' index (x:xs) = x : (take' (index-1) xs)

```
我们这样调用它，

```bash

Prelude> take' 3 (repeat' 5) 
[5,5,5]
Prelude> take' 3 (repeat' 'a') 
"aaa"

```

Haskell对函数参数默认采取延迟计算的求值策略。所以这样在调用repeat'函数时并不是先将repeat'函数的结果数组计算出来，再进行take操作，而是take操作需要前几位元素，repeat'函数才会生成前几位元素。


## 高阶函数(Higher-order function)

一个函数成为**高阶函数**需要满足下面两条中的至少一条:

1. 将一个或多个函数作为输入。
2. 输出是一个函数。

换句话说，**高阶函数就是将函数作为参数或者作为返回值的函数**。其他函数都成**为一阶函数**(first order function)。其实这个概念最早来源于数学领域。

函数是Haskell世界中的一等公民，所以肯定支持高阶函数。举个例子，Haskell中有个map函数，它的定义是这样的:
map:: (a -> b) -> [a] -> [b]
它的作用是传入一个函数及一个数组，对该数组中的每一个元素应用此函数，从而转换为另一个数组。
我们可以自己实现一个map函数。

```haskell

map' :: (a -> b) -> [a] -> [b]
map' f [] = []
map' f (x:xs) =f x : map' f xs

```

map'函数接收两个参数，第一个参数是一个函数，该函数输入值为a类型的值，输出值为b类型的值，第二个参数为源数组。
我们调用ma p'函数时，可以直接写一个lambda表达式，对源数组进行各种操作。

```bash

Prelude> map' (\x -> x + 5)  [1,2,3]
[6,7,8]
Prelude> map' (\x -> x * x)  [1,2,3] 
[1,4,9]

``` 

如果我们有这样一个需求，我们想通过map'函数对数组的每个对象都加上一个值n，这个n我不想直接定义在此lambda表达式中，能实现吗？答案是可以。

```haskell

outer = let n = 5 in map' (\x -> x + n) [1,2,3] 
[6,7,8]

```

对于匿名函数(\x -> x + n)来说，n就是**non-local variable**。什么是**non-local variable**那？如果一个函数使用了一个变量，这个变量既不属于全局变量，也不属于在此函数中定义的变量，那这个变量对于此函数来说就是**non-local variable**。
所谓的闭包就是使用了non-local variable的函数。


## curry function

curry function还真比较难翻译，先看看[wiki](http://en.wikipedia.org/wiki/Currying)百科的翻译：

In mathematics and computer science, currying is the technique of transforming a function that takes multiple arguments (or a tuple of arguments) in such a way that it can be called as a chain of functions, each with a single argument (partial application). 

**在数学领域和计算机科学领域，currying是一项将接收多个参数（或参数元组）函数转换为函数的链式调用的技术，链条中的每个函数接收单个参数。**

这句话看起来真费解。那么我用一个例子说明一个。

假设现在有一个函数为`f(x,y) = x/y`。那么`f(2,3)`的执行过程是什么样的那？ 首先，我们将x替换为2.那么得到了`f(2,y) = 2/y`。我们定义一个新的函数`g(y)= f(2,y) = 2/y`。再将y替换成3，那么得到了`g(3) = f(2,3) = 2/3`。这个`g(y)`函数就是`f(x,y)`的一个curried function.

举个例子。上文中我们构造了一个map'函数，它接收一个函数及一个数组。如果我们想实现一个名为doubleMe的函数，它接收一个数组，将数组中每个元素都翻一倍。这个可以这样写:

```haskell

doubleMe = map' (\x -> x * x) 

```

注意看，定义doubleMe时我们使用了map'函数，但是给map'函数只传递了一个参数，并没有提供第二个参数。所以在调用doubleMe时，要给其传递一个数组。

```bash

Prelude> doubleMe [1,2,3] 
[1,4,9] 

```
doubleMe的函数完全等价于: 

```haskell

doubleMe ary = map' (\x-> x * x) ary

```
换句话说，如果一个函数接收多个参数，那么接收部分参数的该函数也是一个函数。

