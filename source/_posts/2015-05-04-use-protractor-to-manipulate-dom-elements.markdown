---
layout: post
title: 使用protractor操作页面元素
date: 2015-05-04 17:02:05 +0800
comments: true
categories: Protractor
---

Protractor是为Angular JS应用量身打造的端到端测试框架。它可以真实的驱动浏览器，自动完成对web应用的测试。Protractor驱动浏览器使用的是WebDriver标准，所以使用起来与其他语言实现的WebDriver库大体相同。当然，我说大体相同那肯定还是有不同的地方。一旦不注意这些不同的地方就会坑到你（我就被成功坑过，所以才有了这篇文章）。

<!-- more -->

Protractor编写测试的核心是查找DOM元素，与其交互，然后查看交互后的状态与你的期望是否一致。所以查找DOM元素并与之交互显的非常重要。Protractor提供了一个全局函数element，其接受一个Locator对象并返回一个ElementFinder对象。该函数会返回单个元素。如果你想返回多个元素，可以使用element.all函数，其接受一个Locator对象并返回ElementArrayFinder对象。ElementFinder对象有一组方法，用于元素交互，比如click()，getText(),sendKeys等。

Locator对象的创建主要使用全局的by对象，其提供一些API来生成Locator对象以供element或element.all函数使用。

比如：

```javascript

//根据class名来查找元素
by.css(‘myclass')

//根据id来查找元素
by.id(‘myid')

//根据ng-model名来查找元素
by.model(’name')

//查找绑定了指定名的元素
by.binding(‘bindingname')

//查找指定repeater中的元素
by.repeater(‘myrepeater')

```

可以看出前两个Locator的创建方法与其他语言实现的WebDriver的用法基本一样，而后几个则专为AngularJS应用设计的，方便在基于AngualrJS框架下写的web应用中查找页面元素。这是第一处不同。

另一处不同其他语言实现的WebDriver库使用Locator找到的元素类型是WebElement，而Protractor则返回的是ElementFinder对象。两者不同之处是在于ElementFinder对象不会立即与浏览器交互，根据指定的Locator来查找到页面上的元素；而只有当你调用了ElementFinder对象的方法时，它才会真正的与浏览器进行交互。一些常用的方法有以下所示。

```javascript

//这时不会与浏览器交互获取元素信息
var el = element(by.css(‘mycss’));

//点击元素
el.click();

//给该元素输入内容
el.sendKeys(’text’);

//清空元素内内容
el.clear();

//获取指定属性的值
el.getAttribute(‘value’);

//获取元素的文本值
el.getText();

```

请注意这些方法都是异步的。所有的方法返回的是一个promise（我就吃过这个亏，以为返回的是值）。所以比如你想输出一个元素的值，应该这么写：

```javascript

element(by.css(‘myclass’)).getText().then(function(text) {
     console.log(text);
}):

```

如果你使用expect方法来验证元素的值时，expect方法会帮你取出promise中值，所以你只用这么写:

```javascript

expect(element(by.css(‘myclass’)).getText()).toEqual('确定’);

```

还有不同的地方在于Protractor支持对元素查找时进行链式调用。这样的功能相当实用。你可以组合element和element.all两个函数来定位元素。并且Protractor还提供了几个辅助方法来更方便你的使用。

```javascript

element.all(locator1).first().element(locator2);
element(locator1).all(locator2);
element.all(locator1).get(index).all(locator2);

```

element.all函数提供的辅助方法有：

* filter： 提供一个过滤器过滤其中的元素。

```javascript

element.all(by.css(‘myclass’)).filter(function(ele, index) {
return ele.getText().then(function(text) {
     return text == ‘确定';
});
});

```

* get： 根据索引获取指定元素。如 element.all(by.css(‘myclass’)).get(0);

* first: 获取第一个元素。 element.all(by.css(’myclass’)).first();

* last: 获取最后一个元素，用法同上。

* count：获取元素个数。

此外还提供了each，map,reduce等方法对列表进行各种操作。

element函数提供的辅助方法有：

* locator: 返回locator对象。

* getWebElement： 返回该ElementFinder包裹的WebElement对象。

* all: 查找其一组子元素。

* element: 查找其子元素。

* isPresent: 元素是否在页面上展示。

总结起来，Protractor与其它的WebDriver语言实现的区别如下：

1. Protractor专为AngualrJS应用定制，其自身包含了很多wait操作，保证AngularJS脚本执行完毕后才进行下一步操作，保证了测试的稳定性与健壮性。

2. Protractor设计的By对象针对AngularJS应用提供了很多实用方法，在定义AngularJS应用页面时更加轻松。

3. element函数返回的是ElementFinder对象，其不会立即与浏览器交互，除非调用ElementFinder对象的方法。

4. 调用ElementFinder对象的方法返回的是一个promise。（这点很重要）

5. Protractor在定位元素时支持链式调用。



