---
layout: post
title: 使用MANIFEST.MF文件来track war包做持续部署
date: 2013-04-18 12:40
comments: true
categories: CI
tags: [MANIFEST.MF, 继续集成, Jenkins] 
---

在我工作的项目中有这样一个需求。当通过自动部署脚本将当前一个CI构建的WAR包部署到指定服务器后，需要验证该WAR包是否被部署成功。

在这个项目中，持续集成服务器使用的是[Jenkins]，构建脚本使用的是[maven]，向服务器的部署使用的是Groovy写的部署脚本，调用了[Tableuax] API。

在[Jenkins]上有两个job，一个CI job，一个dev job。
每次提交代码都会在[Jenkins]上trigger CI ob，这个job会执行配置的[maven]命令`mvn clean install`，如果构建成功，会自动trigger dev job。这个job会执行部署脚本，部署脚本负责调用[Tableuax] API将前一个job构建的war包部署到服务器上。

<!-- more -->

由于部署是调用[Tableuax] API来实现的，我们需要在部署完成以后验证此次部署是否成功。如何进行那？可以分为如下几个步骤。

**首先, 当[Jenkins]的第一个job构建war包时，将这次构建的一些信息写入到MANIFEST.MF文件中。**

MANIFEST.MF文件是Java平台下的Jar包或者war包中都普遍存在的一个文件。这个文件通常被放置在META-INF文件夹下，名称通常为MANIFEST.MF。它其实相当于一个properties文件，里面都是一些键值对，特殊之处是每个jar包或者war包至多只能有一个MANIFEST.MF文件。

那么如何在[Jenkins]运行build时将本次构建的相关信息写入到MANIFEST.MF文件那？那要借助于maven.war.plugin插件。

当一个[Jenkins] job被执行时，会自动设置一些环境变量，这些环境变量可以在shell script, batch command或者Maven POM中被访问。（查看所有的环境变量请看[这里](https://wiki.jenkins-ci.org/display/JENKINS/Building+a+software+project#Buildingasoftwareproject-JenkinsSetEnvironmentVariables )）。
所以我们可以在项目的pom.xml加入以下的plugin来设置一些build信息到MANIFEST.MF文件中。

```xml

    <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-war-plugin</artifactId>
        <version>2.2</version>
        <configuration>
            <archive>
                <manifest>
                    <addDefaultImplementationEntries>true</addDefaultImplementationEntries>
                </manifest>
                <manifestEntries>
                    <Build-Number>${BUILD_NUMBER}</Build-Number>
                    <Job-Name>${JOB_NAME}</Job-Name>
                    <Build-Url>${BUILD_URL}</Build-Url>
                    <Svn-Revision>${SVN_REVISION}</Svn-Revision>
                    <Timestamp>${maven.build.timestamp}</Timestamp>
                </manifestEntries>
            </archive>
        </configuration>
    </plugin>

```

[Jenkins] job执行完毕后，在打包好的WAR包中就含有一个MANIFEST.MF文件了。以下是一个示例。

```xml

Manifest-Version: 1.0
Implementation-Title: myWebApp
Implementation-Version: 1.1-SNAPSHOT
Job-Name: myWebApp-CI
Built-By: bowen
Created-By: Apache Maven
Timestamp: 20130417-1654
Build-Number: 118
Svn-Revision: 5606
Implementation-Vendor-Id: myWebApp
Build-Url: http://10.70.21.74:80/job/myWebApp/118/
Build-Jdk: 1.6.0_18
Implementation-Build: 2013-04-17 16:54:54
Archiver-Version: Plexus Archiver

```

**然后，创建一个页面来显示这些build信息，以便能随时查看当前部署在服务器上的war包的build number是多少，是由谁构建的，构建时间等信息。第二个job的部署脚本也可以通过这个页面得到build number，以此来判别部署的是否是想要的版本。**

这就牵扯到对MANIFEST.MF文件的读取了。有一个现成的库用于读取jar包或者war包中的MANIFEST.MF文件信息。

在项目的pom.xml文件中加入对这个库的依赖。

```xml

<dependency>  
	<groupId>com.jcabi</groupId>  
	<artifactId>jcabi-manifests</artifactId>  
	<version>0.7.17</version> 
</dependency>

```

对于war包而言，需要通过SevletContext来获取当前的MANIFEST.MF文件。首先需要创建一个继承自`ServletContextListener`接口的类来将ServletContext设置给Manifests对象。

```java

package com.thoughtworks

public class ContextListener implements ServletContextListener {  

	@Override  
	public void contextInitialized(ServletContextEvent event {    
		Manifests.append(event.getServletContext());  
	} 
}

```

然后需要在web.xml配置文件中将这个Listener加入到Listener列表中。

```xml

<listener>
<listener-class>com.thoughtworks.ContextListener</listener-class>
</listener>

```

这样就可以在Controller里直接使用Manifests对象来获取MANIFEST.MF文件记录的各种值了。

```java

String buildNumber = Manifests.read("Build-Number");
String buildJdk = Manifests.read("Build-Jdk");
String BuiltBy = Manifests.read("Built-By");
String timestamp = Manifests.read("Timestamp");
...

```

再建立一个jsp页面用于显示这些值即可。


**最后，部署脚本获取该页面的内容，判断页面内容中的build number是否为期望部署的build number。**

这只是判断部署的war包是不是期望的war包。如果想要验证其是完全可以工作的，就需要部署脚本调用smoke test来进行功能性测试了。这个留到下次再讲。

[Jenkins]: http://jenkins-ci.org/
[maven]: http://maven.apache.org/
[Tableuax]: http://www.incanica.com/tour/whytableaux

