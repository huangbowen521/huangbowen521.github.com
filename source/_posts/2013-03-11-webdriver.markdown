---
layout: post
title: webDriver入门及提高 
date: 2013-03-11 09:39
comments: true
categories: 开发测试
tags: [webDriver]
---

第一次接触Selenium 的WebDriver，是在一个Web项目中。该项目使用它来进行功能性测试。当我看到Firefox中的页面内容被一个个自动填充并且自动跳转的时候，感觉真的很神奇。通过这段时间的学习觉得可以将我学的关于WebDriver的知识进行一个总结。


什么是Selenium 和WebDriver？
---

Selenium是一个浏览器自动化操作框架。Selenium主要由三种工具组成。第一个工具SeleniumIDE，是Firefox的扩展插件，支持用户录制和回访测试。录制/回访模式存在局限性，对许多用户来说并不适合，因此第二个工具——Selenium WebDriver提供了各种语言环境的API来支持更多控制权和编写符合标准软件开发实践的应用程序。最后一个工具——SeleniumGrid帮助工程师使用Selenium API控制分布在一系列机器上的浏览器实例，支持并发运行更多测试。在项目内部，它们分别被称为“IDE”、“WebDriver”和“Grid”。 

这里主要介绍它的第二个工具：WebDriver。

官网上是这么介绍它的：WebDriver is a clean, fast framework for automated testing of webapps. 但是我觉得它并不局限与进行自动化测试，完全可以用作其它用途。

WebDriver针对各个浏览器而开发，取代了嵌入到被测Web应用中的JavaScript。与浏览器的紧密集成支持创建更高级的测试，避免了JavaScript安全模型导致的限制。除了来自浏览器厂商的支持，WebDriver还利用操作系统级的调用模拟用户输入。WebDriver支持Firefox(FirefoxDriver)、IE (InternetExplorerDriver)、Opera (OperaDriver)和Chrome (ChromeDriver)。 它还支持Android (AndroidDriver)和iPhone (IPhoneDriver)的移动应用测试。它还包括一个基于HtmlUnit的无界面实现，称为HtmlUnitDriver。WebDriver API可以通过Python、Ruby、Java和C#访问，支持开发人员使用他们偏爱的编程语言来创建测试。

 

如何使用？
---

首先，你需要将WebDriver的JAR包加入到你项目中CLASSPATH中。你可以Download它通过<http://code.google.com/p/selenium/downloads/list>。

如果你使用的是maven构建你的项目，只需要在pom.xml文件中加入下面的依赖项即可。

```xml

        <dependency>

           <groupId>org.seleniumhq.selenium</groupId>

           <artifactId>selenium-java</artifactId>

            <version>2.25.0</version>

        </dependency>

        <dependency>

           <groupId>org.seleniumhq.selenium</groupId>

           <artifactId>selenium-server</artifactId>

           <version>2.25.0</version>

        </dependency>

```        

然后，你就可以使用它了。WebDriver的API遵从”Best Fit”原则，在保持良好的用户体验性和灵活性之间找到一个最佳的平衡点。

下面的例子是使用HtmlUnitDriver。HtmlUnitDriver只会在内存中执行这段代码，不会弹出一个真实的页面。

```java

packageorg.openqa.selenium.example;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;

public class Example  {
    public static void main(String[] args) {
        // Create a new instance of the html unit driver
        // Notice that the remainder of the code relies onthe interface, 
        // not the implementation.
        WebDriver driver = new HtmlUnitDriver();

        // And now use this to visit Google
        driver.get("http://www.google.com");

        // Find the text input element by its name
        WebElement element = driver.findElement(By.name("q"));

        // Enter something to search for
        element.sendKeys("Cheese!");

        // Now submit the form. WebDriver will find theform for us from the element
        element.submit();

        // Check the title of the page
        System.out.println("Page title is: " +driver.getTitle());
    }
}

```

如果你想使用Firefox浏览器。你只需要将WebDriver driver = new FirefoxDriver()。前提是你的Firefox被安装在默认的位置。

<table>
<tr>
  <th>操作系统</th>
  <th>Firefox默认安装位置</th>
</tr>                               |
<tr>
  <td>Linux</td>
  <td>firefox (found using "which")</td>
</tr>
<tr>
  <td>Mac</td>
  <td>/Applications/Firefox.app/Contents/MacOS/firefox</td>
</tr>
<tr>
  <td>Windows</td>
  <td>%PROGRAMFILES%\Mozilla Firefox\firefox.exe</td>
</tr>
</table>

如果你的FireFox没有被安装在指定的位置，你可以设置“webdriver.firefox.bin”

环境变量的值来指定它的位置。在Java中可以使用如下代码：

```java

System.setProperty("webdriver.firefox.bin","thelocation of Firefox");

```

如果要使用Chrome浏览器的话相对麻烦些。你需要首先下载一个ChromeDriver（下载地址：http://code.google.com/p/chromedriver/downloads/list）。这个程序是由Chrome团队提供的，你可以看做它是链接WebDriver和Chrome浏览器的桥梁。然后启动ChromeDriver，你会得到一个Url及监听端口。然后使用webDriver = newRemoteWebDriver(url, DesiredCapabilities.chrome())创建一个ChromeWebDriver进行操作。当然你可以在一个子线程中启动ChromeDriver，并设置给WebDriver。

```java
        File file = new File(your chromedriverfile path);

   ChromeDriverService service = newChromeDriverService.Builder().usingChromeDriverExecutable(file).usingAnyFreePort().build();

        service.start();

WebDriver  webDriver = new ChromeDriver(service);

……

……

……

  service.stop();

```

 

WebDriver如何工作
---
WebDriver是W3C的一个标准，由Selenium主持。

具体的协议标准可以从<http://code.google.com/p/selenium/wiki/JsonWireProtocol#Command_Reference>查看。

从这个协议中我们可以看到，WebDriver之所以能够实现与浏览器进行交互，是因为浏览器实现了这些协议。这个协议是使用JOSN通过HTTP进行传输。

它的实现使用了经典的Client-Server模式。客户端发送一个requset，服务器端返回一个response。

我们明确几个概念。

**Client**

调用 WebDriverAPI的机器。

**Server**

运行浏览器的机器。Firefox浏览器直接实现了WebDriver的通讯协议，而Chrome和IE则是通过ChromeDriver和InternetExplorerDriver实现的。

**Session**

服务器端需要维护浏览器的Session，从客户端发过来的请求头中包含了Session信息，服务器端将会执行对应的浏览器页面。

**WebElement**

这是WebDriverAPI中的对象，代表页面上的一个DOM元素。

举个实际的例子，下面代码的作用是”命令”firefox转跳到google主页：

 
```java
       WebDriver driver = new FirefoxDriver();
        //实例化一个Driver
 
        driver.get("http://www.google.com");

``` 

在执行`driver.get("http://www.google.com")`这句代码时，client，也就是我们的测试代码向`remote server`发送了如下的请求：

`POSTsession/285b12e4-2b8a-4fe6-90e1-c35cba245956/url  post_data{"url":"http://google.com"}`  

通过post的方式请求localhost:port/hub/session/session_id/url地址，请求浏览器完成跳转url的操作。

如果上述请求是可接受的，或者说remote server是实现了这个接口，那么remote server会跳转到该post data包含的url,并返回如下的response

`{"name":"get","sessionId":"285b12e4-2b8a-4fe6-90e1-c35cba245956","status":0,"value":""}` 

该response中包含如下信息:

* name：remote server端的实现的方法的名称，这里是get，表示跳转到指定url；

* sessionId：当前session的id；

* status：请求执行的状态码，非0表示未正确执行，这里是0，表示一切ok不许担心；

* value：请求的返回值，这里返回值为空，如果client调用title接口，则该值应该是当前页面的title；

* 如果client发送的请求是定位某个特定的页面元素，则response的返回值可能是这样的：

`{"name":"findElement","sessionId":"285b12e4-2b8a-4fe6-90e1-c35cba245956","status":0,"value":{"ELEMENT":"{2192893e-f260-44c4-bdf6-7aad3c919739}"}}` 

`name,sessionId，status`跟上面的例子是差不多的，区别是该请求的返回值是ELEMENT:{2192893e-f260-44c4-bdf6-7aad3c919739}，表示定位到元素的id，通过该id，client可以发送如click之类的请求与 server端进行交互。

这个今天就讲到这里。以后有新东西再补充。

