---
layout: post
title: Java基础知识之泛型
date: 2013-03-23 00:26
comments: true
categories: 程序语言
tags: [java, generic, 泛型]
---

**当我们在定义类，接口和方法时，可以接收一个类型作为参数，这就叫做泛型**。

函数可以传入普通的参数，也可以传入一个类型参数。不同之处是普通的参数就是值而已，但是类型参数却是个类型。

使用泛型的好处:

* 强类型检查。在编译时就可以得到类型错误信息。
* 避免显式强制转换。
* 方便实现通用算法。


## 对类使用泛型

我们可以创建一个简单的Class Box。它提供存取一个类型为Object的对象。

```java 

public class Box {
    public Object getObject() {
        return object;
    }

    public void setObject(Object object) {
        this.object = object;
    }

    private Object object;

```
   
你可以传给它任何你想要的对象，比如对象String,Integer等，也可以传入自定义的一些对象。但是调用getObject方法返回的对象需要显式的强转为传入的类型，才能使用原来类型的一些方法。

我们可以使用泛型来构造这个对象。

```java

public class Box<T> {
    public T getObject() {
        return object;
    }

    private T object;

    public void setObject(T object) {
        this.object = object;
    }
}

```

我们可以看到，所有的Object被替换成了T。T代表了某种类型，你在实例化Box对象时，必须要给其指定一种类型，String,Integer或者自定义的类，并且调用getObject方法并不需要进行强转就可以使用该类型的方法。

一般来说，类型参数名称越简单越好，并且需要是大写的。为了方便，我们约定了一些命名使用。

* E Element
* K key
* N Number
* T type
* V value
* S,U,V 第2，3，4个类型

我们可以这样实例化一个Box类。

```java

Box<Integer> integerBox = new Box<Integer>();

```

同样，我们也支持在一个类中传入多个类型参数。例如下面的Pair对象

```java

public class Pair<T, V> {
    private T key;
    private V value;

    public Pair(T key, V value) {
        this.key = key;
        this.value = value;
    }

    public T getKey() {
        return key;
    }

    public V getValue() {
        return value;
    }

```

使用方法如下。

```java

Pair<Integer, String> one = new Pair<Integer, String>(1, "one");

Pair<String, String> hello = new Pair<String, String>("hello", "world");  

```

## 对方法使用泛型

泛型可以作用与方法上，此时泛型参数只能在方法体中使用。而泛型作用于类时，则在整个类中可以使用。

在静态方法、非静态方法及构造函数都可以使用泛型。

```java

public class Util {

    public static <T, U> boolean compare(Pair<T,U> pair1, Pair<T,U> pair2)
    {
        return pair1.getKey().equals(pair2.getKey()) && pair1.getValue().equals(pair2.getValue());
    }
}

```
下面是对该静态方法的使用。

```java

       Pair one = new Pair("one", 1);
        Pair two = new Pair("two", 2);

        assertThat(Util.compare(one, two), is(false));
// pass

```

## 对泛型进行限定

默认情况下如果直接使用<T>的话，我们可以给其传任何值。有时候我们想值允许传入某个类及它的子类。这时候在声明泛型时可以使用**extends**关键字。

```java

public class Box<T extends Number> {
    public T getObject() {
        return object;
    }

    private T object;

    public void setObject(T object) {
        this.object = object;
    }
}

```
```java

      Box box = new Box();
        box.setObject(10);    //ok
        box.setObject("hello");  //compile-time error

```

我们也可以给类型参数加多个限定。

```java

<T extends B1 & B2 & B3>

```

加上限定类或接口以后，我们可以使用泛型参数变量调用该类或接口的方法。


## 通配符的使用

Java中的List<T>就是一个实现了泛型的类，假如我们写了一个方法，获取List<T>中元素的个数。只不过这个方法限定T类型为Number。

```java

  public static int getCount(List<Number> list)
  {
      int i = 0;
      for(Number n : list)
      {
          i++;
      }
      return i;
  }

```
然后我们这样试图调用它。

```
        List<Integer> list = new ArrayList<Integer>(){
            {
                add(1);
                add(2);
                add(3);
            }
        };

        Util.getCount(list); //compile-time error

```

为什么会产生错误那？因为我们要求方法的参数是List<Number>,而我们实际传入的是List<Integer>。虽然Integer是Number的子类，但是List<Integer>却不是List<Number>的子类，他们其实是平等的关系。这点一定要注意。我们在方法定义时已经明确表示T的类型是Number了，所以只能接收List<Number>，而不能接收其它类型的参数。
这时候`?`通配符就起作用了。我们可以使用`？`通配符重新定义这个方法。

```java

public class Util {

  public static int getCount(List<? extends Number> list)
  {
      int i = 0;
      for(Number n : list)
      {
          i++;
      }
      return i;

  }
}

```

```java
        List<Integer> list = new ArrayList<Integer>(){
            {
                add(1);
                add(2);
                add(3);
            }
        };

        assertThat(Util.getCount(list), is(3));  // pass

```

既然能限定到一个类及其子类上，当然也能限定到一个类及其父类上。语法如下:

```java

<? supper A>

```


## 对泛型使用的总结

* **类型参数不能是原始类型**（int, char，double）,只能传入这些类型的封转类(Integer,Char,Double)。

* **不能直接创建类型参数的实例。**

```java
public static <E> void append(List<E> list) {    E elem = new E();  // compile-time error    list.add(elem); 
}

```

但有通过反射可以实现。

```java
public static <E> void append(List<E> list, Class<E> cls) throws Exception {    E elem = cls.newInstance();   // OK    list.add(elem);}

```
你可以这样调用它:

```java

List<String> ls = new ArrayList<>(); 
append(ls, String.class);

```

* **静态字段的类型不能为类型参数。**

```java

public class Box<T> {    private static T object; // compile-time error

}

```

* **不能创建类型参数变量的数组。**

```java

List<Integer>[] arrayOfLists = new List<Integer>[2];  // compile-time error

```

* **不能重载一个方法，该方法的形参都来自于同一个类型参数对象。**

```java 

public class Example {    

	public void print(List<Integer> integers) {}
    
    public void print(List<Double> doubles) {}
}

```

参考文档：<http://docs.oracle.com/javase/tutorial/java/generics/index.html>

