# 10_【static、几个工具类、项目二】

## 今日内容

* static修饰符
* 数组工具类
* 数学工具类
* 使用eclipse进行项目开发

## 学习目标

* [ ] 能够声明静态方法
* [ ] 能够调用静态方法
* [ ] 能够分别哪些成员变量应该是静态变量
* [ ] 能够访问和操作静态变量
* [ ] 能够f分析不同变量的区别
* [ ] 掌握几个常用工具类的API的使用

# 第六章 面向对象基础--中（续）

## 6.6 static

static是一个成员修饰符，可以修饰类的成员：成员变量、成员方法、成员内部类（后面讲）、代码块（后面讲）。被修饰的成员是**属于类**的，而不是单单是属于某个对象的。也就是说，既然属于类，就可以不靠创建对象来调用了。

### 6.6.1 静态方法

static修饰的成员方法，称为类方法、静态方法。

语法格式：

```java
【其他修饰符】 static 返回值类型 方法名 (【形参列表】){ 
	// 执行语句 
}
```

（1）在本类中，静态方法可以直接访问静态方法和静态变量。

（2）在其他类中：可以使用“类名.方法"进行调用，也可以使用"对象名.方法"，推荐使用“类名.方法"

（3）在静态方法中，**不能出现**：this，也**不能直接**使用本类的非静态的成员。相反，非静态的实例成员方法可以直接访问静态的类变量或静态方法。

​	this，非静态的成员，这些都是需要创建对象时，才能使用的，而静态方法调用时，可能没有对象。

> 小贴士：静态方法只能访问静态成员。

```java
public class Test{
    public static void main(String[] args){
    	Son s = new Son();
    	s.fun();//有警告，没错误
    	
    	Son.fun();
    }
}

class Son{
	private int a;	
	public static void fun(){
//		method();//错误的
//		System.out.println(a);//错误
//		System.out.println(this.a);//错误

		System.out.println("Son:fun()");
	}
	public void method(){
		System.out.println("Son:method()");
	}
}
```

### 6.6.2 静态变量

static修饰的成员变量，称为类变量、静态变量。

（1）该成员变量的值是该类所有对象共享的

（2）类变量的值和类信息一起存在于方法区中。

（3）它的get/set也是static的，

（4）在static方法中如果有局部变量与类变量重名时，使用“类名.成员变量"进行区别

```java
public class Test{
    public static void main(String[] args){
    	Chinese c1 = new Chinese("张三");
    	Chinese c2 = new Chinese("李四");
    	System.out.println("国家名：" + c1.getCountry() + "，姓名：" + c1.getName());
    	System.out.println("国家名：" + c2.getCountry() + "，姓名：" + c2.getName());
    	
    	c1.setCountry("中国");//两个对象共享，一个对象修改，会影响另一个对象
    	System.out.println("国家名：" + c1.getCountry() + "，姓名：" + c1.getName());
    	System.out.println("国家名：" + c2.getCountry() + "，姓名：" + c2.getName());
    	
    	Chinese.setCountry("China");//通过“类名.”访问可读性更好
    	System.out.println("国家名：" + c1.getCountry() + "，姓名：" + c1.getName());
    	System.out.println("国家名：" + c2.getCountry() + "，姓名：" + c2.getName());
    }
}
class Chinese{
	private static String country = "中华人民共和国";
	private String name;

	public Chinese(String name) {
		super();
		this.name = name;
	}

	public static String getCountry() {
		return country;
	}

	public static void setCountry(String country) {
		Chinese.country = country;//类名.静态变量来区别区别同名变量
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	 
}
```

![1561989688776](imgs/1561989688776.png)

#### 练习

比如说，基础班新班开班，学员报到。现在想为每一位新来报到的同学编学号（sid），从第一名同学开始，sid为1，以此类推。学号必须是唯一的，连续的，并且与班级的人数相符，这样以便知道，要分配给下一名新同学的学号是多少。这样我们就需要一个变量，与单独的每一个学生对象无关，而是与整个班级同学数量有关。

所以，我们可以这样定义一个静态变量numberOfStudent，代码如下：

```java
public class Student {
  private String name;
  private int age;
  // 学生的id
  private int sid;
  // 类变量，记录学生数量，分配学号
  public static int numberOfStudent = 0;

  public Student(String name, int age){
    this.name = name;
    this.age = age; 
    // 通过 numberOfStudent 给学生分配学号
    this.sid = ++numberOfStudent;
  }

  // 打印属性值
  public void show() {
    System.out.println("Student : name=" + name + ", age=" + age + ", sid=" + sid );
  }
}

public class StuDemo {
  public static void main(String[] args) {
    Student s1 = new Student("张三", 23);
    Student s2 = new Student("李四", 24);
    Student s3 = new Student("王五", 25);
    Student s4 = new Student("赵六", 26);

    s1.show(); // Student : name=张三, age=23, sid=1
    s2.show(); // Student : name=李四, age=24, sid=2
    s3.show(); // Student : name=王五, age=25, sid=3
    s4.show(); // Student : name=赵六, age=26, sid=4
  }
}
```



### 6.6.3 静态导入

JDK1.5引入静态导入

```java
package com.atguigu.test;

import static java.lang.Math.*;

public class Test{
    public static void main(String[] args){
    	System.out.println("PI：" + Math.PI);
    	System.out.println("平方根：" + Math.sqrt(4));
    	System.out.println("随机数：" + Math.random());
    	
    	//有静态导入，可以简写如下
    	System.out.println("PI：" + PI);
    	System.out.println("平方根：" + sqrt(4));
    	System.out.println("随机数：" + random());
    }
}
```

### 6.6.4 变量的分类与区别详解

1、变量按照数据类型分：

（1）基本数据类型的变量，里面存储数据值

（2）引用数据类型的变量，里面存储对象的地址值

```java
int a = 10;//a中存储的是数据值

Student stu = new Student();//stu存储的是对象的地址值
int[] arr = new int[5];//arr存储的是数组对象的地址值
String str = "hello";//str存储的是"hello"对象的地址值
```

2、变量按照声明的位置不同：

（1）成员变量

（2）局部变量

```java
class Person{
	private static String country = "中华人民共和国";//成员变量，静态成员变量,类变量，"中华人民共和国"是常量值
	private String name;////成员变量，非静态成员变量，实例变量
	public Person(String name) {//name 局部变量
		this.name = name;//=左边带this.的是成员变量，=右边没有this.的是局部变量
	}
	public Person() {
	}
	public static String getCountry() {
		return country;//成员变量
	}
	public static void setCountry(String country) {//局部变量
		Person.country = country;//=左边带类名.的是成员变量，=右边是局部变量
	}
	public String getName() {
		return name;//成员变量
	}
	public void setName(String name) {//局部变量
		this.name = name;//=左边带this.的是成员变量，=右边是局部变量
	}
}
```

```java
public class Test{
    public static void main(String[] args){//args局部变量
    	String n1 = "张三";//n1局部变量，"张三"是常量值
    	Person p1 = new Person(n1);//p1局部变量
    	
    	String n2 = "李四";//n2局部变量，"李四"是常量值
    	Person p2 = new Person(n2);//p2局部变量
        
        p1.setName("张三丰");//"张三丰"是常量值
    	
    	Person.setCountry("中国");//"中国"是常量值
    }
}
```

3、成员变量与局部变量的区别

（1）声明的位置不同

成员变量：类中方法外

局部变量：（1）方法的()中，即形参（2）方法体的{}的局部变量（3）代码块{}中

（2）存储的位置不同

成员变量：

​	如果是静态变量（类变量），在方法区中

​	如果是非静态的变量（实例变量），在堆中

 局部变量：栈

![1562081904187](imgs/1562081904187.png)

（3）修饰符不同

成员变量：4种权限修饰符、static等多种修饰符

局部变量：不能有任何修饰符

（4）作用域

成员变量：

​	如果是静态变量（类变量），在本类中随便用，在其他类中使用“类名.静态变量"

​	如果是非静态的变量（实例变量），在本类中只能在非静态成员中使用，在其他类中使用“对象名.非静态的变量"

局部变量：有作用域，出了作用域就不能使用

（5）生命周期

成员变量：

​	如果是静态变量（类变量），和类相同，随着类的加载而分配，随着的类的卸载才消亡。

​	如果是非静态的变量（实例变量），和所属的对象相同，每一个对象是独立。对象创建时，才在堆中分配内存，随着对象被垃圾回收而消亡。

局部变量：每次方法调用执行都是新的，而且仅在作用域范围内有效。

### 6.6.5  系统预定义工具类的静态方法

#### 1、数组工具类Arrays

java.util.Arrays数组工具类，提供了很多静态方法来对数组进行操作，而且如下每一个方法都有各种重载形式，以下只列出int[]类型的，其他类型的数组类推：

* static int binarySearch(int[] a, int key) ：要求数组有序，在数组中查找key是否存在，如果存在返回第一次找到的下标，不存在返回负数

* static int[] copyOf(int[] original, int newLength)  ：根据original原数组复制一个长度为newLength的新数组，并返回新数组

* static int[] copyOfRange(int[] original, int from, int to) ：复制original原数组的[from,to)构成新数组，并返回新数组

* static boolean equals(int[] a, int[] a2) ：比较两个数组的长度、元素是否完全相同

* static void fill(int[] a, int val) ：用val填充整个a数组
* static void fill(int[] a, int fromIndex, int toIndex, int val)：将a数组[fromIndex,toIndex)部分填充为val 
* static void sort(int[] a) ：将a数组按照从小到大进行排序
* static void sort(int[] a, int fromIndex, int toIndex) ：将a数组的[fromIndex, toIndex)部分按照升序排列
* static String toString(int[] a) ：把a数组的元素，拼接为一个字符串，形式为：[元素1，元素2，元素3。。。]

示例代码：

```java
import java.util.Arrays;
import java.util.Random;

public class Test{
    public static void main(String[] args){
    	int[] arr = new int[5];
        // 打印数组,输出地址值
  		System.out.println(arr); // [I@2ac1fdc4
  		// 数组内容转为字符串
    	System.out.println("arr数组初始状态："+ Arrays.toString(arr));
    	
    	Arrays.fill(arr, 3);
    	System.out.println("arr数组现在状态："+ Arrays.toString(arr));
    	
    	Random rand = new Random();
    	for (int i = 0; i < arr.length; i++) {
			arr[i] = rand.nextInt(100);//赋值为100以内的随机整数
		}
    	System.out.println("arr数组现在状态："+ Arrays.toString(arr));
    	
    	int[] arr2 = Arrays.copyOf(arr, 10);
    	System.out.println("新数组：" + Arrays.toString(arr2));
    	
    	System.out.println("两个数组的比较结果：" + Arrays.equals(arr, arr2));
    	
    	Arrays.sort(arr);
    	System.out.println("arr数组现在状态："+ Arrays.toString(arr));
    }
}
```

#### 2、系统类System的几个方法

系统类中很多好用的方法，其中两个如下：

* static long currentTimeMillis() ：返回当前系统时间距离1970-1-1 0:0:0的毫秒值

* static void arraycopy(Object src, int srcPos, Object dest, int destPos, int length)： 

  从指定源数组中复制一个数组，复制从指定的位置开始，到目标数组的指定位置结束。常用于数组的插入和删除

* static void exit(int status) ：退出当前系统

* static void gc() ：运行垃圾回收器。

```java
public class Test{
    public static void main(String[] args){
    	long time = System.currentTimeMillis();
    	System.out.println("现在的系统时间距离1970年1月1日凌晨：" + time + "毫秒");
    	
    	System.exit(0);

    	System.out.println("over");//不会执行
    }
}
```

```java
import java.util.Arrays;

public class Test{
    public static void main(String[] args){
    	//在[0]插入10
    	int[] arr = {1,2,3,4,5};
    	//先扩容
    	arr = Arrays.copyOf(arr, arr.length+1);
    	//往后移动元素
    	System.arraycopy(arr, 0, arr, 1, 5);
    	//在[0]插入10
    	arr[0] = 10;
    	System.out.println(Arrays.toString(arr));
    	
    	
    	//删除[0]元素
    	int[] arr2 = {1,2,3,4,5};
    	//往前移动元素
    	System.arraycopy(arr2, 1, arr2, 0, 4);
    	//最后位置恢复为默认值
    	arr2[arr2.length-1] = 0;
    	System.out.println(Arrays.toString(arr2));
    }
}
```

#### 3、数学类Math

`java.lang.Math` 类包含用于执行基本数学运算的方法，如初等指数、对数、平方根和三角函数。类似这样的工具类，其所有方法均为静态方法，并且不会创建对象，调用起来非常简单。

* `public static double abs(double a) ` ：返回 double 值的绝对值。 

```java
double d1 = Math.abs(-5); //d1的值为5
double d2 = Math.abs(5); //d2的值为5
```

* `public static double ceil(double a)` ：返回大于等于参数的最小的整数。

```java
double d1 = Math.ceil(3.3); //d1的值为 4.0
double d2 = Math.ceil(-3.3); //d2的值为 -3.0
double d3 = Math.ceil(5.1); //d3的值为 6.0
```

* `public static double floor(double a) ` ：返回小于等于参数最大的整数。

```java
double d1 = Math.floor(3.3); //d1的值为3.0
double d2 = Math.floor(-3.3); //d2的值为-4.0
double d3 = Math.floor(5.1); //d3的值为 5.0
```

* `public static long round(double a)` ：返回最接近参数的 long。(相当于四舍五入方法)  

```java
long d1 = Math.round(5.5); //d1的值为6.0
long d2 = Math.round(5.4); //d2的值为5.0
```

* public static double pow(double a,double b)：返回a的b幂次方法
* public static double sqrt(double a)：返回a的平方根
* public static double random()：返回[0,1)的随机值
* public static final double PI：返回圆周率
* public static double max(double x, double y)：返回x,y中的最大值
* public static double min(double x, double y)：返回x,y中的最小值

```java
double result = Math.pow(2,31);
double sqrt = Math.sqrt(256);
double rand = Math.random();
double pi = Math.PI;
```

##### 练习 

请使用`Math` 相关的API，计算在 `-10.8`  到`5.9`  之间，绝对值大于`6`  或者小于`2.1` 的整数有多少个？

```java
public class MathTest {
  public static void main(String[] args) {
    // 定义最小值
    double min = -10.8;
    // 定义最大值
    double max = 5.9;
    // 定义变量计数
    int count = 0;
    // 范围内循环
    for (double i = Math.ceil(min); i <= max; i++) {
      // 获取绝对值并判断
      if (Math.abs(i) > 6 || Math.abs(i) < 2.1) {
        // 计数
        count++;
      }
    }
    System.out.println("个数为: " + count + " 个");
  }
}
```



# 项目二：客户信息管理系统