---
layout: post
title: Java基础学习之Enum
date: 2013-03-12 22:17
comments: true
categories: 编程开发
tags: [java, enum, c#] 
---

Enum是在Java中用来定义枚举类型的关键字。Enum一般用来表示一组相同类型的常量,如性别、日期 、颜色等.

下面是一个最简单的枚举。

```java
public enum Color
{

RED,

GREEN,

BLUE

}
```

<!-- more -->

实际上在Java中枚举类型本质上就是一个类，其继承自java.lang.Enum类。

通过默认提供的`GetValues()`方法可以获取所有枚举对象，其以一个数组的形式返回。

```java

for(Color color : Color.values())
{

System.out.printf("%s: %s%n",color,color.toString());

}

```

输出结果为：

```console

RED: RED

GREEN: GREEN

BLUE: BLUE

```

既然是enum本质上是类，那么我们当然可以给其加一些方法。注意最后一个枚举对象要使用“；”结尾，说明枚举值结束使用。

```java

public enum Color
{

RED("Red Color"),

GREEN("Green Color"),

BLUE("Blue Color");

private final String color;

private Color(String color) {

    this.color = color;

}

public String getColor() {

return color;

}

}

```


注意在enum中是不能声明public的构造函数的，这样是为了避免直接实例化enum对象。

我们可以通过`getValues()`方法调用`getColor()`方法。

```java

for(Color color : Color.values())
{

System.out.printf("%s: %s%n",color,color.getColor());

}

```

以下是输出结果：

```console

RED: Red Color

GREEN: Green Color

BLUE: Blue Color

```

如果大家还是看不太明白的话，我可以展示一个类来对个对比。

```java

public final class Color extends java.lang.Enum{

    public static final Color RED;

    public static final Color GREEN;

    public static final Color  BLUE;

    static {};

    public java.lang.String getColor();

    public static Color[] values();

    public static Color valueOf(java.lang.String);

}

```

这个类的作用等同于我们的Color枚举对象。而每个被枚举的成员其实就是定义的枚举类型的一个实例，它们都被默认为final。无法改变常数名称所设定的值，它们也是public和static的成员，这与接口中的常量限制相同。可以通过类名称直接使用它们。

所以我们大胆的在里面增加一些其它的方法来实现我们的新特性。

在这里我增加了一个新的方法isRed()来判断当前枚举实例是否是红色的。

```java

public enum Color
{

RED("Red Color"),

GREEN("Green Color"),

BLUE("Blue Color");


private final String color;

 

private Color(String color) {

    this.color = color;

}


public String getColor() {

return color;

}


public boolean isRed() {

return this.equals(RED);

}

}

```

可以对其进行一个测试。

```java

Color green = Color.GREEN;

System.out.print(green.isRed());


Color red = Color.RED;

System.out.print(red.isRed());

```

第一个输出结果为false，第二个输出结果为true。

通过对Java中enum的运用，往往会产生奇效。比如有这样一个例子，有一个Rover对象，它有一个类型为Enum的direction属性，我们要给Rover实现左转的指令。你可能会写出这样的代码：

```java Direction.java

public enum Direction {
    North,
    East,
    South,
    West
}

```
```java Rover.java

public class Rover {

    private Direction direction;

    public Rover(Direction direction) {
        this.direction = direction;
    }

    public void turnLeft() {
        if (direction.equals(Direction.East)) {
            direction = Direction.North;
        } else if (direction.equals(Direction.North)) {
            direction = Direction.West;
        } else if (direction.equals(Direction.West)) {
            direction = Direction.South;
        } else if (direction.equals(Direction.South)) {
            direction = Direction.East;
        }

    }
}

```
一大堆`if...else`的代码看起来真的很丑陋。这还好，如果让你给Rover再加几个方法，比如向右转，旋转到反方向等，那代码就没法看了。
我们可以这样分析一下，其实给定一个方向之后，向左转的方向也就确定了，所以我们可以将这些逻辑放置到Direction对象中去。下面是改进后的版本。

```java Direction.java

public enum Direction {
    North {
        @Override
        public Direction turnLeft() {
        return West;
        }
    },
    East {
        @Override
        public Direction turnLeft() {
            return North;
        }

    },
    South {
        @Override
        public Direction turnLeft() {
            return East;
        }
    },
    West {
        @Override
        public Direction turnLeft() {
            return South;
        }
    };
    
    public abstract Direction turnLeft();
}

```

```java Rover.java

public class Rover {

    private Direction direction;

    public Rover(Direction direction) {
        this.direction = direction;
    }

    public void turnLeft() {
        direction = direction.turnLeft();
    }
}

```

这样的代码看起来要舒服的多.

##C#中的Enum

我也可以简单的讲解下c#中的枚举对象。在c#中声明枚举对象的关键字是enum。

```c#

 访问修辞符 enum 枚举名:基础类型
    {
        枚举成员
    }
```


基础类型必须能够表示该枚举中定义的所有枚举数值。枚举声明可以显式地声明 byte、sbyte、short、ushort、int、uint、long 或 ulong 类型作为对应的基础类型。没有显式地声明基础类型的枚举声明意味着所对应的基础类型是 int.

```c#

public enum Color

{

RED,

GREEN,

BLUE

}

```

所以我们可以直接将一个枚举类型强制转换成其对应的基础类型。

```c#
Int  num = (int)Color.Red;
```

Num的值为0.

我们也可以反向转换。

```c#

Color color = (Color)num;

```

甚至我们还可以对枚举类型进行与或运算。这些就不细说了，有兴趣的可以查阅相关资料。


