---
layout: post
title: 翻译-page对象
date: 2013-09-17 02:14
comments: true
categories: testing
tags: [page, selenium]
---

译者注：这篇文章翻译自马丁·福勒（Martin Flower，对，没错，就是软件教父）官网的一篇文章，原文出处在文底。如果你正在做WEB自动化测试，那么我强烈推荐你看这篇文章。另外透露Martin Flower将于10月份左右来成都ThoughtWorks办公室，大家有机会一睹他的风采。

<!-- more -->


当你在为web页面编写测试时，你需要操作该web页面上的元素来点击链接或确定显示的内容。然后，如果你在测试代码中直接操作html元素,那么你的代码是机器脆弱的，因为UI会经常变动。一个page对象可以封装一个html页面或部分页面，通过提供的应用程序特定的API，你可以操作页面元素而不需要在HTML中四处搜寻。

{% img /images/page_object.png 700 %}

page对象的一个基本的经验法则是page对象应该允许软件客户端能够做任何人类能做的事。它也应当提供一个易于编程的接口,并隐藏窗口中低层的部件。所以访问一个文本框，可以通过一个访问方法获取一个字符串，复选框应当使用布尔值，按钮应当被表示为行为导向的方法名。page对象应当封装所有的在gui控件本身上查找和操作数据的方法。一个好的经验法则是即使改变具体的控制，这种情况下page对象接口不应当发生变化。

尽管该术语是”页面“对象，并不意味着给每个页面都要建立一个这样的对象，但页面有重要意义的元素除外[1]。所以一个显示多个相册的页面可以有一个相册列表的page对象，里面包含了几个相册page对象。也有可能会有一个页眉page对象及一个页脚page对象。经验法则是给通过给页面建模，从而对应用程序的使用者变得有意义。

同样，如果你导航到另一个页面，初始page对象应当返回另一个page对象作为新页面[2]。一般page对象的操作应当返回     基本类型（字符串，日期）或另一个page对象。

有一个意见分歧的地方是page对象是由应当包含自身的断言，或者仅仅提供数据给测试脚本来设置断言。在page对象中包含断言的倡导者认为这有助于避免在测试脚本中出现重复的断言，可以更容易的提供更好的错误信息，并且提供更接近[TellDontAsk](http://martinfowler.com/bliki/TellDontAsk.html )风格的API。不在page对象中包含断言的倡导者则认为包含断言会混合使用断言逻辑访问页面数据的职责，并且导致page对象过于臃肿。

我赞成在page对象中不包含断言。我认为你可以通过为常用的断言提供断言库的方式来消除重复。这可可以提供更好的诊断。[3]

page对象通常用于测试中，但自身不应包含断言。它们的职责是提供对基本页面状态的访问。而与测试客户端实现断言逻辑。

我所描述的这个模式针对HTML，但同样的模式也同样适用于任何UI技术。我见过这种模式有效的隐藏了Java swing UI的细节，并且我深信它已经被广泛的应用于几乎所有其他的UI框架。

并行问题是另一个page对象可以封转的话题。这可能涉及异步操作中隐藏不作为异步呈现给用户的异步性。也有可能涉及封装UI框架中你不得不担心的UI和工作线程之间分配行为的线程问题。

page对象在测试中的使用非常常见，但是也被用于在应用程序上层提供一个脚本接口。最好将脚本接口置于UI下层，这样脚本通常不复杂并且执行速度快。然而应用程序在UI层有太多的行为，那么使用page对象可能在槽糕的工作中最好的选择。（但是尽量将逻辑移入page object，长期来看会导致更好的脚本即更健康的UI。）

使用一些[领域特定语言](http://martinfowler.com/bliki/DomainSpecificLanguage.html )来书写测试非常普遍，比如Cucumber或一门内部DSL。如果你尽量在page对象层级之上编写测试DSL，那么你可以通过一个解析器将DSL声明转换为调用page对象。

> 如果你在测试方法中使用了WebDriver API，那么你做错了 -- [Simon Stewart](http://blog.rocketpoweredjetpants.com/ ).


模式有助于将逻辑从页面元素中剥离（例如 [Presentation Model](http://martinfowler.com/eaaDev/PresentationModel.html ), [Supervising Controller](http://martinfowler.com/eaaDev/SupervisingPresenter.html ), 及[Passive View](http://martinfowler.com/eaaDev/PassiveScreen.html )),从而少通过UI做测试，并且减少对page对象的需要。 

page对象是封转的一个典型示例。它们从其它组件（如测试）部件中隐藏了UI结构的细节。。如果你自问“我如何能从软件测试中隐藏细节？”，当你做开发时在这样的情况采用page对象不失于一个好的设计原则。封转体现了两方面的好处。我已经强调，通过将操作UI的逻辑限制到单个地方有助于你修改逻辑而不影响系统的其他组件。一个间接的好处是使测试端代码更容易理解，因为逻辑是关于测试的意图，而会被UI细节搞乱。


## 进一步阅读

I first described this pattern under the name Window Driver. However since then the term "page object" was popularized by the Selenium web testing framework and that's become the generally used name.

我刚开始将这种模式命名为[窗口驱动](http://martinfowler.com/eaaDev/WindowDriver.html )(Window Driver)。然而自从Selenium web测试框架使用“page object”这个名称，page对象变成了常用的名称。


[Selenium的维基](https://code.google.com/p/selenium/wiki/PageObjects )强烈推荐使用page对象，并提供了如果使用的建议。它也赞成page对象不包含断言。


## 致谢

Perryn Fowler, Pete Hodgson及Simon Stewart为这篇博客的草稿提供了及其有用的意见。同样像往常一样我非常感激ThoughtWorks软件开发列表中的各种各样的居民提供的建议和修正。

## 脚注

1. 有观点认为”page对象“名称是一个误导。因为它让你认为一个页面只能有一个page对象。类似面板对象可能会更好，但是page对象已经被广泛接受。为什么命名的另一个例证是[TwoHardThings](http://martinfowler.com/bliki/TwoHardThings.html )中的其中之一。


2. page对象负责创建其他的page对象（比如导航）是共同的意见。然而，一些从业者更喜欢page对象返回一些通用的浏览器上下文，通过建立在上下文上层的page对象的测试控制是基于测试的流程（特别是条件流）.
他们偏好基于测试脚本知道那个页面是期待的下个页面这一事实，并且该知识不需要在page对象之间重复。特别是使用静态类型语言通常以类型标记的方式显示页面导航，这样会增加他们的喜好。

3. page对象中包含断言也行，尽管大多数人（比如我）更青睐无断言风格。这些断言可以检查页面或应用程序在此时此刻的不变量，而不是测试探索的具体东西。


本文出处: <http://martinfowler.com/bliki/PageObject.html>
