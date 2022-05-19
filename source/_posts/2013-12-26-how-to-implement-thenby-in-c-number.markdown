---
layout: post
title: C#中的ThenBy是如何实现的
date: 2013-12-26 23:14
comments: true
categories: C#
tags: [ThenBy, C#]
---

C#中给继承自IEnumerable的对象（最熟知的就是List了）提供了很丰富的扩展方法，涉及列表操作的方方面面。而扩展方法ThenBy就是很有意思的一个，它的实现也很巧妙。

<!-- more -->

如果有这样的一个Team类，里面有三个属性。

```csharp Team.cs

public class Team
{
    public Team (string name, int timeCost, int score)
    {
        this.Name = name;
        this.TimeCost = timeCost;
        this.Score = score; 
    }

    public string Name {
        get;
        private set;
    }

    public int TimeCost {
        get;
        private set;
    }

    public int Score {
        get;
        private set;
    }

}

```

然后我们有一个Team的List。

```csharp

List<Team> teams = new List<Team> ();
teams.Add (new Team ("teamA", 10, 22));
teams.Add (new Team ("teamB", 12, 20));

teams.Add (new Team ("teamC", 8, 18));

```

那么如何求出teams中得分最高的那个队伍那？这个很简单，只需要一句话即可。

```csharp

var result = teams.OrderByDescending (team => team.Score).First ();
Console.WriteLine (result.Name); // teamA

```

由于List实现了IEnumerable接口，而System.Linq中的Enumerable类中有针对IEnumerable接口的名为OrderByDescending的扩展方法，所以我们直接调用这个扩展方法可以对List按照指定的key进行降序排列，再调用First这个扩展方法来获取列表中的第一个元素。


如果我的List变成这个样子。

```csharp

List<Team> teams = new List<Team> ();
teams.Add (new Team ("teamA", 10, 18));
teams.Add (new Team ("teamB", 12, 16));
teams.Add (new Team ("teamC", 8, 18));

```

由于有可能两组以上的队伍都可能拿到最高分，那么在这些最高分的队伍中，我们选取用时最少的作为最终优胜者。有人说那可以这样写。

```csharp

var result = teams.OrderByDescending (team => team.Score).OrderBy(team => team.TimeCost).First ();

```

先对列表按Score降序排列，再对列表按TimeCost升序排列，然后取结果中的第一个元素。看来貌似是正确的，但其实是错误的。因为第一次调用OrderByDescending方法后返回了一个排序后的数组，再调用OrderBy是另外一次排序了，它会丢弃上一次排序，这与我们定的先看积分，如果积分相同再看耗时的规则违背。

那么应该如何实现那？C#给我们提供了一个叫做ThenBy的方法，可以满足我们的要求。

```csharp

var result = teams.OrderByDescending (team => team.Score).ThenBy(team => team.TimeCost).First ();

Console.WriteLine (result.Name); // teamC

```

新的问题又来了。第一次调用OrderByDescending方法时返回的是一个新对象，再对这个新对象调用ThenBy时，它只有记录了上一次排序规则，才能达到我们想要的效果。那么C#是如何记录上次排序使用的key那？

这就先要看OrderByDescending方法是如何实现了的。查看源码发现OrderByDescending有两个重载，实现如下。

```csharp

public static IOrderedEnumerable<TSource> OrderByDescending<TSource, TKey> (this IEnumerable<TSource> source, Func<TSource, TKey> keySelector)
{
    return source.OrderByDescending (keySelector, null);
}

public static IOrderedEnumerable<TSource> OrderByDescending<TSource, TKey> (this IEnumerable<TSource> source, Func<TSource, TKey> keySelector, IComparer<TKey> comparer)
{
    Check.SourceAndKeySelector (source, keySelector);
    return new OrderedSequence<TSource, TKey> (source, keySelector, comparer, SortDirection.Descending);

}

```

在第二个重载中我们看到OrderByDescending方法返回时的是一个继承了IOrderedEnumerable接口的对象OrderedSequence。这个对象记录了我们的排序规则。

而我们再查看下ThenBy方法的定义。

```csharp

public static IOrderedEnumerable<TSource> ThenBy<TSource, TKey> (this IOrderedEnumerable<TSource> source, Func<TSource, TKey> keySelector, IComparer<TKey> comparer)
{
    Check.SourceAndKeySelector (source, keySelector);
    return source.CreateOrderedEnumerable<TKey> (keySelector, comparer, false);
}

public static IOrderedEnumerable<TSource> ThenBy<TSource, TKey> (this IOrderedEnumerable<TSource> source, Func<TSource, TKey> keySelector)
{
    return source.ThenBy (keySelector, null);
}

```

我们可以看到ThenBy这个扩展方法追加到的对象类型要实现IOrderedEnumerable接口，而OrderBy方法恰好返回的就是这个类型接口对象。那我们再看看IOrderedEnumerable接口的定义。

```csharp

using System;
using System.Collections;
using System.Collections.Generic;

namespace System.Linq
{
    public interface IOrderedEnumerable<TElement> : IEnumerable<TElement>, IEnumerable
    {
        //
        // Methods
        //
        IOrderedEnumerable<TElement> CreateOrderedEnumerable<TKey> (Func<TElement, TKey> keySelector, IComparer<TKey> comparer, bool descending);
    }

}

```


其继承自IEnumerable接口，并且要实现一个名为CreateOrderedEnumerable的方法，正是ThenBy方法实现中调用的这个方法。

所以玄机在OrderedSequence这个类上。实现了IEnumerable接口对象调用OrderBy后会返回OrderedSequence这个对象。而该对象记录了当前排序的规则，其实现了IOrderedEnumerable接口。而ThenBy扩展方法被加到了IOrderedEnumerable接口对象上，其返回值也是一个具有IOrderedEnumerable接口的对象。

照这么说，调用了一次OrderBy后，然后调用多次ThenBy也是可以工作的。我也从官方MSDN中找到了答案：

>> ThenBy and ThenByDescending are defined to extend the type IOrderedEnumerable<TElement>, which is also the return type of these methods. This design enables you to specify multiple sort criteria by applying any number of ThenBy or ThenByDescending methods.

翻译为: ThenBy及ThenByDescending是IOrderedEnumerable类型的扩展方法。ThenBy和ThenByDescending方法的返回值也是IOrderedEnumerable类型。这样设计是为了能够调用任意数量的ThenBy和ThenByDescending方法实现多重排序。

至此，ThenBy的神秘面纱就解开了，但是我不知道如何查看OrderedSequence类的源码，如果能看到这个类的源码就太完美了。知道的同学请告知方法。

注: 上述类的源码来自于Mono的实现。
