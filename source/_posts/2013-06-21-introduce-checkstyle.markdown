---
layout: post
title: CheckStyle, 强制你遵循编码规范
date: 2013-06-21 13:53
comments: true
categories: java
tags: [CheckStyle] 
---

{% img /images/CheckStyle.png %}


如今代码静态检查越来越重要，已经成为构建高质量软件的不可或缺的一个验证步骤。如果你使用的是java语言，那么[CheckStyle]则是一个利器。
[CheckStyle]能够帮助程序员检查代码是否符合制定的规范。通过将[CheckStyle]的检查引入到项目构建中，可以强制让项目中的所有的开发者遵循制定规范，而不是仅仅停留在纸面上。如果发现代码违反了标准，比如类名未以大写开头、单个方法超过了指定行数、甚至单个方法抛出了3个以上的异常等。这些检查由于是基于源码的，所以不需要编译，执行速度快。

<!-- more -->

[CheckStyle]有针对不同IDE和构建工具的各种插件，方便开发者随时随地对代码进行静态检查。下面就讲解下如何将[CheckStyle]引入到maven构建中。

## 配置CheckStyle插件

在maven中一个名为`maven-checkstyle-plugin`的插件，用于执行[CheckStyle] task。下面是一个简单的配置。

```xml
	<plugin>
	    <groupId>org.apache.maven.plugins</groupId>
	    <artifactId>maven-checkstyle-plugin</artifactId>
	    <version>2.10</version>
	    <executions>
	        <execution>
	            <id>checkstyle</id>
	            <phase>validate</phase>
	            <goals>
	                <goal>check</goal>
	            </goals>
	            <configuration>
	                <failOnViolation>true</failOnViolation>
	            </configuration>
	        </execution>
	    </executions>
    </plugin>

```

我们定义了在maven lifecycle的validate阶段执行check task，并且如果发现有违反标准的情况就会fail当前的build。

maven-checkstyle-plugin内置了4种规范.

* config/sun_checks.xml 
* config/maven_checks.xml
* config/turbine_checks.xml
* config/avalon_checks.xml 

其中sun_checks.xml为默认值。如果想要使用其他三种规范，则只需配置configuration。下面是使用maven_checks.xml的示例。

```xml
    <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-checkstyle-plugin</artifactId>
        <version>2.10</version>
        <configuration>
            <configLocation>config/maven_checks.xml</configLocation>
        </configuration>
        <executions>
            <execution>
                <id>checkstyle</id>
                <phase>validate</phase>
                <goals>
                    <goal>check</goal>
                </goals>
                <configuration>
                    <failOnViolation>true</failOnViolation>
                </configuration>
            </execution>
        </executions>
    </plugin>

```

## 自定义规范文件
我们可以使用默认的规范未见，当然也支持自定义。下面是google的一个checkstyle规范文件。


```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE module PUBLIC
        "-//Puppy Crawl//DTD Check Configuration 1.3//EN"
        "http://www.puppycrawl.com/dtds/configuration_1_3.dtd">

<!-- This is a checkstyle configuration file. For descriptions of
what the following rules do, please see the checkstyle configuration
page at http://checkstyle.sourceforge.net/config.html -->

<module name="Checker">


    <module name="RegexpSingleline">
        <!-- Requires a Google copyright notice in each file.
          Code intended to be open-sourced may have a multi-line copyright
          notice, so that this required text appears on the second line:
          <pre>
            /*
             * Copyright 2008 Google Inc.
             *
             * (details of open-source license...)
          </pre>
        -->
        <property name="format"
                  value="^(//| \*) Copyright (\([cC]\) )?[\d]{4}(\-[\d]{4})? (Google Inc\.).*$" />
        <property name="minimum" value="1" />
        <property name="maximum" value="10" />
        <property name="message" value="Google copyright is missing or malformed." />
        <property name="severity" value="error" />
    </module>

    <module name="FileTabCharacter">
        <!-- Checks that there are no tab characters in the file.
        -->
    </module>

    <module name="NewlineAtEndOfFile"/>

    <module name="RegexpSingleline">
        <!-- Checks that FIXME is not used in comments.  TODO is preferred.
        -->
        <property name="format" value="((//.*)|(\*.*))FIXME" />
        <property name="message" value='TODO is preferred to FIXME.  e.g. "TODO(johndoe): Refactor when v2 is released."' />
    </module>

    <module name="RegexpSingleline">
        <!-- Checks that TODOs are named.  (Actually, just that they are followed
             by an open paren.)
        -->
        <property name="format" value="((//.*)|(\*.*))TODO[^(]" />
        <property name="message" value='All TODOs should be named.  e.g. "TODO(johndoe): Refactor when v2 is released."' />
    </module>

    <!-- All Java AST specific tests live under TreeWalker module. -->
    <module name="TreeWalker">

        <!--

        IMPORT CHECKS

        -->

        <module name="RedundantImport">
            <!-- Checks for redundant import statements. -->
            <property name="severity" value="error"/>
        </module>

        <module name="ImportOrder">
            <!-- Checks for out of order import statements. -->

            <property name="severity" value="warning"/>
            <property name="groups" value="com.google,android,junit,net,org,java,javax"/>
            <!-- This ensures that static imports go first. -->
            <property name="option" value="top"/>
            <property name="tokens" value="STATIC_IMPORT, IMPORT"/>
        </module>

        <!--

        JAVADOC CHECKS

        -->

        <!-- Checks for Javadoc comments.                     -->
        <!-- See http://checkstyle.sf.net/config_javadoc.html -->
        <module name="JavadocMethod">
            <property name="scope" value="protected"/>
            <property name="severity" value="warning"/>
            <property name="allowMissingJavadoc" value="true"/>
            <property name="allowMissingParamTags" value="true"/>
            <property name="allowMissingReturnTag" value="true"/>
            <property name="allowMissingThrowsTags" value="true"/>
            <property name="allowThrowsTagsForSubclasses" value="true"/>
            <property name="allowUndeclaredRTE" value="true"/>
        </module>

        <module name="JavadocType">
            <property name="scope" value="protected"/>
            <property name="severity" value="error"/>
        </module>

        <module name="JavadocStyle">
            <property name="severity" value="warning"/>
        </module>

        <!--

        NAMING CHECKS

        -->

        <!-- Item 38 - Adhere to generally accepted naming conventions -->

        <module name="PackageName">
            <!-- Validates identifiers for package names against the
              supplied expression. -->
            <!-- Here the default checkstyle rule restricts package name parts to
              seven characters, this is not in line with common practice at Google.
            -->
            <property name="format" value="^[a-z]+(\.[a-z][a-z0-9]{1,})*$"/>
            <property name="severity" value="warning"/>
        </module>

        <module name="TypeNameCheck">
            <!-- Validates static, final fields against the
            expression "^[A-Z][a-zA-Z0-9]*$". -->
            <metadata name="altname" value="TypeName"/>
            <property name="severity" value="warning"/>
        </module>

        <module name="ConstantNameCheck">
            <!-- Validates non-private, static, final fields against the supplied
            public/package final fields "^[A-Z][A-Z0-9]*(_[A-Z0-9]+)*$". -->
            <metadata name="altname" value="ConstantName"/>
            <property name="applyToPublic" value="true"/>
            <property name="applyToProtected" value="true"/>
            <property name="applyToPackage" value="true"/>
            <property name="applyToPrivate" value="false"/>
            <property name="format" value="^([A-Z][A-Z0-9]*(_[A-Z0-9]+)*|FLAG_.*)$"/>
            <message key="name.invalidPattern"
                     value="Variable ''{0}'' should be in ALL_CAPS (if it is a constant) or be private (otherwise)."/>
            <property name="severity" value="warning"/>
        </module>

        <module name="StaticVariableNameCheck">
            <!-- Validates static, non-final fields against the supplied
            expression "^[a-z][a-zA-Z0-9]*_?$". -->
            <metadata name="altname" value="StaticVariableName"/>
            <property name="applyToPublic" value="true"/>
            <property name="applyToProtected" value="true"/>
            <property name="applyToPackage" value="true"/>
            <property name="applyToPrivate" value="true"/>
            <property name="format" value="^[a-z][a-zA-Z0-9]*_?$"/>
            <property name="severity" value="warning"/>
        </module>

        <module name="MemberNameCheck">
            <!-- Validates non-static members against the supplied expression. -->
            <metadata name="altname" value="MemberName"/>
            <property name="applyToPublic" value="true"/>
            <property name="applyToProtected" value="true"/>
            <property name="applyToPackage" value="true"/>
            <property name="applyToPrivate" value="true"/>
            <property name="format" value="^[a-z][a-zA-Z0-9]*$"/>
            <property name="severity" value="warning"/>
        </module>

        <module name="MethodNameCheck">
            <!-- Validates identifiers for method names. -->
            <metadata name="altname" value="MethodName"/>
            <property name="format" value="^[a-z][a-zA-Z0-9]*(_[a-zA-Z0-9]+)*$"/>
            <property name="severity" value="warning"/>
        </module>

        <module name="ParameterName">
            <!-- Validates identifiers for method parameters against the
              expression "^[a-z][a-zA-Z0-9]*$". -->
            <property name="severity" value="warning"/>
        </module>

        <module name="LocalFinalVariableName">
            <!-- Validates identifiers for local final variables against the
              expression "^[a-z][a-zA-Z0-9]*$". -->
            <property name="severity" value="warning"/>
        </module>

        <module name="LocalVariableName">
            <!-- Validates identifiers for local variables against the
              expression "^[a-z][a-zA-Z0-9]*$". -->
            <property name="severity" value="warning"/>
        </module>


        <!--

        LENGTH and CODING CHECKS

        -->

        <module name="LineLength">
            <!-- Checks if a line is too long. -->
            <property name="max" value="${com.puppycrawl.tools.checkstyle.checks.sizes.LineLength.max}" default="100"/>
            <property name="severity" value="error"/>

            <!--
              The default ignore pattern exempts the following elements:
                - import statements
                - long URLs inside comments
            -->

            <property name="ignorePattern"
                      value="${com.puppycrawl.tools.checkstyle.checks.sizes.LineLength.ignorePattern}"
                      default="^(package .*;\s*)|(import .*;\s*)|( *\* *https?://.*)$"/>
        </module>

        <module name="LeftCurly">
            <!-- Checks for placement of the left curly brace ('{'). -->
            <property name="severity" value="warning"/>
        </module>

        <module name="RightCurly">
            <!-- Checks right curlies on CATCH, ELSE, and TRY blocks are on
            the same line. e.g., the following example is fine:
            <pre>
              if {
                ...
              } else
            </pre>
            -->
            <!-- This next example is not fine:
            <pre>
              if {
                ...
              }
              else
            </pre>
            -->
            <property name="option" value="same"/>
            <property name="severity" value="warning"/>
        </module>

        <!-- Checks for braces around if and else blocks -->
        <module name="NeedBraces">
            <property name="severity" value="warning"/>
            <property name="tokens" value="LITERAL_IF, LITERAL_ELSE, LITERAL_FOR, LITERAL_WHILE, LITERAL_DO"/>
        </module>

        <module name="UpperEll">
            <!-- Checks that long constants are defined with an upper ell.-->
            <property name="severity" value="error"/>
        </module>

        <module name="FallThrough">
            <!-- Warn about falling through to the next case statement.  Similar to
            javac -Xlint:fallthrough, but the check is suppressed if a single-line comment
            on the last non-blank line preceding the fallen-into case contains 'fall through' (or
            some other variants which we don't publicized to promote consistency).
            -->
            <property name="reliefPattern"
                      value="fall through|Fall through|fallthru|Fallthru|falls through|Falls through|fallthrough|Fallthrough|No break|NO break|no break|continue on"/>
            <property name="severity" value="error"/>
        </module>


        <!--

        MODIFIERS CHECKS

        -->

        <module name="ModifierOrder">
            <!-- Warn if modifier order is inconsistent with JLS3 8.1.1, 8.3.1, and
                 8.4.3.  The prescribed order is:
                 public, protected, private, abstract, static, final, transient, volatile,
                 synchronized, native, strictfp
              -->
        </module>


        <!--

        WHITESPACE CHECKS

        -->

        <module name="WhitespaceAround">
            <!-- Checks that various tokens are surrounded by whitespace.
                 This includes most binary operators and keywords followed
                 by regular or curly braces.
            -->
            <property name="tokens" value="ASSIGN, BAND, BAND_ASSIGN, BOR,
        BOR_ASSIGN, BSR, BSR_ASSIGN, BXOR, BXOR_ASSIGN, COLON, DIV, DIV_ASSIGN,
        EQUAL, GE, GT, LAND, LE, LITERAL_CATCH, LITERAL_DO, LITERAL_ELSE,
        LITERAL_FINALLY, LITERAL_FOR, LITERAL_IF, LITERAL_RETURN,
        LITERAL_SYNCHRONIZED, LITERAL_TRY, LITERAL_WHILE, LOR, LT, MINUS,
        MINUS_ASSIGN, MOD, MOD_ASSIGN, NOT_EQUAL, PLUS, PLUS_ASSIGN, QUESTION,
        SL, SL_ASSIGN, SR_ASSIGN, STAR, STAR_ASSIGN"/>
            <property name="severity" value="error"/>
        </module>

        <module name="WhitespaceAfter">
            <!-- Checks that commas, semicolons and typecasts are followed by
                 whitespace.
            -->
            <property name="tokens" value="COMMA, SEMI, TYPECAST"/>
        </module>

        <module name="NoWhitespaceAfter">
            <!-- Checks that there is no whitespace after various unary operators.
                 Linebreaks are allowed.
            -->
            <property name="tokens" value="BNOT, DEC, DOT, INC, LNOT, UNARY_MINUS,
        UNARY_PLUS"/>
            <property name="allowLineBreaks" value="true"/>
            <property name="severity" value="error"/>
        </module>

        <module name="NoWhitespaceBefore">
            <!-- Checks that there is no whitespace before various unary operators.
                 Linebreaks are allowed.
            -->
            <property name="tokens" value="SEMI, DOT, POST_DEC, POST_INC"/>
            <property name="allowLineBreaks" value="true"/>
            <property name="severity" value="error"/>
        </module>

        <module name="ParenPad">
            <!-- Checks that there is no whitespace before close parens or after
                 open parens.
            -->
            <property name="severity" value="warning"/>
        </module>

    </module>
</module>

```

如果想启用自定义的规范文件，则依旧是修改configuration，指向你的文件地址。

```xml
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-checkstyle-plugin</artifactId>
                <version>2.10</version>
                <configuration>
                    <configLocation>${basedir}/src/config/custom_checkstyle.xml</configLocation>                  
                </configuration>
                <executions>
                    <execution>
                        <id>checkstyle</id>
                        <phase>validate</phase>
                        <goals>
                            <goal>check</goal>
                        </goals>
                        <configuration>
                            <failOnViolation>true</failOnViolation>
                        </configuration>
                    </execution>
                </executions>
            </plugin>

```

## 运行checkstyle检查

```bash

mvn checkstyle:checkstyle

```


## 查看checkstyle结果

运行maven命令后可以在console里查看checkstyle运行结果。

```bash
[INFO]
[INFO] There are 11 checkstyle errors.
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 2.135s
[INFO] Finished at: Fri Jun 21 13:39:24 CST 2013
[INFO] Final Memory: 6M/81M
[INFO] ------------------------------------------------------------------------
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-checkstyle-plugin:2.10:check (checkstyle) on project SpringMessageSpike: You have 11 Checkstyle violations. -> [Help 1]

```

checkstye的详细结果信息被存放在target/checkstyle-result.xml中。下面是一个示例。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<checkstyle version="5.6">
<file name="/Users/twer/sourcecode/SpringMessageSpike/src/main/java/com/thoughtworks/config/SessionMessageSource.java">
<error line="0" severity="error" message="Google copyright is missing or malformed." source="com.puppycrawl.tools.checkstyle.checks.regexp.RegexpSinglelineCheck"/>
<error line="21" severity="warning" message="Wrong order for &apos;org.slf4j.LoggerFactory.getLogger&apos; import." source="com.puppycrawl.tools.checkstyle.checks.imports.ImportOrderCheck"/>
<error line="27" severity="error" message="Missing a Javadoc comment." source="com.puppycrawl.tools.checkstyle.checks.javadoc.JavadocTypeCheck"/>
<error line="35" severity="error" message="Line is longer than 100 characters (found 115)." source="com.puppycrawl.tools.checkstyle.checks.sizes.LineLengthCheck"/>
</file>
</checkstyle>

```

## 跳过对指定文件的某些检查

如果对于指定文件检查出了一些问题，但是你想忽略它，则可以使用suppression。

例如在上述例子中有一个checkstyle error是说某行超过了100字符。如果我们不想修复这个错误怎么办那？可以将其suppress掉。

方法是建立一个checkstyle-suppressions.xml文件。其中加入下述内容

```xml checkstyle-suppressions.xml

<?xml version="1.0"?>

<!DOCTYPE suppressions PUBLIC
        "-//Puppy Crawl//DTD Suppressions 1.0//EN"
        "http://www.puppycrawl.com/dtds/suppressions_1_0.dtd">

<suppressions>
    <suppress checks="LineLengthCheck"
              files="SessionMessageSource.java"
              />
</suppressions>

```

然后配置`maven-checkstyel-plugin`设置`suppressionsLocation`。

```xml
    <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-checkstyle-plugin</artifactId>
        <version>2.10</version>
        <configuration>
            <configLocation>${basedir}/src/config/custom_checkstyle.xml</configLocation>
            <suppressionsLocation>${basedir}/src/config/checkstyle-suppressions.xml</suppressionsLocation>
        </configuration>
        <executions>
            <execution>
                <id>checkstyle</id>
                <phase>validate</phase>
                <goals>
                    <goal>check</goal>
                </goals>
                <configuration>
                    <failOnViolation>true</failOnViolation>
                </configuration>
            </execution>
        </executions>
    </plugin>

```



[CheckStyle]: http://checkstyle.sourceforge.net/ 


