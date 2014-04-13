---
layout: post
title: Java中测试异常的多种方式
date: 2014-04-14 01:32:48 +1000
comments: true
categories: Java
---

使用JUnit来测试Java代码中的异常有很多种方式，你知道几种？

<!-- more -->

给定这样一个class。

```java Person.java

public class Person {

    private String name;
    private int age;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {

        if (age < 0 ) {
            throw new IllegalArgumentException("age is invalid");
        }
        this.age = age;
    }
}

```

我们来测试setAge方法。

## Try-catch 方式

```java


    @Test
    public void shouldGetExceptionWhenAgeLessThan0() {
        Person person = new Person();
        try {
        person.setAge(-1);
            fail("should get IllegalArgumentException");
        } catch (IllegalArgumentException ex) {
            assertThat(ex.getMessage(),containsString("age is invalid"));
        }

    }

```

这是最容易想到的一种方式，但是太啰嗦。

## JUnit annotation方式

JUnit中提供了一个`expected`的annotation来检查异常。

```java


    @Test(expected = IllegalArgumentException.class)
    public void shouldGetExceptionWhenAgeLessThan0() {
        Person person = new Person();
        person.setAge(-1);

    }

```

这种方式看起来要简洁多了，但是无法检查异常中的消息。

## ExpectedException rule

JUnit7以后提供了一个叫做`ExpectedException`的Rule来实现对异常的测试。

```java

    @Rule
    public ExpectedException exception = ExpectedException.none();

    @Test
    public void shouldGetExceptionWhenAgeLessThan0() {

        Person person = new Person();
        exception.expect(IllegalArgumentException.class);
        exception.expectMessage(containsString("age is invalid"));
        person.setAge(-1);

    }

```

这种方式既可以检查异常类型，也可以验证异常中的消息。

## 使用catch-exception库

有个catch-exception库也可以实现对异常的测试。

首先引用该库。

```xml pom.xml

        <dependency>
            <groupId>com.googlecode.catch-exception</groupId>
            <artifactId>catch-exception</artifactId>
            <version>1.2.0</version>
            <scope>test</scope> <!-- test scope to use it only in tests -->
        </dependency>

```

然后这样书写测试。

```java


    @Test
    public void shouldGetExceptionWhenAgeLessThan0() {
        Person person = new Person();
        catchException(person).setAge(-1);
        assertThat(caughtException(),instanceOf(IllegalArgumentException.class));
        assertThat(caughtException().getMessage(), containsString("age is invalid"));

    }

```

这样的好处是可以精准的验证异常是被测方法抛出来的，而不是其它方法抛出来的。

catch-exception库还提供了多种API来进行测试。

先加载fest-assertion库。

```xml

        <dependency>
            <groupId>org.easytesting</groupId>
            <artifactId>fest-assert-core</artifactId>
            <version>2.0M10</version>
        </dependency>

```

然后可以书写BDD风格的测试。

```java

    @Test
    public void shouldGetExceptionWhenAgeLessThan0() {
        // given
        Person person = new Person();

        // when
        when(person).setAge(-1);

        // then
        then(caughtException())
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("age is invalid")
                .hasNoCause();
    }

```

如果喜欢Hamcrest风格的验证风格的话，catch-exception也提供了相应的Matcher API。

```java

    @Test
    public void shouldGetExceptionWhenAgeLessThan0() {
        // given
        Person person = new Person();

        // when
        when(person).setAge(-1);

        // then
        assertThat(caughtException(), allOf(
                instanceOf(IllegalArgumentException.class)
                , hasMessage("age is invalid")
                ,hasNoCause()));
    }

```

第一种最土鳖，第二种最简洁，第四种最靠谱。





