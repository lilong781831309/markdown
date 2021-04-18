# day09【面向对象基础--中】

## 今日内容

* 封装
* 权限修饰符
* 构造器
* this
* 包
* eclipse

## 教学目标

* [ ] 理解封装的概念
* [ ] 掌握属性的封装
* [ ] 掌握权限修饰符的使用
* [ ] 掌握构造器的声明与使用
* [ ] 掌握this关键字的使用
* [ ] 掌握包的定义和导入
* [ ] 熟练eclipse的使用

# 第六章 面向对象基础--中

## 6.1 封装

### 6.1.1 封装概述

1、为什么需要封装？

* 我要用洗衣机，只需要按一下开关和洗涤模式就可以了。有必要了解洗衣机内部的结构吗？有必要碰电动机吗？
* 我要开车，...

2、面向对象编程语言是对客观世界的模拟，客观世界里成员变量都是隐藏在对象内部的，外界无法直接操作和修改。封装可以被认为是一个保护屏障，防止该类的代码和数据被其他类随意访问。要访问该类的数据，必须通过指定的方式。适当的封装可以让代码更容易理解与维护，也加强了代码的安全性。

3、这个就是我们说的“高内聚，低耦合”的体现之一：

* 高内聚：类的内部数据操作细节自己完成，不允许外部干涉；
* 低耦合：仅对外暴露少量的方法用于使用

隐藏对象内部的复杂性，只对外公开简单的接口。便于外界调用，从而提高系统的可扩展性、可维护性。通俗的讲，把该隐藏的隐藏起来，该暴露的暴露出来。这就是封装性的设计思想。

4、封装的设计思想的应用

（1）类的封装：把属性和方法封装到类的内部，外部通过调用方法完成指定的功能，不需要了解类的内部实现

（2）组件的封装：例如支付宝等支付组件，对外只提供使用接口，我们不需要也无法了解内部的实现

（3）系统的封装：例如我们使用操作系统等，我们只需要知道怎么用，不需要了解内部的实现

### 6.1.2 属性的封装

#### 原则

将**属性隐藏**起来，若需要访问某个属性，**提供公共方法**对其访问。

#### 属性封装的目的

* 隐藏类的实现细节
* 让使用者只能通过事先预定的方法来访问数据，从而可以在该方法里面加入控制逻辑，限制对成员变量的不合理访问。
* 可以进行数据检查，从而有利于保证对象信息的完整性。
* 便于修改，提高代码的可维护性。

#### 实现步骤

1. 使用 `private` 修饰成员变量

```java
private 数据类型 变量名 ；
```

代码如下：

```java
public class Student {
  private String name;
  private int age;
}
```

2. 提供 `getXxx`方法 / `setXxx` 方法，可以访问成员变量，代码如下：

```java
public class Student {
  private String name;
  private int age;

  public void setName(String n) {
    name = n;
  }

  public String getName() {
    return name;
  }

  public void setAge(int a) {
    age = a;
  }

  public int getAge() {
    return age;
  }
}
```

### 6.1.3 权限修饰符

![1561766960617](imgs/1561766960617.png)

> 对于类的成员：四种权限修饰符都可以使用
>
> 对于外部的类：只能使用public和缺省两种

![1561767277965](imgs/1561767277965.png)

#### 练习1

（1）定义学生类Student

​	声明姓名和成绩实例变量，私有化，提供get/set

​	getInfo()方法：用于返回学生对象的信息

（2）测试类ObjectArrayTest的main中创建一个可以装3个学生对象的数组，并且按照学生成绩排序，显示学生信息

```java
class Test22_Exer{
	public static void main(String[] args){
		//创建一个可以装3个学生对象的数组
		Student[] arr = new Student[3];//只是申明这个数组，可以用来装3个学生，此时里面没有学生对象
		
		//手工赋值
		arr[0] = new Student();
		arr[0].setName("张三");
		arr[0].setScore(78);
		
		arr[1] = new Student();
		arr[1].setName("李四");
		arr[1].setScore(96);
		
		arr[2] = new Student();
		arr[2].setName("王五");
		arr[2].setScore(56);
		
		//先显示一下目前的顺序
		for(int i=0; i<arr.length; i++){
			System.out.println(arr[i].getInfo());
		}
		
		System.out.println("------------------------------------------");
		//冒泡排序
		for(int i=1; i<arr.length; i++){
			for(int j=0; j<arr.length-i; j++){
				//arr[j] > arr[j+1]//错误的
				if(arr[j].getScore() > arr[j+1].getScore()){
					//交换两个元素，这里是两个学生对象，所以temp也得是Student类型
					Student temp = arr[j];
					arr[j] = arr[j+1];
					arr[j+1] = temp;
				}
			}
		}
		//再显示一下目前的顺序
		for(int i=0; i<arr.length; i++){
			System.out.println(arr[i].getInfo());
		}
	}
}
class Student{
	private String name;
	private int score;//使用int或double都可以
	
	//get/set方法，
	public void setName(String n){
		name = n;
	}
	public String getName(){
		return name;
	}
	public void setScore(int s){
		score = s;
	}
	public int getScore(){
		return score;
	}
	
	public String getInfo(){
		return "姓名：" + name +"，成绩：" + score;
	}
}
```

```java
class Test22_Exer_2{
	public static void main(String[] args){
		//创建一个可以装3个学生对象的数组
		Student[] arr = new Student[3];//只是申明这个数组，可以用来装3个学生，此时里面没有学生对象
		
		//从键盘输入
		java.util.Scanner input = new java.util.Scanner(System.in);
		for(int i=0;i<arr.length; i++){
			System.out.println("请输入第" + (i+1) + "个学生信息：");
			arr[i] = new Student();
			
			System.out.print("姓名：");
			String name = input.next();
			arr[i].setName(name);
			
			System.out.print("成绩：");
			arr[i].setScore(input.nextInt());
		}
		
		//先显示一下目前的顺序
		for(int i=0; i<arr.length; i++){
			System.out.println(arr[i].getInfo());
		}
		
		System.out.println("------------------------------------------");
		//冒泡排序
		for(int i=1; i<arr.length; i++){
			for(int j=0; j<arr.length-i; j++){
				//arr[j] > arr[j+1]//错误的
				if(arr[j].getScore() > arr[j+1].getScore()){
					//交换两个元素，这里是两个学生对象，所以temp也得是Student类型
					Student temp = arr[j];
					arr[j] = arr[j+1];
					arr[j+1] = temp;
				}
			}
		}
		//再显示一下目前的顺序
		for(int i=0; i<arr.length; i++){
			System.out.println(arr[i].getInfo());
		}
	}
}
class Student{
	private String name;
	private int score;//使用int或double都可以
	
	//get/set方法，
	public void setName(String n){
		name = n;
	}
	public String getName(){
		return name;
	}
	public void setScore(int s){
		score = s;
	}
	public int getScore(){
		return score;
	}
	
	public String getInfo(){
		return "姓名：" + name +"，成绩：" + score;
	}
}
```



## 6.2 构造器（Constructor)

构造器又称为构造方法，那是因为它长的很像方法。但是和方法还有有所区别的。

### 构造器的作用

​	要创建一个类的实例对象，必须调用一个对象的构造器，来完成类的实例初始化过程。实例初始化过程就是为实例变量赋初始值的过程。



当一个对象被创建时候，构造方法用来初始化该对象，给对象的成员变量赋初始值。

> 小贴士：无论你与否自定义构造方法，所有的类都有构造方法，因为Java自动提供了一个无参数构造方法，一旦自己定义了构造方法，Java自动提供的默认无参数构造方法就会失效。

### 构造方法的定义格式

```java
【修饰符】 构造器名(){
    // 实例初始化代码
}
【修饰符】 构造器名(参数列表){
	// 实例初始化代码
}
```

代码如下：

```java
public class Student {
	private String name;
	private int age;
	// 无参构造
  	public Student() {} 
 	// 有参构造
  	public Student(String n,int a) {
		name = n;
    	age = a; 
	}
    //此处其他代码省略
}
```

### 注意事项

1. 构造器名必须与它所在的类名必须相同。
2. 它没有返回值，所以不需要返回值类型，甚至不需要void
3. 如果你不提供构造器，系统会给出无参数构造器，并且该构造器的修饰符默认与类的修饰符相同
4. 如果你提供了构造器，系统将不再提供无参数构造器，除非你自己定义。
5. 构造器是可以重载的，既可以定义参数，也可以不定义参数。
6. 构造器不能被static、final、synchronized、abstract、native修饰

### 练习

（1）声明一个员工类，

* 包含属性：编号、姓名、薪资、性别，要求属性私有化，提供get/set，
* 提供无参构造器和有参构造器
* 提供getInfo()

（2）在测试类的main中分别用无参构造和有参构造创建员工类对象，调用getInfo

```java
class Test02_Constructor_Exer{
	public static void main(String[] args){
		//分别用无参构造和有参构造创建对象，调用getInfo
		Employee e1 = new Employee();
		System.out.println(e1.getInfo());
		
		Employee e2 = new Employee("1001","张三",110000,'男');
		System.out.println(e2.getInfo());
		
		e2.setSalary(120000);
		System.out.println(e2.getInfo());
		
		System.out.println("e1薪资：" + e1.getSalary());
	}
}
class Employee{
	private String id;
	private String name;
	private double salary;
	private char gender;
	
	//提供无参构造器和有参构造器
	Employee(){
		
	}
	Employee(String i, String n){
		id = i;
		name = n;
	}
	Employee(String i, String n, double s, char g){
		id = i;
		name = n;
		salary = s;
		gender = g;
	}
	
	//提供get/set，
	public void setId(String i){
		id = i;
	}
	public String getId(){
		return id;
	}
	public void setName(String n){
		name = n;
	}
	public String getName(){
		return name;
	}
	public void setSalary(double s){
		salary = s;
	}
	public double getSalary(){
		return salary;
	}
	public void setGender(char g){
		gender = g;
	}
	public char getGender(){
		return gender;
	}
	//提供getInfo()
	public String getInfo(){
		return "编号：" + id + "，姓名：" + name + "，薪资：" + salary + "，性别：" +gender;
	}
}
```



## 6.3 this关键字

我们发现 `setXxx` 方法中的形参名字和构造器的形参名称并不符合见名知意的规定，那么如果修改与成员变量名一致，会怎么样呢？代码如下：

```java
public class Student {
	private String name;
	private int age;

	public Student(String name, int age) {
		name = name;
		age = age;
	}

	public void setName(String name) {
		name = name;
	}

	public void setAge(int age) {
		age = age;
	}
}
```

经过修改和测试，我们发现新的问题，成员变量赋值失败了。也就是说，在修改了`setXxx()` 的形参变量名后，方法并没有给成员变量赋值！这是由于形参变量名与成员变量名重名，导致成员变量名被隐藏，方法中的变量名，无法访问到成员变量，从而赋值失败。所以，我们只能使用this关键字，来解决这个重名问题。

### this的含义

this代表当前对象的引用（地址值），即对象自己的引用。

* this可以用于构造器中：表示正在创建的那个实例对象，即正在new谁，this就代表谁
* this用于实例方法中：表示调用该方法的对象，即谁在调用，this就代表谁。

### this使用格式

1、this.成员变量名

当方法的局部变量与当前对象的成员变量重名时，就可以在成员变量前面加this.，如果没有重名问题，就可以省略this.

```java
this.成员变量名；
```

2、this.成员方法

调用当前对象自己的成员方法时，都可以加"this."，也可以省略，实际开发中都省略

```java
【变量=】this.成员方法(【实参列表】);
```

3、this()或this(实参列表)

当需要调用本类的其他构造器时，就可以使用该形式。

要求：

必须在构造器的首行

如果一个类中声明了n个构造器，则最多有 n - 1个构造器中使用了"this(【实参列表】)"，否则会发生递归调用死循环

### 练习

（1）声明一个员工类，

* 包含属性：编号、姓名、薪资、性别，要求属性私有化，提供get/set，
* 提供无参构造器和有参构造器
* 提供getInfo()

（2）在测试类的main中分别用无参构造和有参构造创建员工类对象，调用getInfo

```

```

## 6.4 标准JavaBean

`JavaBean` 是 Java语言编写类的一种标准规范。符合`JavaBean` 的类，要求类必须是具体的和公共的，并且具有无参数的构造方法，成员变量私有化，并提供用来操作成员变量的`set` 和`get` 方法。

```java
public class ClassName{
  //成员变量
    
  //构造方法
  	//无参构造方法【必须】
  	//有参构造方法【建议】
  	
  //getXxx()
  //setXxx()
  //其他成员方法
}
```

 编写符合`JavaBean` 规范的类，以学生类为例，标准代码如下：

```java
public class Student {
	// 成员变量
	private String name;
	private int age;

	// 构造方法
	public Student() {
	}

	public Student(String name, int age) {
		this.name = name;
		this.age = age;
	}

	// get/set成员方法
	public void setName(String name) {
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public int getAge() {
		return age;
	}
    
    //其他成员方法列表
    public String getInfo(){
        return "姓名：" + name + "，年龄：" + age;
    }
}
```

测试类，代码如下：

```java
public class TestStudent {
	public static void main(String[] args) {
		// 无参构造使用
		Student s = new Student();
		s.setName("柳岩");
		s.setAge(18);
		System.out.println(s.getName() + "---" + s.getAge());
        System.out.println(s.getInfo());

		// 带参构造使用
		Student s2 = new Student("赵丽颖", 18);
		System.out.println(s2.getName() + "---" + s2.getAge());
        System.out.println(s2.getInfo());
	}
}
```

## 6.5 包（Package）

### 6.5.1 包的作用

1、可以避免类重名

有了包之后，类的全名称就变为：包.类名

2、分类组织管理众多的类

例如：

* java.lang----包含一些Java语言的核心类，如String、Math、Integer、 System和Thread等，提供常用功能
* java.net----包含执行与网络相关的操作的类和接口。
* java.io ----包含能提供多种输入/输出功能的类。
* java.util----包含一些实用工具类，如集合框架类、日期时间、数组工具类Arrays，文本扫描仪Scanner，随机值产生工具Random。
* java.text----包含了一些java格式化相关的类
* java.sql和javax.sql----包含了java进行JDBC数据库编程的相关类/接口
* java.awt和java.swing----包含了构成抽象窗口工具集（abstract window toolkits）的多个类，这些类被用来构建和管理应用程序的图形用户界面(GUI)。

3、可以控制某些类型或成员的可见范围

如果某个类型或者成员的权限修饰缺省的话，那么就仅限于本包使用



### 6.5.2 声明包的语法格式

```java
package 包名;
```

> 注意：
>
> (1)必须在源文件的代码首行
>
> (2)一个源文件只能有一个声明包的语句

包的命名规范和习惯：
（1）所有单词都小写，每一个单词之间使用.分割
（2）习惯用公司的域名倒置

例如：com.atguigu.xxx;

> 建议大家取包名时不要使用“java.xx"包

### 6.5.3  如何编译和运行（了解，之后在idea中就不用了）

编译格式：

```
javac -d class文件存放路径 源文件路径名.java
```

例如：

```java
package com.atguigu.demo;

public class TestPackage {
	public static void main(String[] args) {
		System.out.println("hello package");
	}
}
```
编译：
```java
javac -d . TestPackage.java
```

> 其中 . 表示在当前目录生成包目录

运行：

```java
java com.atguigu.demo.TestPackage
```

> 定位到com目录的外面才能正确找到这个类
>
> 使用类的全名称才能正确运行这个类

### 6.5.4 使用其他包的类

前提：被使用的类或成员的权限修饰符是>缺省的

（1）使用类型的全名称

例如：java.util.Scanner input = new java.util.Scanner(System.in);

（2）使用import 语句之后，代码中使用简名称

import语句告诉编译器到哪里去寻找类。

import语句的语法格式：

```java
import 包.类名;
import 包.*;
import static 包.类名.静态成员; //后面补充
```

> 注意：
>
> 使用java.lang包下的类，不需要import语句，就直接可以使用简名称
>
> import语句必须在package下面，class的上面
>
> 当使用两个不同包的同名类时，例如：java.util.Date和java.sql.Date。一个使用全名称，一个使用简名称



示例代码：

```java
package com.atguigu.bean;

public class Student {
	// 成员变量
	private String name;
	private int age;

	// 构造方法
	public Student() {
	}

	public Student(String name, int age) {
		this.name = name;
		this.age = age;
	}

	// 成员方法
	public void setName(String name) {
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public int getAge() {
		return age;
	}
}
```

```java
package com.atguigu.test;

import java.util.Scanner;
import java.util.Date;
import com.atguigu.bean.Student;

public class Test{
    public static void main(String[] args){
        Scanner input = new Scanner(System.in);
        Student stu = new Student();
        String str = "hello";
        
        Date now = new Date();
        java.sql.Date d = new java.sql.Date(346724566);        
    }
}
```

# 

