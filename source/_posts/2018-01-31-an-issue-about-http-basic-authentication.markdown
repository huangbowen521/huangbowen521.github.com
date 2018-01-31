---
layout: post
title: 一个HTTP Basic Authentication引发的异常
date: 2018-01-31 16:39:59 +0800
comments: true
categories: Java
---

这几天在做一个功能，其实很简单。就是调用几个外部的API，返回数据后进行组装然后成为新的接口。其中一个API是一个很奇葩的API，虽然是基于HTTP的，但既没有基于SOAP规范，也不是Restful风格的接口。还好使用它也没有复杂的场景。只是构造出URL，发送一个HTTP的get请求，然后给我返回一个XML结构的数据。

<!-- more -->

我使用了Spring MVC中的RestTemplate作为客户端，然后引入了Jackson-dataformat-xml作为xml映射为对象的工具库。由于集成外部API的事情已经做了很多次了，集成这个API也是轻车熟路，三下五除二就完成了。

接下来为了验证连通性，我先在SoapUI里配置了该外部API的某个测试环境，尝试发送了一个Get请求，成功收到了Response。然后我把自己的程序运行起来，尝试通过自己的程序调用该API，结果返回了HTTP 500错误，即“internal server error”。

这可奇了怪了。我第一反应是程序中对外部API的配置和SoapUI中的配置不一样。我仔细对比了发送请求的URL，需要的HTTP header以及用作验证的username和password都是完全一致的。这个问题被排除。

接下来我想再仔细看看Response，能否找到什么蛛丝马迹。仔细查看了Response的header和body，发现header一切正常，body是个空的body，没有提供任何的可用信息。

然后我能想到的另一个解决方案就是联系该外部API的团队，让他们帮忙看看我发送了请求之后，为什么服务器会返回500。但可惜这是一个很老的服务了，找到该团队的人并且排期帮我看log至少要花好几天的时间了。而且既然SoapUI能调用成功，而应用程序却调用不成功，问题多半还是出在我们这。

接下来我想既然问题有可能出在我们这，那么肯定是request有差异。由于我发的是一个Get请求，没有body实体，URL又完全一样，那么问题很可能出在request的header上。这个API需要request中包含两个自定义的header，而我在SoapUI以及自己的程序中都已经配置了。那问题会在哪里哪？

既然在SoapUI里无法重现这个问题，我就使用了Chrome插件版的POSTMAN，通过它配置了该API的调用。然后奇迹出现了，我竟然在POSTMAN中重现了这个问题。当我看到在POSTMAN也返回了500 error后，我思考了5秒钟，猜到了原因。问题很可能是出在了Authentication这个header上面。

要说这个问题，还要从HTTP的Basic Authentication说起。Basic Authentication是HTTP实现访问控制的最简单的一种技术。HTTP Client端会将用户名和密码组合后使用Base64加密，生成key为‘Authentication’，value为‘Basic BASE64CODE’的HTTP header，发送给服务器端以便进行Basic认证方式。

但这个经典的Basic Authentication是要经历两步的。第一步，客户端发送不带Authentication header的HTTP请求，服务器检查后发现受访的资源需要认证，就会返回HTTP Status 401，表示未授权，客户端发现服务器端返回401后，会再构造一个新的请求，这次包含了Authentication header，服务器接收后验证通过，返回资源。

那么我在自己的应用程序和POSTMAN中调用返回500 internal server error的原因是当第一次给Server发送不带Authentication header的HTTP请求时，Server竟然返回了HTTP Status 500。其实它应该返回401，这样HTTP Client会再发一个包含了Authentication的新请求。由于它返回了500，HTTP Client认为服务器有问题，就停止处理了。

那为什么在SoapUI中调用可以成功那？那是因为SoapUI使用的Http client在发第一次请求时就已经设置了Authentication header，所以就没有问题。这样可以避免重复发请求的现象。这种行为叫做‘preemptive authentication’(抢先验证)，在SoapUI中你可以选择是否启用该行为。具体可以参见[How To Authenticate SOAP Requests in SoapUI](https://www.SoapUI.org/soap-and-wsdl/authenticating-soap-requests.html)。

所以问题的根源在于该外部API在实现Basic Authentication时没有完全遵循规范，**这锅我们不背**。

解决方案有两种。第一种是让该外部API遵循Basic Authentication的规范，如果请求未授权应该返回401而不是500。不过我说过这是一个很古老的API了，让它们改要等到猴年马月了。

第二种就是我的应用程序在给该外部API发送请求时，第一次就设置Authentication header。我们用的是RestTemplate，而RestTemplate底层使用的是Apache Http Client 4.0+版本。要注入这个header很简单，在实例化RestTemplate后，给其多加一个Intecepter。

```java

restTemplate.getInterceptors().add(
  new BasicAuthorizationInterceptor("username", "password"));

```

加上这一行代码后，运行程序，顺利的得到了Response，世界清静了。

最后一个问题，为什么Http Client当配置了用户名和密码后，不主动的启用‘preemptive authentication’那？毕竟可以少发很多请求啊。这是Apache官方给出的原因：

>> HttpClient does not support preemptive authentication out of the box, because if misused or used incorrectly the preemptive authentication can lead to significant security issues, such as sending user credentials in clear text to an unauthorized third party. Therefore, users are expected to evaluate potential benefits of preemptive authentication versus security risks in the context of their specific application environment.
Nonetheless one can configure HttpClient to authenticate preemptively by prepopulating the authentication data cache.

----

扩展阅读：

* [Chapter 4. HTTP authentication](https://hc.apache.org/httpcomponents-client-ga/tutorial/html/authentication.html)
* [Basic Authentication with the RestTemplate](http://www.baeldung.com/how-to-use-resttemplate-with-basic-authentication-in-spring)
* [How To Authenticate SOAP Requests in SoapUI](https://www.SoapUI.org/soap-and-wsdl/authenticating-soap-requests.html)
* [Basic access authentication](https://en.wikipedia.org/wiki/Basic_access_authentication)
* [HttpClient basic authentication](https://www.javaworld.com/article/2092353/core-java/httpclient-basic-authentication.html)





