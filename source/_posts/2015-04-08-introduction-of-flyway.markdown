---
layout: post
title: Flyway， 数据库Schema管理利器
date: 2015-04-08 15:10:43 +0800
comments: true
categories: 
---

整天跟数据库打交道的程序员都知道，当数据库的Schema发生改变时是多么痛苦的事情。尤其是一个在不断开发完善的项目，随着需求变化，数据库的schema也会跟着变化，而追踪记录这些变化一向都是费时费力。如果你拥有多个测试环境，那么保证这些环境下的数据库的一致性的难度会成倍增加。

<!-- more -->

Flyway，一款小工具，应用它能够大大简化这方面的工作。

## 它的优点：

1. convention over configuration，配置简单，使用方便；支持Sql及Java配置；

2. 支持当前几乎所有的主流数据库；

3. 拥有命令行工具、Maven、Gradle插件....应用场景广泛。

## 使用它之前先要了解一些概念：

* 版本：对数据库的每一次变更可称为一个版本。

* 迁移：Flyway把数据库结构从一个版本更新到另一个版本叫做迁移。

* 可用的迁移：Flyway的文件系统识别出来的迁移版本。

* 已经应用的迁移：Flyway已经对数据库执行过的迁移。

## 如何使用：

以Sql配置举例，建立一个文件夹用来存放所有数据库修改记录。

每次修改以’V版本号\_\_描述.sql’的方式命名。比如V1\_\_initial\_version.sql， V2.1\_\_create\_table.sql,V2015.01.05\_\_drop\_view.sql


{% img /images/SqlMigrationBaseDir.png 500 %}


Flyway会根据文件名自动识别版本顺序，并根据这些版本顺序来应用数据库修改。


## 配置

以使用Flyway的命令行工具为例。安装命令行工具后，运行时Flyway会根据以下路径来寻找配置文件。

* 安装目录/conf/flyway.properties

* 用户目录/flyway.properties

* 当前目录/flyway.properties

或者直接在命令行使用 `-configFile=myfile.properties`来指定文件。

配置文件的一个示例：

```text

flyway.driver=org.hsqldb.jdbcDriver
flyway.url=jdbc:hsqldb:file:/db/flyway_sample
flyway.user=SA
flyway.password=mySecretPwd
flyway.schemas=schema1,schema2,schema3
flyway.table=schema_history
flyway.locations=classpath:com.mycomp.migration,database/migrations,filesystem:/sql-migrations
flyway.sqlMigrationPrefix=Migration-
flyway.sqlMigrationSeparator=__
flyway.sqlMigrationSuffix=-OK.sql
flyway.encoding=ISO-8859-1
flyway.placeholderReplacement=true
flyway.placeholders.aplaceholder=value
flyway.placeholders.otherplaceholder=value123
flyway.placeholderPrefix=#[
flyway.placeholderSuffix=]
flyway.resolvers=com.mycomp.project.CustomResolver,com.mycomp.project.AnotherResolver
flyway.callbacks=com.mycomp.project.CustomCallback,com.mycomp.project.AnotherCallback
flyway.target=5.1
flyway.outOfOrder=false
flyway.validateOnMigrate=true
flyway.cleanOnValidationError=false
flyway.baselineOnMigrate=false

```

## 命令行工具的几个命令：

* Clean： 删除所有创建的数据库对象，包括用户、表、视图等。

* Migrate： 对数据库依次应用版本更改。

* Info：获取目前数据库的状态。那些迁移已经完成，那些迁移待完成。所有迁移的执行时间以及结果。

* Validate：验证数据库结构与迁移脚本的异同。

* Baseline：根据现有的数据库结构生成一个基准迁移脚本。


## 进阶

flyway提供sql配置和Java配置两种方式。sql配置可以方便实现对DDL的修改、一些引用数据的修改；而Java的方式则更强大些，可以应用更为复杂的场景，比如对某个数据表中的数据进行一些逻辑处理。具体使用请参见官方文档：(http://flywaydb.org/documentation/migration/java.html)<http://flywaydb.org/documentation/migration/java.html>

熟悉Ruby On Rails的程序员都知道Ruby On Rails自带一个数据库迁移工具，这个和那个差不多，可以说下JVM平台的数据库迁移工具，弥补了JVM平台下维护数据库Schema的不足。




