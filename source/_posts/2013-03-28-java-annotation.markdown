---
layout: post
title: Java基础知识之Annotation
date: 2013-03-28 01:01
comments: true
categories: Java学习
tags: [Java, Annotation]
---



##什么是Annotation?

**Annotation翻译为中文即为注解，意思就是提供除了程序本身逻辑外的额外的数据信息。**Annotation对于标注的代码没有直接的影响，它不可以直接与标注的代码产生交互，但其他组件可以使用这些信息。

Annotation信息可以被编译进class文件，也可以保留在Java 虚拟机中，从而在运行时可以获取。甚至对于Annotation本身也可以加Annotation。      

##那些对象可以加Annotation

类，方法，变量，参数，包都可以加Annotation。

##内置的Annotation

@Override 重载父类中方法
@Deprecated 被标注的方法或类型已不再推荐使用

@SuppressWarnings  阻止编译时的警告信息。其需要接收一个String的数组作为参数。
可供使用的参数有：

* unchecked
* path
* serial
* finally
* fallthrough

## 可以用与其他annotation上的annotation

* @Retention 

确定Annotation被保存的生命周期,
需要接收一个Enum对象RetentionPolicy作为参数。

```java

public enum RetentionPolicy {
    /**
     * Annotations are to be discarded by the compiler.
     */
    SOURCE,

    /**
     * Annotations are to be recorded in the class file by the compiler
     * but need not be retained by the VM at run time.  This is the default
     * behavior.
     */
    CLASS,

    /**
     * Annotations are to be recorded in the class file by the compiler and
     * retained by the VM at run time, so they may be read reflectively.
     *
     * @see java.lang.reflect.AnnotatedElement
     */
    RUNTIME
}

```

* @Documented 文档化

* @Target  

表示该Annotation可以修饰的范围,接收一个Enum对象EnumType的数组作为参数。

```java

public enum ElementType {
    /** Class, interface (including annotation type), or enum declaration */
    TYPE,

    /** Field declaration (includes enum constants) */
    FIELD,

    /** Method declaration */
    METHOD,

    /** Parameter declaration */
    PARAMETER,

    /** Constructor declaration */
    CONSTRUCTOR,

    /** Local variable declaration */
    LOCAL_VARIABLE,

    /** Annotation type declaration */
    ANNOTATION_TYPE,

    /** Package declaration */
    PACKAGE
}

```

* @Inherited  

该Annotation可以影响到被标注的类的子类。

## 自定义Annotation

JSE5.0以后我们可以自定义Annotation。下面就是一个简单的例子。

```java

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface MethodAnnotation {

}

```

下面的Person对象使用了自定义的MethodAnnotation。

```java

public class Person {

    public void eat() {
        System.out.println("eating");
    }

    @MethodAnnotation
    public void walk() {
        System.out.print("walking");
    }

}

```

我们可以通过反射获取Annotation的信息。

```java

        Class<Person> personClass = Person.class;
        Method[] methods = personClass.getMethods();
        for(Method method : methods){
            if (method.isAnnotationPresent(MethodAnnotation.class)){
                method.invoke(personClass.newInstance());
            }
        }

```

输出：

```concole
walking 
```

我们也可以给自定义的Annotation加方法。 

```java

@Target(ElementType.TYPE)
public @interface personAnnotation {
    int id() default 1;
    String name() default "bowen";
}

```

下面是对personAnnotation的使用。

```java

@personAnnotation(id = 8, name = "john")
public class Person {

    public void eat() {
        System.out.println("eating");
    }

    @MethodAnnotation
    public void walk() {
        System.out.print("walking");
    }

}

```

## Annotation是如何被处理的

当Java源代码被编译时，编译器的一个插件annotation处理器则会处理这些annotation。处理器可以产生报告信息，或者创建附加的Java源文件或资源。如果annotation本身被加上了RententionPolicy的运行时类，则Java编译器则会将annotation的元数据存储到class文件中。然后，Java虚拟机或其他的程序可以查找这些元数据并做相应的处理。

当然除了annotation处理器可以处理annotation外，我们也可以使用反射自己来处理annotation。Java SE 5有一个名为AnnotatedElement的接口，Java的反射对象类Class,Constructor,Field,Method以及Package都实现了这个接口。这个接口用来表示当前运行在Java虚拟机中的被加上了annotation的程序元素。通过这个接口可以使用反射读取annotation。AnnotatedElement接口可以访问被加上RUNTIME标记的annotation，相应的方法有getAnnotation,getAnnotations,isAnnotationPresent。由于Annotation类型被编译和存储在二进制文件中就像class一样，所以可以像查询普通的Java对象一样查询这些方法返回的Annotation。              


## Annotation的广泛使用

Annotation被广泛用于各种框架和库中，下面就列举一些典型的应用.

### Junit

Junit是非常著名的一款单元测试框架，使用Junit的时候需要接触大量的annotation。

* @Runwith 自定义测试类的Runner

* @ContextConfiguration 设置Spring的ApplicationContext 

* @DirtiesContext 当执行下一个测试前重新加载ApplicationContext.

* @Before 调用测试方法前初始化

* @After 调用测试方法后处理

* @Test 表明该方法是测试方法

* @Ignore 可以加在测试类或测试方法上，忽略运行。

* @BeforeClass：在该测试类中的所有测试方法执行前调用，只被调用一次（被标注的方法必须是static）

* @AfterClass：在该测试类中的所有的测试方法执行完后调用，只被执行一次(被标注的方法必须是static)


### Spring
Spring 号称配置地狱，Annotation也不少。

* @Service 给service类加注解

* @Repository 给DAO类加注解

* @Component 给组件类加注解

* @Autowired 让Spring自动装配bean

* @Transactional 配置事物

* @Scope 配置对象存活范围

* @Controller 给控制器类加注解

* @RequestMapping url路径映射

* @PathVariable 将方法参数映射到路径

* @RequestParam 将请求参数绑定到方法变量

* @ModelAttribute 与model绑定

* @SessionAttributes 设置到session属性


### Hibernate

* @Entity 修饰entity bean

* @Table 将entity类与数据库中的table映射起来

* @Column 映射列

* @Id 映射id

* @GeneratedValue 该字段是自增长的

* @Version 版本控制或并发性控制

* @OrderBy 排序规则

* @Lob 大对象标注

Hibernate还有大量的关于联合的annotation和继承的annotation，这里就不意义列举了。


### JSR 303 - Bean Validation

JSR 303 - Bean Validation是一个数据验证的规范，其对Java bean的验证主要通过Java annotation来实现。

* @Null被注释的元素必须为 null

* @NotNull被注释的元素必须不为 null

* @AssertTrue被注释的元素必须为 true@AssertFalse被注释的元素必须为 false@Min(value)被注释的元素必须是一个数字，其值必须大于等于指定的最小值

* @Max(value)被注释的元素必须是一个数字，其值必须小于等于指定的最大值

* @DecimalMin(value)被注释的元素必须是一个数字，其值必须大于等于指定的最小值

* @DecimalMax(value)被注释的元素必须是一个数字，其值必须小于等于指定的最大值

* @Size(max, min)被注释的元素的大小必须在指定的范围内

* @Digits (integer, fraction)被注释的元素必须是一个数字，其值必须在可接受的范围内

* @Past被注释的元素必须是一个过去的日期

* @Future被注释的元素必须是一个将来的日期

* @Pattern(value)被注释的元素必须符合指定的正则表达式

其实还有很多使用了annotaion的framework或library,这里就不一一列举了，希望大家能举一反三，深入了解Java中的annotation。



