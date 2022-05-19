---
layout: post
title: 使用WebDriver遇到的那些坑
date: 2013-06-25 22:00
comments: true
categories: Testing
tags: [WebDriver, Selenium, practice]
---

{% img /images/automatedRobot.png %}

在做web项目的自动化端到端测试时主要使用的是[Selenium WebDriver]来驱动浏览器。[Selenium WebDriver]的优点是支持的语言多，支持的浏览器多。主流的浏览器Chrome、Firefox、IE等都支持，手机上的浏览器Android、IPhone等也支持，甚至还支持[PhantomJS](http://phantomjs.org/)（由于PhantomJS跑测试时并不需要渲染元素，所以执行速度快）。

<!-- more -->

但是我在使用[Selenium WebDriver]时，遇到了很多坑。这些问题，有的是因为[Selenium WebDriver]与浏览器不同版本之间兼容性的问题，有的是[Selenium WebDriver]本身的bug，当然也不乏自己对[Selenium WebDriver]某些功能理解不透彻。我花时间总结了一下，分享给大家，希望大家以后遇到问题可以避过这些坑，少走弯路。另外也总结了一些使用WebDriver的比较好的实践，也一并分享给大家。

* **WebDriver每次启动一个Firefox的实例时，会生成一个匿名的profile，并不会使用当前Firefox的profile。这点一定要注意。比如如果访问被测试的web服务需要通过代理，你想直接设置Firefox的代理是行不通的，因为WebDriver启动的Firefox实例并不会使用你这个profile，正确的做法是通过FirefoxProfile来设置。**

```java

public WebDriver create() {

	FirefoxProfile firefoxProfile = new FirefoxProfile();
	firefoxProfile.setPreference("network.proxy.type",1);
	firefoxProfile.setPreference("network.proxy.http",yourProxy);
	firefoxProfile.setPreference("network.proxy.http_port",yourPort);
	firefoxProfile.setPreference("network.proxy.no_proxies_on","");

	return new FirefoxDriver(firefoxProfile);

}

```

通过FirefoProfile也可以设置Firefox其它各种配置。如果要默认给Firefox安装插件的话，可以将插件放置到Firefox安装目录下的默认的plugin文件夹中，这样即使是使用一个全新的profile也可以应用此plugin。

* **使用WebDriver点击界面上Button元素时，如果当前Button元素被界面上其他元素遮住了，或没出现在界面中（比如Button在页面底部，但是屏幕只能显示页面上半部分），使用默认的WebElement.Click()可能会触发不了Click事件。**

修正方案是找到该页面元素后直接发送一条Click的JavaScript指令。

```java

((JavascriptExecutor)webDriver).executeScript("arguments[0].click();", webElement);

```

* **当进行了一些操作发生页面跳转时，最好加一个Wait方法等待page load完成再进行后续操作。方法是在某个时间段内判断document.readyState是不是complete。**

```java

    protected Function<WebDriver, Boolean> isPageLoaded() {
        return new Function<WebDriver, Boolean>() {
            @Override
            public Boolean apply(WebDriver driver) {
                return ((JavascriptExecutor) driver).executeScript("return document.readyState").equals("complete");
            }
        };
    }

    public void waitForPageLoad() {
        WebDriverWait wait = new WebDriverWait(webDriver, 30);
        wait.until(isPageLoaded());
    }

```

* **如果页面有Ajax操作，需要写一个Wait方法等待Ajax操作完成。方式与上一条中的基本相同。比如一个Ajax操作是用于向DropDownList中填充数据，则写一个方法判断该DropDownList中元素是否多余0个。**

```java

    private Function<WebDriver, Boolean> haveMoreThanOneOption(final By element) {
        return new Function<WebDriver, Boolean>() {
            @Override
            public Boolean apply(WebDriver driver) {
                WebElement webElement = driver.findElement(element);
                if (webElement == null) {
                    return false;
                } else {
                    int size = webElement.findElements(By.tagName("option")).size();
                    return size >= 1;
                }
            }
        };
    }

    public void waitForDropDownListLoaded() {
        WebDriverWait wait = new WebDriverWait(webDriver, 30);
        wait.until(isPageLoaded());
    }

```

以此类推，我们可以判断某个元素是否呈现、某个class是否append成功等一系列方法来判断ajax是否执行完成。


* **如果网站使用了JQuery的动画效果，我们在运行测试的时候其实可以disable JQuery的animation，一方面可以加快测试的速度，另一方面可以加强测试的稳定性（如果启用了Animation，使用WebDriver驱动浏览器时可能会出现一些无法预料的异常）。**

```java

((JavascriptExecutor)driver).executeScript("jQuery.fx.off=true");

```

* **由于WebDriver要驱动浏览器，所以测试运行的时间比较长，我们可以并行跑测试以节省时间。如果你使用的是maven构建工具，可以配置surefire plugin时，在configruation节点加入以下配置。**

```xml

<parallel>classes</parallel>
<threadCount>3</threadCount>
<perCoreThreadCount>false</perCoreThreadCount>

```

*  **当测试fail的时候，如果当前使用的WebDriver实现了TakesScreenshot接口，我们就可以调用相应的方法截下当前浏览器呈现的web页面，这样有利于快速定位出错的原因。**

```java

    public void getScreenShot() {
        if (webDriver instanceof TakesScreenshot) {
            TakesScreenshot screenshotTaker = (TakesScreenshot) webDriver;
            File file = screenshotTaker.getScreenshotAs(savePath);
        }
    }

```

* **如果页面弹出了浏览器自带的警告框（使用JavaScript的Alert方法），[Selenium WebDriver]在点选次警告框时会偶发性失败。具体原因还未查明。解决方案是尽量不使用Alert方法的警告框，而是自己实现模式窗口（比如Jquery UI的模式窗口）来实现警告框效果。这样即保证了测试的稳定性，另外我们自己可以控制警告框的样式，给用户带来更好的体验。**

* **经常更新Selenium的版本。注意经常上Selenium的[官网](http://docs.seleniumhq.org/)看是否发布了新的版本，新的版本都修复了那些bug，如果包含你遇到的bug，就可以升级到目前的版本。**


[Selenium WebDriver]: http://docs.seleniumhq.org/projects/webdriver/


