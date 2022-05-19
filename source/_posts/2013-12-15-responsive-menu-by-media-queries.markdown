---
layout: post
title: 使用media queries实现一个响应式的菜单
date: 2013-12-15 21:56
comments: true
categories: design
tags: [menu] 
---

Media queries是CSS3引入的一个特性，使用它可以方便的实现各种响应式效果。在这个示例中我们将会使用media queries实现一个响应式的菜单。这个菜单会根据当前浏览器屏幕的大小变化而自动的呈现出不同的样式。如果浏览器屏幕大于800px，菜单则会显示在页面左侧；如果浏览器屏幕介于401px到800px之间，菜单则会显示在页面上方，与其他内容是上下关系；如果屏幕小于400px，则菜单仍在页面上方，但是菜单会变为下拉列表形式。

<!-- more -->

预览地址: [http://htmlpreview.github.io/?https://github.com/huangbowen521/ResponsiveDesignTrial/blob/master/responsiveMenu.html](http://htmlpreview.github.io/?https://github.com/huangbowen521/ResponsiveDesignTrial/blob/master/responsiveMenu.html)

要实现这样的特效，首先要创建一个下拉列表形式的菜单，如下所示。

```html 

<div class="small-menu">
    <form>
        <select name="URL">
            <option value="home.html">我的博客首页</option>
            <option value="blog.html">我的博客列表</option>
            <option value="whoami.html">我的个人简介</option>
        </select>
    </form>
</div>

```

然后还要创建一个使用了ul和li元素的菜单，放置在上面菜单的后面。

```html

<div class="large-menu">
    <ul>
        <li>
            <a href="home.html">我的博客首页</a>
        </li>
        <li>
            <a href="blog.html">我的博客列表</a>
        </li>
        <li>
            <a href="whoami.html">我的个人简介</a>
        </li>
    </ul>
</div>

```

最后再加一个div元素，用来放置一些文本以填充页面其他部分。

```html

<div class="content">
    <p>
        上周五的时候我对某个项目做了一个更改，将里面的构建脚本由maven换成了gradle。原因之一是因为maven的配置太繁琐，由于其引入了lifecycle的机制，
        导致其不够灵活，而gradle作为用groovy写的DSL，代码清爽、简单、灵活。原因之二是我们所有的项目构建都换成了gradle，为了保持技术栈单一，此项目
        做迁移也是大势所趋。</p>
</div>

```

接下来就要设置media queries了，指定在不同屏幕尺寸下菜单表现出不同的样式。

当屏幕宽度小于400px时，我们需要隐藏ul菜单，显现下拉框菜单。

```css

@media screen and ( max-width: 400px ) {

        .small-menu {
            display: inline;
        }

        .large-menu {
            display: none;
        }
    }


```

当屏幕介于401px和800px时，显示ul菜单，并且将其设置为水平排列。

```css

@media screen and ( min-width: 401px ) and ( max-width: 800px ) {

    .small-menu {
        display: none;
    }

    .large-menu {
        display: inline;
        width: 100%;
    }

    .large-menu ul {
        list-style-type: none;
    }

    .large-menu ul li {
        display: inline;
    }

    .content {
        width: 100%;
    }
}

```

当屏幕尺寸大于800px时，则将ul菜单设置为页面左边，并且菜单排列为垂直排列。

```css

@media screen and ( min-width: 801px ) {

    .small-menu {
        display: none;
    }

    .large-menu {
        display: inline;
        float: left;
        width: 20%;
    }

    .content {
        float: right;
        width: 80%;

    }
}

```

这样就简单实现了一个响应式的菜单，其实主要就是根据media queries来设置screen的条件，根据不同screen宽度来给页面元素设置对应的样式。当屏幕宽度发生变化时，会自动应用相应的样式。

代码已经被放置到了github上了，地址是[https://github.com/huangbowen521/ResponsiveDesignTrial](https://github.com/huangbowen521/ResponsiveDesignTrial)




