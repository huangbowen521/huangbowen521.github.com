---
layout: post
title: 使用快捷键，快到极致
date: 2013-04-06 15:21
comments: true
categories: 总结
tags: [shortcuts, intellij, extreme]
---


前段时间曾经写过一篇文章，[《优秀程序员无他-善假于物也》](http://www.cnblogs.com/huang0925/archive/2013/03/24/2978181.html)。其中谈到一点是优秀的程序员必须要能灵活的掌握常用软件的快捷键。对于程序员来说，每天使用时间最长的软件恐怕就是IDE（Integrated Development Environment）了。如果你是C#的程序员，那么就基本非Visual Studio莫属了。而如果你是Java的程序员，那么eclipse，myeclipse或者Intellij都有人用之。如果你是Ruby等动态语言的程序员，那么Vim、Emacs、RubyMIne…有太多的选择可以成为你的IDE。

<!-- more -->

下面我就用Intellij来给大家演示下使用快捷键是多么的强大，能提高多大的效率。（以下所使用的快捷键在eclipse中基本都有对应的快捷键。）

大家先看一个简单的类。

```java

public class BeanConfig {
    private String name;

    private String className;

    public BeanConfig(String name, String className) {
        this.name = name;
        this.className = className;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }
}

```

这是一个很普通的Value Object。创建这个类并写完这些代码需要多长时间那？不同人会给出不同的答案。使用快捷键与不使用快捷键有天壤之别。

不使用快捷键，你需要手写全部的代码。而使用快捷键，最多你只需要敲半行代码。这半行代码就是构造函数里的那两个参数`String name, String className`。

下面我就一步步的演示如何使用Intellij的快捷键来创建这个Value Object。

- 使用`Ctrl+1`切换到project列表项，使用使用上下箭头键选择放置这个Value Object的package。

- 使用`Alt+Insert`键调出创建对话框，选择new class并回车。

	{% img /images/INew.png %}

	在弹出的`Create New Class`对话框中键入类名，并回车。

	{% img /images/ICNC.png %}

	最后生成如下的代码。

```java

public class BeanConfig {
}

```

- 按esc键将光标移动到editor中，按下`alt+Insert`键调出`Generate`对话框，选择`Constructor`项并回车。这样会生成一个无参数的构造函数。

{% img /images/IGenerate.png %}

这是生成的代码。

```java

public class BeanConfig {
    public BeanConfig() {
    }
}

```

- 光标移动到构造函数名后的小括号内，敲入这样的代码`String name, String className`。

此时代码如下。

```java

public class BeanConfig {
    public BeanConfig(String name, String className) {
    }
}

```

- 光标保持在构造函数的参数列表中，使用`alt+Enter`快捷键，选择`Create Fields For Constructor Parameters`条目，然后回车。

{% img /images/ICF.png %}

在弹出的对快框中使用`shift+下箭头`选中这两个field并回车。

{% img /images/ICCP.png %}

生成的代码如下。

```java
public class BeanConfig {
    private final String name;
    private final String className;

    public BeanConfig(String name, String className) {
        this.name = name;
        this.className = className;
    }
}
```

- 删除`name`和`className`的`final`修饰符。最快捷的方法是光标移动到`final`处，按`Ctrl+W`键选中整个字符，然后按`Delete`键。

此时代码如下。

```java

public class BeanConfig {
    private String name;
    private String className;

    public BeanConfig(String name, String className) {
        this.name = name;
        this.className = className;
    }
}
```

- 光标移动到任意一个field处，使用`alt+Insert`弹出Generate对话框，选择`Getter and Setter`条目按回车。

{% img /images/IGGAS.png %}

在弹出的`Select Fields to Generate Getters and Setters`对话框中，使用`shift+下箭头`选中两个field，按回车。

{% img /images/ISFGG.png %}

最终代码生成。

```java
public class BeanConfig {
    private String name;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    private String className;

    public BeanConfig(String name, String className) {
        this.name = name;
        this.className = className;
    }
}
```

整个过程中不需要动一下鼠标，这意味着你的双手根本不需要离开键盘。使用快捷键比不使用快捷键效率至少提高5倍，而且还不会出错。最重要的一点是它能让我们的大脑从这些繁琐的体力劳动中解脱出来，从而集中到更需要发挥脑力劳动的地方。

其实灵活使用IDE的快捷键是一门大学问，我在和同事pair的过程中经常能从他们身上学到一些使用IDE的快捷键的妙处。以后有时间会专门整理出来share给大家。




