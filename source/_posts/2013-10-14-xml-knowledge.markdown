---
layout: post
title: XML相关知识全接触（一）
date: 2013-10-14 00:32
comments: true
categories: XML
tags: [xml, xsd, xsl, xslt] 
---

{% img /images/xml.png 400 %}

XML文件格式已经出来很久了。他的风头如今在JSON、YAML等新兴文件格式的冲击下已经显的不那么强劲。但是XML仍然是当今世界上使用最广泛的文件格式。围绕着它也有一大堆的概念和知识点。所以我们还是很有必要全面了解下。

<!-- more -->

## XML

XML全称为eXtensible Markup Language，即可扩展标记语言。其被设计用来传输及存储数据。

XML与HTML看似比较相似，但是其设计目的并不相同。

* XML用来传输及存储数据，主要关注数据是什么。

* HTML用来显示数据，主要关注数据看起来是什么样。

* HTML的tag是预定义的，比如说table标签，浏览器会知道它是什么含义。

* XML的tag不是预定义的，需要自己设计tag并描述tag的含义。XML中的tag如果不借助XSLT文件，浏览器只会以简单的文本方式展示。

很多人认为HTML是XML文件的一个子集。其实这种观点是错误的，因为HTML的实现并未严格遵循XML的语法。比如XML要求每个tag必须要有闭合标记，XML的tag是大小写敏感的，XML给tag添加的属性必须要使用引号包起来…这些语法要求HTML都不满足。

请看XML的一个示例。

```xml book.xml 

<?xml version="1.0" encoding="ISO-8859-1"?>
<book>
    <name>Effective JavaScript</name>
    <category>Program Language</category>
    <author>Bowen</author>
    <description>This book is about JavaScript Language.</description>
</book>

```
这是一个简单的XML文件。第一行说明了xml的版本及编码类型。接下来是一个根节点book，根节点可以包含很多子节点。

### XML命名空间

由于XML的tag并不像HTML那样是预定义的，那么很有可能两个XML中的同名tag具有不同的含义。那么在合并XML等操作时势必会造成冲突。解决的办法就是给XML的tag加上命名空间（即namespace），每一个namespace都可以指定一个前缀。这些前缀会区分同名tag。

假设这里有另一个xml文件。

```xml anotherBook.xml

<?xml version="1.0" encoding="ISO-8859-1"?>
<book>
    <name>Rework</name>
    <page>120</page>
    <publishDate>2013-10-08</publishDate>
</book>

```

如果我们要合并这两个xml节点到同一个xml文件中时，不加namespace会发生冲突，因为含有同名的tag，其子节点的结构并不相同。接下来我们给其加上命名空间并合并。

```xml combined.xml

<root>
<ns1:book xmlns:ns1="http://www.huangbowen.net/ns1">
    <ns1:name>Effective JavaScript</ns1:name>
    <ns1:category>Program Language</ns1:category>
    <ns1:author>Bowen</ns1:author>
    <ns1:description>This book is about JavaScript Language.</ns1:description>
</ns1:book>

<ns2:book xmlns:ns2="http://www.huangbowen.net/ns2">
     <ns2:name>Rework</ns2:name>
    <ns2:page>120</ns2:page>
    <ns2:publishDate>2013-10-08</ns2:publishDate>
     </ns2:book>
</root>


```

xmlns是xml namespace的缩写。引号后面是tag的前缀。这个前缀可以省略，比如`xmlns="http://www.huangbowen.net/ns1"`,相当于没有前缀的tag自动应用默认的命名空间。需要注意的是命名空间的URI只是给命名空间提供一个唯一的标识，xml解析器并不会访问这个URI来获取任何信息。很多公司习惯将这个URI一个web页面，该web页面描述了该namespace的相关信息。

## XSD

XSD全称为XML Schema Definition,即XML结构定义语言。每个XSD文件是对一个XML文件的结构定义。
由于XML中的tag并不是预定义的，那么每人都可以创建自己的XML结构文档。如果你想让别人按照你的标准创建一份xml文件，你可以使用XSD文件来描述你的标准。

这是针对本文示例book.xml文件的一个XSD文件。

```xml book.xsd

<xs:schema attributeFormDefault="unqualified" elementFormDefault="qualified"
           xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xs:element name="book">
        <xs:complexType>
            <xs:sequence>
                <xs:element type="xs:string" name="name"/>
                <xs:element type="xs:string" name="category"/>
                <xs:element type="xs:string" name="author"/>
                <xs:element type="xs:string" name="description"/>
            </xs:sequence>
        </xs:complexType>
    </xs:element>
</xs:schema>

```

从上可以看出其实XSD文件本身就是一个XML文件，它遵循XML语法，比如每个tag都需要有结束标记，必须有且只有一个根节点等。

在一个XML文件中可以添加其Schema的引用信息。

```xml book.xml

<?xml version="1.0" encoding="ISO-8859-1"?>
<ns1:book xmlns:ns1="http://www.huangbowen.net/ns1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:targetLocation="http://www.huangbowen.net/book.xsd">
    <ns1:name>Effective JavaScript</ns1:name>
    <ns1:category>Program Language</ns1:category>
    <ns1:author>Bowen</ns1:author>
    <ns1:description>This book is about JavaScript Language.</ns1:description>
</ns1:book>

```

在IDE中，如果你的XML节点没有遵守你引用的Schema中的定义，就会给出错误提醒。


## XSLT

XSLT全称为EXtensible Stylesheet Language Transformations。 XSLT用于将XML文档转换为XHTML或其他XML文档。

在讲XSLT之前我们先讲讲XSL。XSL全称为Extensible Stylesheet Language,即可扩展样式表语言。众所周知，CSS是HTML文件的样式表，而XSL则是XML文件的样式表。XSL文件描述了XML文件应该如何被显示。

其实XSL不仅仅是样式表语言，它主要包含3部分:

* XSLT - 用来转换XML文档

* XPath - 查询和操作XML文档中的节点

* XSL-FO - 格式化XML文档

XSLT使用XPath来查找XML中的元素。

XSLT通过一个xml文件来定义源xml文件与目标文件之间的转换关系。该xml文件必须以`<xsl:stylesheet> `或`<xsl:transform>`作为根节点。

对于本文的示例book.xml,如果我们使用浏览器打开显示效果如下。

{% img /images/bookxml.png 600 %}

现在我们创建一个XSLT文件将其转换为一个HTML文件。

```html book.xsl

<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html>
  <body>
  <h2>My Book</h2>
  <table border="1">
    <tr>
      <td>name</td>
      <td><xsl:value-of select="book/name" /></td>
    </tr>
    <tr>
      <td>category</td>
      <td><xsl:value-of select="book/category" /></td>
    </tr>
    <tr>
      <td>author</td>
      <td><xsl:value-of select="book/author" /></td>
    </tr>
    <tr>
      <td>description</td>
      <td><xsl:value-of select="book/description" /></td>
    </tr>
  </table>
  </body>
  </html>
</xsl:template>

</xsl:stylesheet>

```

然后我们在book.xml文件中加入对这个XSLT文件的引用。

```xml book.xml

<?xml version="1.0" encoding="ISO-8859-1"?>
<?xml-stylesheet type="text/xsl" href="book.xsl"?>
<book>
    <name>Effective JavaScript</name>
    <category>Program Language</category>
    <author>Bowen</author>
    <description>This book is about JavaScript Language.</description>
</book>

```

接下来我们再用浏览器打开book.xml文件，发现显示变成了这样。是不是很神奇？

{% img /images/bookxmlwithxslt.png 600 %}

注意如果你使用chrome打开该book.xml文件，请设置chrome的`--allow-file-access-from-files`属性，这样chrome才允许加载本地的xsl文件。解决方案看这里：<http://stackoverflow.com/questions/3828898/can-chrome-be-made-to-perform-an-xsl-transform-on-a-local-file>


OK，这篇文章讲的够多了，下篇接着讲XPath，XML to Object以及XML文档格式与近来风头强劲的JSON、YAML格式的比较。













