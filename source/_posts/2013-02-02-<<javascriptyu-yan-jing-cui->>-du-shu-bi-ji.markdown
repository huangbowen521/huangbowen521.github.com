---
layout: post
title: "《JavaScript语言精粹》读书笔记"
date: 2013-01-16 00:22
comments: true
categories: 生活随笔
tags: JavaScript 读书笔记
---

《JavaScript语言精粹》这本书句句是精华。如果你想只读一本书了解JavaScript,这本是你的不二选择。

这么薄的一本书讲JavaScript的特点介绍的非常清楚，是我对JavaScript的认识更加的深入。以前总觉得函数式编程很难理解，但是看了这本书以后我觉得对其有了一个新的认识。严格意义上说JavaScript并不仅仅是一门函数式编程语言，书中有一句话对它的特性做了一个精彩的描述：JavaScript的许多特性都借鉴自其他语言。语法借鉴自java，函数借鉴自Scheme,原型继承借鉴自Self，而JavaScript的正则表达式特性则借鉴自Perl。

<!-- more -->

JavaScript的简单类型有：数字、字符串、布尔值、null值和undefined值。在JavaScript中，数组是对象，函数是对象，正则表达式是对象。可以使用对象字面量来创建一个新对象： var empty_object = { };

每个对象都连接到一个原型对象，并继承其属性。使用typeof可以确定属性的类型。使用delete可以删除对象的属性。

函数也是对象，其原型对象为Function.prototype.函数有一个call属性，当JavaScript调用函数时，可理解为调用该函数的call属性。函数有四种调用模式：方法调用模式，函数调用模式，构造器调用模式和apply调用模式。这些模式主要是初始化关键字this存在差异，分别是：调用对象，全局对象，隐藏连接到该函数的prototype成员的新对象，apply方法的第一个参数。当函数被调用时，会得到一个arguments数组，可以通过它访问传递给该函数的所有参数。一个函数总是会返回一个值，如果没有制定返回值，则返回underfined.

JavaScript中的数组其实是一种伪数组。她把数组的下标转变成字符串，用其作为属性。可以通过数组字面量来声明一个数组：var empty = [];数组第一个值将获得属性名0，第二个属性名将获得属性名1，以此类推。

JavaScript中的正则表达式也是一个对象。正则表达式的分组有4中：捕获型，使用圆括号包括；非捕获型，使用(?:前缀;向前正向匹配，使用(?=前缀；向前负向匹配，使用（？！前缀。 &nbsp;

读完这本书，彻底颠覆了我对JavaScript的理解。最近在翻译《Effective JavaScript: 68 Specific Ways to Harness the Power of JavaScript (Effective Software Development Series)》这本书，正得益于我从《JavaScript语言精粹》掌握了JavaScript的核心。