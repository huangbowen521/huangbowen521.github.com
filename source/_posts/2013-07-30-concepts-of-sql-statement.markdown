---
layout: post
title: SQL语法的重要知识点总结
date: 2013-07-30 22:31
comments: true
categories: DataBase
---

{% img /images/sql_rebel.jpg %}


好几年没写SQL语句了。现在到了新的team，需要用到数据库。作为QA的话时常需要使用客户端工具连接到数据库中找寻或修改数据。这么长时间没使用，一些SQL的使用技巧都忘得差不多了。晚上看了一些资料，花了1个多小时又捡起了曾经的知识。现在总结一下以方便以后查阅。

<!-- more -->

1. SQL不是大小写敏感的。

2. 分号是分割多条SQL语句的标准的分隔符，所以在单条SQL语句后面总加上分隔符是不会出错的。

3. `DISTINCT`关键字用于剔除重复的结果数据。`SELECT DISTINCT City FROM Customers;`意味着从Customers表中返回不重复的City值。

4. `ORDER BY`用于对查询结果排序。 `ORDER BY column_name ASC`表示递增排序，也是默认顺序，可以省略`ASC`。 `ORDER BY column_name DESC`表示递减排序; `ORDER BY`后面可跟多个列名进行排序。

5. 返回指定数目的记录。在`SQL Server/MS Access`中可以使用 `SELECT TOP number|percent column_name(s)
FROM table_name;` MySQl中语法是 `SELECT column_name(s)
FROM table_name
LIMIT number;`Oracle中语法是`SELECT column_name(s)
FROM table_name
WHERE ROWNUM <= number;`.  `SELECT TOP number PERCENT * FROM table`可以返回指定指定百分数的数据。


6. 使用`LIKE`可以匹配字符串值，同时可以使用通配符。`%`匹配0或多个字符，`_`匹配一个字符，`[charlist]`匹配一组字符，`[^charlist]`或`[!charlist]`表示匹配不在此列表中的字符。


7. 使用`AS`关键字可以给列或表起别名。也可以给组合后的列起别名，如 `SELECT CustomerName, Address+', '+City+', '+PostalCode+', '+Country AS Address
FROM Customers;`


8. 使用`JOIN`关键字可以合并两个或连个以上的表的数据行，要基于所有表中的某一列建立一个连接条件。Join有四种： 

    * INNER JOIN返回两个表中满足条件的行数据。
    * LEFT JOIN返回左表所有行数据及满足条件的右表行数据。
    * RIGHT JOIN返回右表的所有行数据及满足条件的左表行数据。
    * FULL JOIN返回左表和右表所有行数据行。


9. `UNION`用于合并两个或多个查询结果。要求查询结果的列数及数据类型要一样。


10. `SELECT INTO`可以将一个表中数据插入到另一个新表中。如 `SELECT *
INTO CustomersBackup2013
FROM Customers;`它还有个巧妙的用法是创建一个空的新表格，其schema与后者一致,方法是`SELECT *
INTO newtable
FROM table1
WHERE 1=0;`


11. `INSERT INTO SELECT`与`SELECT INTO`使用较相似，不同的是`SELECT INTO`会创建新表,而`INSERT INTO SELECT`是插入到已存在的表中。



12. 一些常用的SQL函数。（注意这些函数并一定都是通用的，但所有数据库基本上都有类似的功能）


    **聚合函数**

   	* AVG() - 求平均值
   	* COUNT() - 返回行数
   	* FIRST() - 返回第一个值
   	* LAST() - 返回最后一个值
   	* MAX() - 返回最大值
   	* MIN() - 返回最小值
   	* SUM() - 求和

    **其他常用函数**

   	* UCASE() - 转换为大写
   	* LCASE() - 转换为小写
   	* MID() - 提取字符串
   	* LEN() - 获取字符串长度
   	* ROUND() - 对数据进行舍入
   	* NOW() - 返回当前系统时间
   	* FORMAT() - 格式化field的显示



13. `GROUP BY`用于对使用了聚合函数的查询结果进行分组。这是一个很强大的语法。



14. `HAVING`用于对使用了聚合函数的字段进行条件筛选。


如果要详细了解SQL的这些使用的话，我推荐<http://www.w3schools.com/sql/default.asp>。你不仅可以看到说明和示例，也可以随时实时练习。实在是不可不得的好网站。 

