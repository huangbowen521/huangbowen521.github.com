---
layout: post
title: 学习Scala第一篇-从hello world开始
date: 2015-11-15 01:41:24 +0800
comments: true
categories: Scala 
---

最近开始系统性的学习scala。其实之前使用过scala的，比如我在用Gatling这款性能测试工具的时候就接触到了scala了。Gatling本身就是用Scala写的，而且Gatling的性能测试配置文件本身就是一个scala类，可以随意使用scala甚至是Java提供的各种类库。当时觉得用Gatling特别舒服的原因就在于配置文件强大的表现力。而这种表现力就是由Scala语言提供的。

<!-- more -->

言归正传，学习Scala还是从最简单的Hello world开始。在Scala官网中显著的标题就是：

>> Object-Oriented Meets Functional

>> Have the best of both worlds. Construct elegant class hierarchies for maximum code reuse and extensibility, implement their behavior using higher-order functions. Or anything in-between.

从中可以看出Scala结合了面向对象及函数式编程这两种编程范式。在本文中我将会拿Java语言和其比较，看看到底Scala强在那里。

使用Java语言实现一个Hello World的代码如下：

```java

public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello World!");
    }
}

```

以下是Scala的实现：

```scala

object HelloWorld  {
  def main(args: Array[String]): Unit = {
    println("Hello, World!")
  }
}

```

好吧，如果标点符号不算代码行，Java版本和Scala版本的实现的代码行数是一致的。貌似Scala并没有减少什么。唯一减少的就在于println不用指定类名，以及对main方法不用声明为static。

在这里对Scala实现与Java实现的几个不同之处做个介绍。

* 第一是Scala对HelloWorld的修饰符使用的是object。其实Scala中也有class关键字，那么object关键字和class关键字有什么区别那？简单来说object关键字定义了一个匿名类，并且创建了该匿名类的单个实例（采用单例模式），该实例名为HelloWorld。所以object中定义的方法自动都是static的。我觉得object关键字存在的价值之一就是建立起了面向对象和函数式的桥梁。因为在面向对象的系统中，所有方法都必须存在于类中，而函数式编程中没有类的概念，使用函数无需new类的实例，所以object中的方法都是静态方法，可以直接被调用。进一步解读请到[这里](http://stackoverflow.com/questions/1755345/difference-between-object-and-class-in-scala)。

* 第二是Scala中对变量的类型的定义方式是变量名在前，类型在后，中间用冒号相隔。原因之一是代码更可读。因为我们更关心变量名，而类型其次，尤其是你拥有一个超级长的类型的情况下（比如
HashMap<Shape, Pair<String, String>>)；原因之二据说是这样的方式在实现Scala类型时技术上要简单些。进一步解读请到[这里](http://stackoverflow.com/questions/6085576/why-does-scala-choose-to-have-the-types-after-the-variable-names)。

* 第三是main函数的返回值是Unit，而不是Java中的Void。为什么是这样那？我想是因为Scala为了实现自己的类型系统，对于无显式返回值的函数直接使用Void是不合适的。在[Scala.Unit文档](http://www.scala-lang.org/api/current/index.html#scala.Unit)中是这样定义Unit的：

>> Unit is a subtype of scala.AnyVal. There is only one value of type Unit, (), and it is not represented by any object in the underlying runtime system. A method with return type Unit is analogous to a Java method which is declared void.

* 第四是Scala中表达式最后的分号是可选的。原因就是为了契合函数式编程的哲学，即一切尽可能的简单。不写分号程序员一天可以多敲一些代码出来。

好吧，其实在Scala中Hello World还有一种写法。

```scala

object HelloWordV2 extends App {
  println("Hello, World!")
}

```

代码从三行减少到了两行，Scala终于胜出了。那么App是个什么鬼？[App](https://github.com/scala/scala/blob/v2.11.7/src/library/scala/App.scala#L1)是一个trait。trait又是什么鬼？[trait](http://docs.scala-lang.org/tutorials/tour/traits.html)是Scala中的一个特殊类型，它与Java中的interface很相似，但比interface强大。HelloWordV2添加了对App的扩展后，就自动成为了一个可以运行的程序，由于App中定义了main方法，所以HelloWorldV2中就无需再定义了，牛逼的地方在于HelloWorldV2的body中的代码都会作为main方法中的代码被执行。以下是App源码中对main方法的定义：

```scala

@deprecatedOverriding("main should not be overridden", "2.11.0")
def main(args: Array[String]) = {

this._args = args

for (proc <- initCode) proc()

if (util.Properties.propIsSet("scala.time")) {

val total = currentTime - executionStart

Console.println("[total " + total + "ms]")

}

```

看来App在实现main方法时还设置了一个计时器，通过scala.time这个属性来开关。所以没事翻翻源码还是挺好玩的。

不知有没注意到其实main方法是有个叫args的参数的，那么新版HelloWorld中如何使用该参数那？直接使用它就行。

```scala

object HelloWordV2 extends App {
  println("Hello, World!" + args(0))
}

```

ok，Scala版的Hello World就到这里吧。
