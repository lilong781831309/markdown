# JavaSE_01【Java基础语法】

## 今日内容

- Java语言的发展历史
- 编写HelloWorld程序
- 常量
- 变量

## 学习目标

* [ ] 能够使用常见的DOS命令
* [ ] 理解Java语言的跨平台实现原理
* [ ] 理解JDK/JRE/JVM的组成和作用
* [ ] 能够编写HelloWorld程序编译并执行（掌握）
* [ ] 能够配置环境变量JAVA_HOME（会参照笔记配置）
* [ ] 能够辨识关键字（掌握）
* [ ] 理解标识符的含义（掌握）
* [ ] 理解Java中的基本数据类型分类（掌握）
* [ ] 能够定义8种基本数据集类型的变量（掌握）

# 第一章 Java概述

## 1.1 JavaSE课程体系介绍

JavaSE知识图解

![1561379629326](imgs/1561379629326.png)

JavaSE知识模块介绍

* **第一部分：计算机编程语言核心结构：**`数据类型`、`运算符`、`流程控制`、`数组`、`家庭收支记账系统`、…
* **第二部分：Java面向对象核心逻辑：**`类和对象`、`封装`、`继承`、`多态`、`抽象`、`接口`、`客户信息管理系统`、…
* **第三部分：JavaSE核心高级应用：**`集合`、`I/O`、`多线程`、`网络编程`、`反射机制`、`开发团队人员调度系统`、…
* **第四部分：Java新特性：**`Lambda表达式`、`函数式编程`、`新Date/Time API`、`接口的默认、静态和私有方法`、…
* **第五部分：MySQL/JDBC核心技术：**`SQL语句`、`数据库连接池`、`DBUtils`、`事务管理`、`批处理`、…

## 1.2 计算机语言介绍

### 计算机语言是什么

所谓计算机编程语言，就是人们可以使用编程语言对计算机下达命令，让计算机完成人们需要的功能。

### 计算机语言发展

* 第一代：机器语言
* 第二代：汇编语言
* 第三代：高级语言

## 1.3  常用DOS命令

Java语言的初学者，学习一些DOS命令，会非常有帮助。DOS是一个早期的操作系统，现在已经被Windows系统取代，对于我们开发人员，目前需要在DOS中完成一些事情，因此就需要掌握一些必要的命令。


* **常用命令**

  | 命令             | 操作符号      |
  | ---------------- | ------------- |
  | 盘符切换命令     | `盘符名:`     |
  | 查看当前文件夹   | ` dir`        |
  | 进入文件夹命令   | `cd 文件夹名` |
  | 退出文件夹命令   | `cd ..`       |
  | 退出到磁盘根目录 | `cd /`        |
  | 清屏             | `cls`         |
  | 退出             | `exit`        |

## 1.4 Java语言概述

Java诞生于SUN（Stanford University Network），09年SUN被Oracle（甲骨文）收购。

Java之父是詹姆斯.高斯林(James Gosling)。

1996年发布JDK1.0版。

目前最新的版本是Java12。我们学习的Java8。

### Java语言发展历史

|   发行版本   |  发行时间  |                             备注                             |
| :----------: | :--------: | :----------------------------------------------------------: |
|     Java     | 1995.05.23 |     Sun公司在Sun world会议上正式发布Java和HotJava浏览器      |
|   Java 1.0   | 1996.01.23 |             Sun公司发布了Java的第一个开发工具包              |
|   Java 1.1   | 1997.02.19 |                                                              |
|   Java 1.2   | 1998.12.08 |    拆分成：J2SE（标准版）、J2EE（企业版）、J2ME（小型版）    |
|   Java 1.3   | 2000.05.08 |                                                              |
|   Java1.4    | 2004.02.06 |                                                              |
| **Java 5.0** | 2004.09.30 | ①版本号从1.4直接更新至5.0；②平台更名为JavaSE、JavaEE、JavaME |
|   Java 6.0   | 2006.12.11 |               2009.04.20 Oracle宣布收购SUN公司               |
|   Java 7.0   | 2011.07.02 |                                                              |
| **Java 8.0** | 2014.03.18 |                                                              |
|   Java 9.0   | 2017.09.22 |    ①每半年更新一次；②Java 9.0开始不再支持windows 32位系统    |
|  Java 10.0   | 2018.03.21 |                                                              |
|  Java 11.0   | 2018.09.25 |                  JDK安装包取消独立JRE安装包                  |
|  Java 12.0   | 2019.03.19 |                                                              |

### Java技术体系平台

* JavaSE（标准版）：是为开发普通桌面应用程序和商务应用程序提供的解决方案。
* JavaME（小型版）：是为开发电子消费产品和嵌入式设备提供的解决方案，但已经被Android所取代。
* JavaEE（企业版）：是为开发企业环境下的应用程序提供的一套解决方案，主要针对于Web应用程序开发。

## 1.5 Java语言跨平台原理

### Java语言的特点

* **完全面向对象：**Java语言支持封装、继承、多态，面对对象编程，让程序更好达到`高内聚`，`低耦合`的标准。
* **支持分布式：**Java语言支持Internet应用的开发，在基本的Java应用编程接口中有一个网络应用编程接口（java net），它提供了用于网络应用编程的类库，包括URL、URLConnection、Socket、ServerSocket等。Java的RMI（远程方法激活）机制也是开发分布式应用的重要手段。
* **健壮型：**Java的强类型机制、异常处理、垃圾的自动收集等是Java程序健壮性的重要保证。对指针的丢弃是Java的明智选择。
* **安全：**Java通常被用在网络环境中，为此，Java提供了一个安全机制以防恶意代码的攻击。如：安全防范机制（类ClassLoader），如分配不同的名字空间以防替代本地的同名类、字节代码检查。
* **跨平台性：**Java程序（后缀为java的文件）在Java平台上被编译为体系结构中立的字节码格式（后缀为class的文件），然后可以在实现这个Java平台的任何系统中运行。

### Java语言的跨平台原理

- **跨平台**：任何软件的运行，都必须要运行在操作系统之上，而我们用Java编写的软件可以运行在任何的操作系统上，这个特性称为**Java语言的跨平台特性**。该特性是由JVM实现的，我们编写的程序运行在JVM上，而JVM运行在操作系统上。
- **JVM**（Java Virtual Machine ）：Java虚拟机，简称JVM，是运行所有Java程序的假想计算机，是Java程序的运行环境之一，也是Java 最具吸引力的特性之一。我们编写的Java代码，都运行在**JVM** 之上。

如图所示，Java的虚拟机本身是不具备跨平台功能的，每个操作系统下都有不同版本的虚拟机。

- **JRE ** (Java Runtime Environment) ：是Java程序的运行时环境，包含`JVM` 和运行时所需要的`核心类库`。
- **JDK**  (Java Development Kit)：是Java程序开发工具包，包含`JRE` 和开发人员使用的工具。

我们想要运行一个已有的Java程序，那么只需安装`JRE` 即可。

我们想要开发一个全新的Java程序，那么必须安装`JDK` ，其内部包含`JRE`。


> 友情提示：
>
> 三者关系： JDK > JRE > JVM

## 1.6 JDK下载和安装

### JDK的下载

* 下载网址：www.oracle.com 

* 下载步骤：

  * 登录Oracle公司官网，www.oracle.com

  * 在**Developer Downloads**处，选择`Java`，单击进入

  * 下拉页面，找到**Java**，在此选择`Java (JDK) for Developers`，单击进入

  * 下拉页面，找到**Java SE 8u201 / Java SE 8u202**，在此处选择`JDK DOWNLOAD`，单击进入

  * 下拉页面，找到 **Java SE Development Kit 8u202**，选择**Accept License Agreement**

  * 如果电脑系统版本是32位的，请选择`jdk-8u202-windows-i586.exe`下载；如果电脑系统版本是64位的，请选择`jdk-8u202-windows-x64.exe`下载


### JDK的安装

## 1.7 配置环境变量

为什么配置path？

希望在命令行使用javac.exe等工具时，任意目录下都可以找到这个工具所在的目录。

### 1.7.1 只配置path

* 步骤：

  * 打开桌面上的计算机，进入后在左侧找到`计算机`，单击鼠标`右键`，选择`属性`

  * 选择`高级系统设置`

  * 在`高级`选项卡，单击`环境变量`

  * 在`系统变量`中，选中`Path` 环境变量，`双击`或者`点击编辑`
    ![](imgs/环境变量6.jpg)

  * 在变量值的最前面，键入`D:\develop\Java\jdk1.8.0_202\bin;`  分号必须要写，而且还要是**英文符号**

  * 环境变量配置完成，**重新开启**DOS命令行，在任意目录下输入`javac` 命令，运行成功


### 1.7.2 配置JAVA_HOME+path
* 步骤：

  * 打开桌面上的计算机，进入后在左侧找到`计算机`，单击鼠标`右键`，选择`属性`

  * 选择`高级系统设置`

  * 在`高级`选项卡，单击`环境变量`

  * 在`系统变量`中，单击`新建` ，创建新的环境变量

  * 变量名输入`JAVA_HOME`，变量值输入 `D:\develop\Java\jdk1.8.0_202` ，并单击`确定`，如图所示：

    ![](imgs/环境变量5.jpg)

  * 选中`Path` 环境变量，`双击`或者`点击编辑` ,如图所示：

    ![](imgs/环境变量6.jpg)

  * 在变量值的最前面，键入`%JAVA_HOME%\bin;`  分号必须要写，而且还要是**英文符号**。如图所示：

    ![](imgs/环境变量7.jpg)

  * 环境变量配置完成，**重新开启**DOS命令行，在任意目录下输入`javac` 命令，运行成功。

    ![](imgs/环境变量8.jpg)


## 1.8 入门程序HelloWorld

### 1.8.1 HelloWorld案例

#### 程序开发步骤说明

JDK安装完毕，可以开发我们第一个Java程序了。

Java程序开发三步骤：**编写**、**编译**、**运行**。

![开发步骤](imgs/开发步骤.jpg)

#### 编写Java源程序

1. 在`D:\atguigu\javaee\JavaSE20190624\code\day01_code` 目录下新建文本文件，完整的文件名修改为`HelloWorld.java`，其中文件名为`HelloWorld`，后缀名必须为`.java` 。
2. 用记事本或notepad++等文本编辑器打开

3. 在文件中键入文本并保存，代码如下：

```java
public class HelloWorld {
  	public static void main(String[] args) {
    	System.out.println("HelloWorld");
  	}
}
```

> 友情提示：
>
> 每个字母和符号必须与示例代码一模一样。

第一个`HelloWord` 源程序就编写完成了，但是这个文件是程序员编写的，JVM是看不懂的，也就不能运行，因此我们必须将编写好的`Java源文件` 编译成JVM可以看懂的`字节码文件` ，也就是`.class`文件。

编译Java源文件

在DOS命令行中，**进入**`D:\atguigu\javaee\JavaSE20190624\code\day01_code`**目录**，使用`javac` 命令进行编译。

命令：

```java
javac Java源文件名.后缀名
```

举例：

```
javac HelloWorld.java
```

![1561387081272](imgs/1561387081272.png)

编译成功后，命令行没有任何提示。打开`D:\atguigu\javaee\JavaSE20190624\code\day01_code`目录，发现产生了一个新的文件 `HelloWorld.class`，该文件就是编译后的文件，是Java的可运行文件，称为**字节码文件**，有了字节码文件，就可以运行程序了。 

> Java源文件的编译工具`javac.exe`

#### 运行Java程序

在DOS命令行中，**进入Java源文件的目录**，使用`java` 命令进行运行。

命令：

```java
java 类名字
```

举例：

```
java HelloWorld
```

> 友情提示：
>
> java HelloWord  不要写 不要写 不要写 .class

![1561387134284](imgs/1561387134284.png)

> Java字节码文件的运行工具：java.exe

### 1.8.2 HelloWorld案例常见错误

* 	单词拼写问题
  * 正确：class		错误：Class
  * 正确：String              错误：string
  * 正确：System            错误：system
  * 正确：main		错误：mian
* 	Java语言是一门严格区分大小写的语言
* 	标点符号使用问题
  * 不能用中文符号，英文半角的标点符号（正确）
  * 括号问题，成对出现

### 1.8.3 Java程序的结构与格式

结构：

```java
类{
    方法{
        语句;
    }
}
```

格式：

（1）每一级缩进一个Tab键

（2）{}的左半部分在行尾，右半部分单独一行，与和它成对的"{"的行首对齐

### 1.8.4 Java程序的入口

Java程序的入口是main方法

```java
public static void main(String[] args){
    
}
```

### 1.8.5 编写Java程序时应该注意的问题

1、字符编码问题

	在使用javac命令式，可以指定源文件的字符编码

```cmd
javac -encoding utf-8 Review01.java
```



2、大小写问题

（1）源文件名：

	不区分大小写，我们建议大家还是区分

（2）字节码文件名与类名

	区分大小写

（3）代码中

	区分大小写



3、源文件名与类名一致问题？

（1）源文件名是否必须与类名一致？public呢？

如果这个类不是public，那么源文件名可以和类名不一致。

如果这个类是public，那么要求源文件名必须与类名一致。

我们建议大家，不管是否是public，都与源文件名保持一致，而且一个源文件尽量只写一个类，目的是为了好维护。



（2）一个源文件中是否可以有多个类？public呢？

一个源文件中可以有多个类，编译后会生成多个.class字节码文件。

但是一个源文件只能有一个public的类。



（3）main必须在public的类中吗？

不是。

但是后面写代码时，基本上main习惯上都在public类中。

# 第二章  Java基础知识

## 2.1 注释（*annotation*）

- **注释**：就是对代码的解释和说明。其目的是让人们能够更加轻松地了解代码。为代码添加注释，是十分必须要的，它不影响程序的编译和运行。
- Java中有`单行注释`、`多行注释`和`文档注释`
  - 单行注释以 `//`开头，以`换行`结束，格式如下：

    ```java
    // 注释内容
    ```

  - 多行注释以 `/*`开头，以`*/`结束，格式如下：

    ```java
    /*
    	注释内容
     */
    ```

  - 文档注释以`/**`开头，以`*/`结束 

    ```java
    /**
    	注释内容
     */
    javadoc -d 文件夹名 【-version -author】 源文件名.java
    ```

## 2.2 关键字（*keyword*）

**关键字**：是指在程序中，Java已经定义好的单词，具有特殊含义。

- HelloWorld案例中，出现的关键字有 `public ` 、`class` 、 `static` 、  `void`  等，这些单词已经被Java定义好
- 关键字的特点：全部都是`小写字母`。
- 关键字比较多，不需要死记硬背，学到哪里记到哪里即可。

![1555209180504](imgs/1555209180504.png)

>  **关键字一共50个，其中const和goto是保留字。**

> **true,false,null看起来像关键字，但从技术角度，它们是特殊的布尔值和空值。**



## 2.3 常量（*constant*）

* **常量：在程序执行的过程中，其值不可以发生改变的量**

* 常量的分类：

  * 自定义常量：通过final关键字定义（后面在面向对象部分讲解）

  * 字面值常量：

    | 字面值常量 |      举例      |
    | :--------: | :------------: |
    | 字符串常量 |  ”HelloWorld“  |
    |  整数常量  |    12，-23     |
    |  浮点常量  |     12.34      |
    |  字符常量  | ‘a’，'0'，‘沙’ |
    |  布尔常量  |  true，false   |
    |   空常量   |      null      |

    ```java
    public class ConstantDemo {
    	public static void main(String[] args) {
    		//字符串常量
    		System.out.println("HelloWorld");
    		
    		//整数常量
    		System.out.println(12);
    		System.out.println(-23);
    		
    		//小数常量
    		System.out.println(12.34);
    		
    		//字符常量
    		System.out.println('a');
    		System.out.println('0');
            System.out.println('沙');
    		
    		//布尔常量
    		System.out.println(true);
    		System.out.println(false);
    	}
    }
    ```

    > 注意事项：
    >
    > ​	字符常量，单引号里面有且仅有一个字符
    >
    > ​	空常量，不可以在输出语句中直接打印

## 2.4 标识符( identifier)

简单的说，凡是程序员自己命名的部分都可以称为标识符。

即给类、变量、方法、包等命名的字符序列，称为标识符。



1、标识符的命名规则（必须遵守）

（1）Java的标识符只能使用26个英文字母大小写，0-9的数字，下划线_，美元符号$

（2）不能使用Java的关键字（包含保留字）和特殊值

（3）数字不能开头

（4）不能包含空格

（5）严格区分大小写



2、标识符的命名规范（遭受鄙视）

（1）见名知意

（2）类名、接口名等：每个单词的首字母都大写，形式：XxxYyyZzz，

例如：HelloWorld，String，System等

（3）变量、方法名等：从第二个单词开始首字母大写，其余字母小写，形式：xxxYyyZzz，

例如：age,name,bookName,main

（4）包名等：每一个单词都小写，单词之间使用点.分割，形式：xxx.yyy.zzz，

例如：java.lang

（5）常量名等：每一个单词都大写，单词之间使用下划线_分割，形式：XXX_YYY_ZZZ，

例如：MAX_VALUE,PI

## 2.5 初识数据类型(data type)

### 数据类型分类

Java的数据类型分为两大类：

- **基本数据类型**：包括 `整数`、`浮点数`、`字符`、`布尔`。 
- **引用数据类型**：包括 `类`、`数组`、`接口`。 

### 基本数据类型

四类八种基本数据类型：

![](imgs/基本数据类型范围.jpg)

> Java中的默认类型：整数类型是`int` 、浮点类型是`double` 。

## 2.6 变量（*variable*）

### 2.6.1 变量的概念

**变量：在程序执行的过程中，其值可以发生改变的量**

变量的作用：用来存储数据，代表内存的一块存储区域，这块内存中的值是可以改变的。

### 2.6.2 变量的三要素

1、数据类型

2、变量名

3、值

### 2.6.3 变量的使用应该注意什么？

1、先声明后使用

> 如果没有声明，会报“找不到符号”错误

2、在使用之前必须初始化

> 如果没有初始化，会报“未初始化”错误

3、变量有作用域

> 如果超过作用域，也会报“找不到符号”错误

4、在同一个作用域中不能重名

### 2.6.4 变量的声明和赋值、使用的语法格式？

1、变量的声明的语法格式：

```java
数据类型  变量名;
例如：
int age;
String name;
double weight;
char gender;
boolean isMarry;
```

2、变量的赋值的语法格式：

```java
变量名 = 值;
例如：
age = 18;
name = "柴林燕"; //字符串的值必须用""
weight = 44.4;
gender = '女';//单字符的值必须使用''
isMarry = true;
```

3、变量的使用的语法格式：

```java
通过变量名直接引用
例如：
(1)输出变量的值
System.out.println(age);
System.out.println(name);
System.out.println(weight);
System.out.println(gender);
System.out.println(isMarry);

(2)计算
age = age + 1;//年龄增加1岁
```

### 2.6.7 练习：定义所有基本数据类型的变量和字符串变量并输出

```java
public class VariableDemo {
	public static void main(String[] args){
        // 定义字节型变量
        byte b = 100;
        System.out.println(b);
        // 定义短整型变量
        short s = 1000;
        System.out.println(s);
        // 定义整型变量
        int i = 123456;
        System.out.println(i);
        // 定义长整型变量
        long l = 12345678900L;
        System.out.println(l);
        // 定义单精度浮点型变量
        float f = 5.5F;
        System.out.println(f);
        // 定义双精度浮点型变量
        double d = 8.5;
        System.out.println(d);
        // 定义布尔型变量
        boolean bool = false;
        System.out.println(bool);
        // 定义字符型变量
        char c = 'A';
        System.out.println(c);
        
        // 定义字符串变量
        String s = "HelloWorld";
        System.out.println(s);
	}
}
```

> long类型：建议数据后加L表示。
>
> float类型：建议数据后加F表示。
>
> char类型：使用单引号''
>
> String类型：使用双引号""

## 2.7 两种常见的输出语句

* **换行输出语句**：输出内容，完毕后进行换行，格式如下：

  ```java
  System.out.println(输出内容);
  ```

* **直接输出语句**：输出内容，完毕后不做任何处理，格式如下

  ```java
  System.out.print(输出内容);
  ```

示例代码：

```java
String name = "范冰冰";
int age = 18;

对比如下两组代码：
System.out.println(name);
System.out.println(age);

System.out.print(name);
System.out.print(age);

对比如下两组代码：
System.out.print("姓名：" + name +",");//""中的内容会原样显示
System.out.println("年龄：" + age);//""中的内容会原样显示

System.out.print("name = " + name + ",");
System.out.println("age = " + age);
```




>
> 注意事项：
>
> ​	换行输出语句，括号内可以什么都不写，只做换行处理
>
> ​	直接输出语句，括号内什么都不写的话，编译报错
>
> ​	如果()中有多项内容，那么必须使用 + 连接起来
>
> ​	如果某些内容想要原样输出，就用""引起来，而要输出变量中的内容，则不要把变量名用""引起来