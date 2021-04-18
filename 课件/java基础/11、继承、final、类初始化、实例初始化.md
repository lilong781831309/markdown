# 11_【继承、初始化】

## 今日内容

- 三大特性——继承（重点）
- 方法重写（重点）
- super关键字（重点）
- final修饰符（重点）
- 类初始化（难）
- 实例初始化（难）

## 学习目标

- [ ] 能够写出类的继承格式
- [ ] 能够说出继承的特点
- [ ] 能够说出子类调用父类的成员特点
- [ ] 能够说出方法重写的概念
- [ ] 能够说出super可以解决的问题
- [ ] 掌握final的使用
- [ ] 能够分析类初始化过程
- [ ] 能够分析实例初始化过程

# 第六章 面向对象基础--中（续）

## 6.7 继承

### 6.7.1 继承的概述

#### 生活中的继承

* 财产：富二代

* 样貌：如图所示：

  ![](img\继承1.jpg)

  ![](img\继承2.jpg)

  ![](img\继承3.jpg)

* 才华：如图所示：

  ![](img\继承4.jpg)

#### 继承的由来

如图所示：

![](img/猫狗继承1.jpg)

多个类中存在相同属性和行为时，将这些内容抽取到单独一个类中，那么多个类中无需再定义这些属性和行为，只需要和抽取出来的类构成某种关系。如图所示：

![](img\猫狗继承2.jpg)

其中，多个类可以称为**子类**，也叫**派生类**；多个类抽取出来的这个类称为**父类**、**超类（superclass）**或者**基类**。

继承描述的是事物之间的所属关系，这种关系是：`is-a` 的关系。例如，图中猫属于动物，狗也属于动物。可见，父类更通用，子类更具体。我们通过继承，可以使多种事物之间形成一种关系体系。

#### 继承的理解

* **继承**：就是子类继承父类的**属性**和**行为**，使得子类对象具有与父类相同的属性、相同的行为。

#### 继承的好处

* 提高**代码的复用性**。

* 提高**代码的扩展性**。

* 类与类之间产生了关系，是学习**多态的前提**。

### 6.7.2 继承的格式

通过 `extends` 关键字，可以声明一个子类继承另外一个父类，定义格式如下：

```java
【修饰符】 class 父类 {
	...
}

【修饰符】 class 子类 extends 父类 {
	...
}

```

继承演示，代码如下：

```java
/*
 * 定义动物类Animal，做为父类
 */
class Animal {
    // 定义name属性
	public String name; 
    // 定义age属性
    public int age;
	// 定义动物的吃东西方法
	public void eat() {
		System.out.println(age + "岁的" + name + "在吃东西");
	}
}

/*
 * 定义猫类Cat 继承 动物类Animal
 */
class Cat extends Animal {
	// 定义一个猫抓老鼠的方法catchMouse
	public void catchMouse() {
		System.out.println("抓老鼠");
	}
}

/*
 * 定义测试类
 */
public class ExtendDemo01 {
	public static void main(String[] args) {
        // 创建一个猫类对象
		Cat cat = new Cat()；
      
        // 为该猫类对象的name属性进行赋值
		cat.name = "Tom";
      
      	// 为该猫类对象的age属性进行赋值
		cat.age = 2;
        
        // 调用该猫的catchMouse()方法
		cat.catchMouse();
		
      	// 调用该猫继承来的eat()方法
      	cat.eat();
	}
}

演示结果：
抓老鼠
2岁的Tom在吃东西
```

### 6.7.3 继承的特点一：成员变量

#### 私有化（private）

* 父类中的成员，无论是公有(public)还是私有(private)，均会被子类继承。
* 子类虽会继承父类私有(private)的成员，但子类不能对继承的私有成员直接进行访问，可通过继承的公有方法进行访问。如图所示：

![](img\继承私有成员1.jpg)

代码如下：

```java
/*
 * 定义动物类Animal，做为父类
 */
class Animal {
    // 定义name属性
	private String name; 
    // 定义age属性
    public int age;
	// 定义动物的吃东西方法
	public void eat() {
		System.out.println(age + "岁的" + name + "在吃东西");
	}
}
/*
 * 定义猫类Cat 继承 动物类Animal
 */
class Cat extends Animal {
	// 定义一个猫抓老鼠的方法catchMouse
	public void catchMouse() {
		System.out.println("抓老鼠");
	}
}

/*
 * 定义测试类
 */
public class ExtendDemo01 {
	public static void main(String[] args) {
        // 创建一个猫类对象
		Cat cat = new Cat()；
      
        // 为该猫类对象的name属性进行赋值
		//t.name = "Tom";// 编译报错
      
      	// 为该猫类对象的age属性进行赋值
		t.age = 2;
        
        // 调用该猫的catchMouse()方法
		t.catchMouse();
		
      	// 调用该猫继承来的eat()方法
      	t.eat();
	}
}
```

如图所示：

![](img\继承私有成员2.jpg)

#### 成员变量不重名

如果子类父类中出现**不重名**的成员变量，这时的访问是**没有影响的**。代码如下：

```java
class Fu {
	// Fu中的成员变量。
	int num01 = 3;
}

class Zi extends Fu {
	// Zi中的成员变量
	int num02 = 4;
	// Zi中的成员方法
	public void show() {
		// 访问父类中的num，
		System.out.println("num1 = " + num1); 
		// 访问子类中的num2
		System.out.println("num2 = " + num2);
	}
}

class ExtendDemo02 {
	public static void main(String[] args) {
        // 创建子类对象
		Zi z = new Zi(); 
      	// 调用子类中的show方法
		z.show();  
	}
}

演示结果：
num1 = 3
num2 = 4
```

#### 成员变量重名

如果子类父类中出现**重名**的成员变量，这时的访问是**有影响的**。代码如下：

```java
class Fu {
	// Fu中的成员变量。
	int num = 3;
}

class Zi extends Fu {
	// Zi中的成员变量
	int num = 4;
	public void show() {
		// 访问的num到底是子类还是父类？
		System.out.println("num = " + num);

	}
}
class ExtendsDemo03 {
	public static void main(String[] args) {
      	// 创建子类对象
		Zi z = new Zi(); 
      	// 调用子类中的show方法
		z.show(); 
	}
}
演示结果：
num = 4
```

子父类中出现了同名的成员变量时，在子类中需要访问父类中非私有成员变量时，需要使用`super` 关键字，修饰父类成员变量，类似于之前学过的 `this` 。

使用格式：

```java
super.父类成员变量名
```

子类方法需要修改，代码如下：

```java
class Zi extends Fu {
	// Zi中的成员变量
	int num = 6;
	public void show() {
		//访问父类中的num
		System.out.println("Fu num=" + super.num);
		//访问子类中的num
		System.out.println("Zi num=" + this.num);
	}
}
演示结果：
Fu num = 5
Zi num = 6
```

> 小贴士：Fu 类中的成员变量是非私有的，子类中可以直接访问。若Fu 类中的成员变量私有了，子类是不能直接访问的。通常编码时，我们遵循封装的原则，使用private修饰成员变量，那么如何访问父类的私有成员变量呢？对！可以在父类中提供公共的getXxx方法和setXxx方法。

#### 练习：代码分析

```java
class Father{
	int a = 10;
	int b = 11;
}
class Son extends Father{
	int a = 20;
	
	public void test(){
		//子类与父类的属性同名，子类对象中就有两个a
		System.out.println("父类的a：" + super.a);//10
		System.out.println("子类的a：" + this.a);//20
		System.out.println("子类的a：" + a);//20
		
		//子类与父类的属性不同名，是同一个b
		System.out.println("b = " + b);//11
		System.out.println("b = " + this.b);//11
		System.out.println("b = " + super.b);//11
	}
	
	public void method(int a){
		//子类与父类的属性同名，子类对象中就有两个成员变量a，此时方法中还有一个局部变量a
		System.out.println("父类的a：" + super.a);//10
		System.out.println("子类的a：" + this.a);//20
		System.out.println("局部变量的a：" + a);//30
	}
}
public class TestInherite2 {
	public static void main(String[] args) {
		Son son = new Son();
		System.out.println(son.a);//20
		
		son.test();
		
		son.method(30);
	}
}
```



### 6.7.4 继承的特点二：成员方法

当类之间产生了关系，其中各类中的成员方法，又产生了哪些影响呢？

#### 成员方法不重名

如果子类父类中出现**不重名**的成员方法，这时的调用是**没有影响的**。对象调用方法时，会先在子类中查找有没有对应的方法，若子类中存在就会执行子类中的方法，若子类中不存在就会执行父类中相应的方法。代码如下：

```java
class Fu{
	public void show(){
		System.out.println("Fu类中的show方法执行");
	}
}
class Zi extends Fu{
	public void show2(){
		System.out.println("Zi类中的show2方法执行");
	}
}
public  class ExtendsDemo04{
	public static void main(String[] args) {
		Zi z = new Zi();
     	//子类中没有show方法，但是可以找到父类方法去执行
		z.show(); 
		z.show2();
	}
}

```

#### 成员方法重名——重写(Override)

如果子类父类中出现**重名**的成员方法，这时的访问是一种特殊情况，叫做**方法重写** (Override)。

代码如下：

```java
class Fu {
	public void show() {
		System.out.println("Fu show");
	}
}
class Zi extends Fu {
	//子类重写了父类的show方法
	public void show() {
		System.out.println("Zi show");
	}
}
public class ExtendsDemo05{
	public static void main(String[] args) {
		Zi z = new Zi();
     	// 子类中有show方法，只执行重写后的show方法
		z.show();  // Zi show
	}
}
```

```
在父子类的继承关系当中，创建子类对象，访问成员方法的规则：
    创建的对象是谁，就优先用谁，如果没有则向上找。

注意事项：
无论是成员方法还是成员变量，如果没有都是向上找父类，绝对不会向下找子类的。

重写（Override）
概念：在继承关系当中，方法的名称一样，参数列表也一样。

重写（Override）：方法的名称一样，参数列表【也一样】。覆盖、覆写。
重载（Overload）：方法的名称一样，参数列表【不一样】。

方法的覆盖重写特点：创建的是子类对象，则优先用子类方法。

方法覆盖重写的注意事项：见下面
```

#### 重写的应用

子类可以根据需要，定义特定于自己的行为。既沿袭了父类的功能名称，又根据子类的需要重新实现父类方法，从而进行扩展增强。比如新的手机增加来电显示头像的功能，代码如下：

```java
class Phone {
	public void sendMessage(){
		System.out.println("发短信");
	}
	public void call(){
		System.out.println("打电话");
	}
	public void showNum(){
		System.out.println("来电显示号码");
	}
}

//智能手机类
class NewPhone extends Phone {
	
	//重写父类的来电显示号码功能，并增加自己的显示姓名和图片功能
	public void showNum(){
		//调用父类已经存在的功能使用super
		super.showNum();
		//增加自己特有显示姓名和图片功能
		System.out.println("显示来电姓名");
		System.out.println("显示头像");
	}
}

public class ExtendsDemo06 {
	public static void main(String[] args) {
      	// 创建子类对象
      	NewPhone np = new NewPhone()；
        
        // 调用父类继承而来的方法
        np.call();
      
      	// 调用子类重写的方法
      	np.showNum();

	}
}

```

> 小贴士：这里重写时，用到super.父类成员方法，表示调用父类的成员方法。

#### 注意事项

1. 必须保证父子类之间方法的名称相同，参数列表也相同。
    @Override：写在方法前面，用来检测是不是有效的正确覆盖重写。
    这个注解就算不写，只要满足要求，也是正确的方法覆盖重写。

2. 子类方法的返回值类型必须【小于等于】父类方法的返回值类型（小于其实就是是它的子类）。
    小扩展提示：java.lang.Object类是所有类的公共最高父类（祖宗类），java.lang.String就是Object的子类。

    > 注意：如果返回值类型是基本数据类型和void，那么必须是相同

3. 子类方法的权限必须【大于等于】父类方法的权限修饰符。
    小扩展提示：public > protected > 缺省 > private
    备注：缺省不是汉字缺省，而是什么都不写，留空。

4. 几种特殊的方法不能被重写

    * 静态方法不能被重写
    * 私有等在子类中不可见的方法不能被重写
    * final方法不能被重写

#### 练习

1、声明父类：Person类
包含属性：姓名，年龄，性别
属性私有化，get/set
包含getInfo()方法：例如：姓名：张三，年龄：23，性别：男

2、声明子类：Student类，继承Person类
新增属性：score成绩
属性私有化，get/set
包含getInfo()方法：例如：姓名：张三，年龄：23，性别：男，成绩：89

3、声明子类：Teacher类，继承Person类
新增属性：salary薪资
属性私有化，get/set
包含getInfo()方法：例如：姓名：张三，年龄：23，性别：男，薪资：10000

```java
public class Person {
	private String name;
	private int age;
	private char gender;
	public Person(String name, int age, char gender) {
		super();
		this.name = name;
		this.age = age;
		this.gender = gender;
	}
	public Person() {
		super();
	}
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
		this.age = age;
	}
	public char getGender() {
		return gender;
	}
	public void setGender(char gender) {
		this.gender = gender;
	}
	
	//包含getInfo()方法：例如：姓名：张三，年龄：23，性别：男
	public String getInfo(){
		return "姓名：" + name + "，年龄：" + age +"，性别：" + gender;
	}
}
```

```java
public class Student extends Person {
	private int score;

	public Student() {
	}

	public Student(String name, int age, char gender, int score) {
		setName(name);
		setAge(age);
		setGender(gender);
		this.score = score;
	}

	public int getScore() {
		return score;
	}

	public void setScore(int score) {
		this.score = score;
	}
	//包含getInfo()方法：例如：姓名：张三，年龄：23，性别：男，成绩：89
	public String getInfo(){
		//方式一：
//		return "姓名：" + getName() + "，年龄：" + getAge() + "，成绩：" + score;
		
		//方法二：
		return super.getInfo() + "，成绩：" + score;
	}
	
}
```

```java
public class Teacher extends Person {
	private double salary;

	public Teacher() {
	}

	public Teacher(String name, int age, char gender, double salary) {
		setName(name);
		setAge(age);
		setGender(gender);
		this.salary = salary;
	}

	public double getSalary() {
		return salary;
	}

	public void setSalary(double salary) {
		this.salary = salary;
	}
	
	//包含getInfo()方法：例如：姓名：张三，年龄：23，性别：男，薪资：10000
	public String getInfo(){
		return super.getInfo() + "，薪资：" + salary;
	}
}

```

```java
public class TestPersonExer2 {
	public static void main(String[] args) {
		Person p = new Person("张三", 23, '男');
		System.out.println(p.getInfo());
		
		Student s = new Student("陈琦", 25, '男', 89);
		System.out.println(s.getInfo());
		
		Teacher t = new Teacher("柴林燕", 18, '女', 11111);
		System.out.println(t.getInfo());
	}
}
```

### 6.7.5 继承的特点三：构造方法

当类之间产生了关系，其中各类中的构造方法，又产生了哪些影响呢？

首先我们要回忆两个事情，构造方法的定义格式和作用。

1. 构造方法的名字是与类名一致的。所以子类是**无法继承**父类构造方法的。
2. 构造方法的作用是初始化成员变量的。所以子类的初始化过程中，**必须**先执行父类的初始化动作。子类的构造方法中默认有一个`super()` ，表示调用父类的构造方法，父类成员变量初始化后，才可以给子类使用。代码如下：

```java
class Fu {
  private int n;
  Fu(){
    System.out.println("Fu()");
  }
}
class Zi extends Fu {
  Zi(){
    // super（），调用父类构造方法
    super();
    System.out.println("Zi（）");
  } 
}
public class ExtendsDemo07{
  public static void main (String args[]){
    Zi zi = new Zi();
  }
}
输出结果：
Fu（）
Zi（）
```

#### 如果父类没有无参构造怎么办？

例如：

```java
public class Person {
	private String name;
	private int age;
	public Person(String name, int age) {
		super();
		this.name = name;
		this.age = age;
	}
	//其他成员方法省略
}
```

```java
public class Student extends Person{
	private int score;
}
```

此时子类代码报错。

解决办法：在子类构造器中，用super(实参列表)，显示调用父类的有参构造解决。

```java
public class Student extends Person{
	private int score;

	public Student(String name, int age) {
		super(name, age);
	}
	public Student(String name, int age, int score) {
		super(name, age);
		this.score = score;
	}
	
	//其他成员方法省略
}
```

#### 练习

1、父类Graphic图形
包含属性：name（图形名），属性私有化，不提供无参构造，只提供有参构造
包含求面积getArea()：返回0.0
求周长getPerimeter()方法：返回0.0
显示信息getInfo()方法：返回图形名称、面积、周长

2、子类Circle圆继承Graphic图形
包含属性：radius
重写求面积getArea()和求周长getPerimeter()方法，显示信息getInfo()加半径信息

3、子类矩形Rectange继承Graphic图形
包含属性：length、width
重写求面积getArea()和求周长getPerimeter()方法，显示信息getInfo()加长宽信息

```java
public class Graphic {
	private String name;

	public Graphic(String name) {
		super();
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	// 包含求面积getArea()和求周长getPerimeter()方法，显示信息getInfo()
	public double getArea() {
		return 0.0;
	}

	public double getPerimeter() {
		return 0.0;
	}

	/*
	 * this对象：调用当前方法的对象，如果是Graphic对象，那么就会执行Graphic的getArea()和getPerimeter()
	 * this对象：调用当前方法的对象，如果是Circle对象，那么就会执行Circle的getArea()和getPerimeter()
	 * this对象：调用当前方法的对象，如果是Rectangle对象，那么就会执行Rectangle的getArea()和getPerimeter()
	 */
	public String getInfo() {
		return "图形：" + name + "，面积：" + getArea() + ",周长：" + getPerimeter();
	}
}
```

```java
public class Circle extends Graphic {
	private double radius;

	public Circle(String name, double radius) {
		super(name);
		this.radius = radius;
	}

	public double getRadius() {
		return radius;
	}

	public void setRadius(double radius) {
		this.radius = radius;
	}

	@Override//表示这个方法是重写的方法
	public double getArea() {
		return Math.PI * radius * radius;
	}

	@Override//表示这个方法是重写的方法
	public double getPerimeter() {
		return Math.PI * radius * 2;
	}

	/*@Override//表示这个方法是重写的方法
	public String getInfo() {
		return super.getInfo() + "，半径：" + radius;
	}*/
	
}

```

```java
public class Rectangle extends Graphic {
	private double length;
	private double width;
	
	public Rectangle(String name, double length, double width) {
		super(name);
		this.length = length;
		this.width = width;
	}

	public double getLength() {
		return length;
	}

	public void setLength(double length) {
		this.length = length;
	}

	public double getWidth() {
		return width;
	}

	public void setWidth(double width) {
		this.width = width;
	}

	@Override
	public double getArea() {
		return length*width;
	}

	@Override
	public double getPerimeter() {
		return 2*(length + width);
	}
	
}

```

```java
public class TestGraphicExer3 {
	public static void main(String[] args) {
		Graphic g = new Graphic("通用图形");
		System.out.println(g.getInfo());
		
		Circle c = new Circle("圆", 1.2);
		System.out.println(c.getInfo());//调用getInfo()方法的对象是c
		
		Rectangle r = new Rectangle("矩形", 3, 5);
		System.out.println(r.getInfo());
	}
}

```



### 6.7.6 继承的特点四：单继承限制

1. Java只支持单继承，不支持多继承。

```java
//一个类只能有一个父类，不可以有多个父类。
class C extends A{} 	//ok
class C extends A，B...	//error
```

2. Java支持多层继承(继承体系)。

```java
class A{}
class B extends A{}
class C extends B{}
```

> 顶层父类是Object类。所有的类默认继承Object，作为父类。

3. 子类和父类是一种相对的概念。
4. 一个父类可以同时拥有多个子类

## 6.8 super

### 父类空间优先于子类对象产生

在每次创建子类对象时，先初始化父类空间，再创建其子类对象本身。目的在于子类对象中包含了其对应的父类空间，便可以包含其父类的成员，如果父类成员非private修饰，则子类可以随意使用父类成员。代码体现在子类的构造方法调用时，一定先调用父类的构造方法。

```java
public class Person {
	private String name;
	private int age;
	//其他代码省略
}
public class Student extends Person{
	private int score;
	//其他成员方法省略
}
public class Test{
    public static void main(String[] args){
    	Student stu = new Student();
    }
}
```

![1561984785190](img/1561984785190.png)

### super和this的含义

* **super** ：代表父类的**存储空间标识**(可以理解为父亲的引用)。
  * 通过super找成员变量和成员方法时，直接从父类空间（包含父类的父类继承的）找
  * super()或super(实参列表)只能从直接父类找
  * 通过super只能访问父类在子类中可见的（非private，跨包还不能是缺省的）


* **this** ：代表**当前对象的引用**。

  * 通过this找成员变量和成员方法时，先从当前类中找，没有的会往上找父类的。
  * 但是this()或this(实参列表)只会在本类中找

> 注意：super和this都不能出现在静态方法和静态代码块中，因为super和this都是存在与**对象**中的

### super的用法

#### 1、super.成员变量

在子类对象中访问父类空间的成员变量，即访问从父类继承的在子类中仍然可见的成员变量

（1）子类没有与父类重名的成员变量

```java
public class Test{
    public static void main(String[] args){
    	Son s = new Son();
    	s.test();
    }
}
class Father{
	int a = 10;
}
class Son extends Father{
	public void test(){
		System.out.println(super.a);//10
		System.out.println(this.a);//10
		System.out.println(a);//10
	}
}
```

（2）子类有与父类重名的成员变量

```java
public class Test{
    public static void main(String[] args){
    	Son s = new Son();
    	s.test();
    }
}
class Father{
	int a = 10;
}
class Son extends Father{
	int a = 20;
	public void test(){
		System.out.println(super.a);//10
		System.out.println(this.a);//20
		System.out.println(a);//20
	}
}
```

（3）方法有局部变量与成员变量重名

```java
public class Test{
    public static void main(String[] args){
    	Son s = new Son();
    	s.test(30);
    }
}
class Father{
	int a = 10;
}
class Son extends Father{
	int a = 20;
	public void test(int a){
		System.out.println(super.a);//10
		System.out.println(this.a);//20
		System.out.println(a);//30
	}
}
```

#### 2、super.成员方法

在子类对象中访问从父类继承的在子类中仍然可见的成员方法

（1）子类没有重写方法

```java
public class Test{
    public static void main(String[] args){
    	Son s = new Son();
    	s.test();
    }
}
class Father{
	public void method(){
		System.out.println("aa");
	}
}
class Son extends Father{
	public void test(){
		method();//aa
		this.method();//aa
		super.method();//aa
	}
}
```

（2）子类重写父类的方法

```java
public class Test{
    public static void main(String[] args){
    	Son s = new Son();
    	s.test();
    }
}
class Father{
	public void method(){
		System.out.println("aa");
	}
}
class Son extends Father{
	public void method(){
		System.out.println("bb");
	}
	public void test(){
		method();//bb
		this.method();//bb
		super.method();//aa
	}
}
```

#### 3、super()或super(实参列表)

```java
this(...)    	--    本类的构造方法
super(...)   	--    父类的构造方法
```

> 子类的每个构造方法中均有默认的super()，调用父类的空参构造。手动调用父类构造会覆盖默认的super()。
>
> super() 和 this() 都必须是在构造方法的第一行，所以不能同时出现。

## 6.9 final

final：最终的，不可更改的，它的用法有：

### 1、修饰类

表示这个类不能被继承，没有子类

```java
final class Eunuch{//太监类
	
}
class Son extends Eunuch{//错误
	
}
```

### 2、修饰方法

表示这个方法不能被子类重写

```java
class Father{
	public final void method(){
		System.out.println("father");
	}
}
class Son extends Father{
	public void method(){//错误
		System.out.println("son");
	}
}
```

### 3、声明常量

某个变量如果使用final修饰，那么它的值就不能被修改，即常量

> final可以修饰成员变量（静态的类变量和非静态的实例变量）和局部变量
>
> 如果某个成员变量用final修饰后，没有set方法，并且必须有显式赋值语句，不能使用成员变量默认值
>
> 被final修饰的常量名称，一般都有书写规范，所有字母都**大写**。

```java
public class Test{
    public static void main(String[] args){
    	final int MIN_SCORE = 0;
    	final int MAX_SCORE = 100;
    }
}
class Chinese{
	public static final String COUNTRY = "中华人民共和国";	
	private final String BLOODTYPE = "A";//显示赋值
    private final String CARDID;//如果没有显示赋值，必须保证在
	private String name;
	public Chinese(String cardId, String name) {
		super();
		this.CARDID = cardId;
		this.name = name;
	}
	public Chinese() {
		super();
		CARDID = "000000000000000000";//必须在所有构造器中进行赋值
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	//final修饰的没有set方法
	public static String getCountry() {
		return COUNTRY;
	}
	public String getCardId() {
		return cardId;
	}
	public String getBloodType() {
		return bloodType;
	}
}
```



## 6.10 类初始化

### 6.10.1 静态代码块

语法格式：

```java
【修饰符】 class 类名{
    static{
        静态代码块语句;
    }
}
```

> 位置：在类中方法外，一个类可以有多个（一般只写一个）

作用：完成类初始化

### 6.10.2 类初始化

类被加载内存后，会在方法区创建一个Class对象（后面反射章节详细学习）来存储该类的所有信息。此时会为类的静态变量分配内存，然后为类变量进行初始化。那么，实际上，类初始化的过程时在调用一个<clinit>()方法，而这个方法是编译器自动生成的。编译器会将如下两部分的**所有**代码，**按顺序**合并到类初始化<clinit>()方法体中。

（1）静态类成员变量的显式赋值语句

（2）静态代码块中的语句

整个类初始化只会进行一次，如果子类初始化时，发现父类没有初始化，那么会先初始化父类。

#### 示例代码1：单个类

```java
public class Test{
    public static void main(String[] args){
    	Father.test();
    }
}
class Father{
	private static int a = getNumber();
	static{
		System.out.println("Father(1)");
	}
	private static int b = getNumber();
	static{
		System.out.println("Father(2)");
	}
	
	public static int getNumber(){
		System.out.println("getNumber()");
		return 1;
	}
	
	public static void test(){
		System.out.println("Father:test()");
	}
}
```

```java
运行结果：
getNumber()
Father(1)
getNumber()
Father(2)
Father:test()
```

![1562070829002](img/1562070829002.png)

#### 示例代码2：父子类

```java
public class Test{
    public static void main(String[] args){
    	Son.test();
        System.out.println("-----------------------------");
        Son.test();
    }
}
class Father{
	private static int a = getNumber();
	static{
		System.out.println("Father(1)");
	}
	private static int b = getNumber();
	static{
		System.out.println("Father(2)");
	}
	
	public static int getNumber(){
		System.out.println("Father:getNumber()");
		return 1;
	}
}
class Son extends Father{
	private static int a = getNumber();
	static{
		System.out.println("Son(1)");
	}
	private static int b = getNumber();
	static{
		System.out.println("Son(2)");
	}
	
	public static int getNumber(){
		System.out.println("Son:getNumber()");
		return 1;
	}
	
	public static void test(){
		System.out.println("Son:test()");
	}	
}
```

```java
运行结果：
Father:getNumber()
Father(1)
Father:getNumber()
Father(2)
Son:getNumber()
Son(1)
Son:getNumber()
Son(2)
Son:test()
-----------------------------
Son:test()
```

结论：

每一个类都有一个类初始化方法<clinit>()方法，然后子类初始化时，如果发现父类加载和没有初始化，会先加载和初始化父类，然后再加载和初始化子类。一个类，只会初始化一次。



## 6.11 实例初始化

### 6.11.1 非静态代码块

语法格式：

```java
【修饰符】 class 类名{
    {
        非静态代码块语句;
    }
}
```

> 在类中方法外，一个类中可以出现多个

作用：完成实例初始化

### 6.11.2 实例初始化

实际上我们编写的代码在编译时，会自动处理代码，整理出一个<clinit>()的类初始化方法，还会整理出一个或多个的<init>(...)实例初始化方法。一个类有几个实例初始化方法，由这个类有几个构造器决定。

实例初始化方法的方法体，由四部分构成：

（1）super()或super(实参列表)    这里选择哪个，看原来构造器首行是哪句，没写，默认就是super()

（2）非静态实例变量的显示赋值语句

（3）非静态代码块

（4）对应构造器中的代码

特别说明：其中（2）和（3）是按顺序合并的，（1）一定在最前面（4）一定在最后面

执行特点：

* 创建对象时，才会执行，
* 调用哪个构造器，就是指定它对应的实例初始化方法
* 创建子类对象时，父类对应的实例初始化会被先执行，执行父类哪个实例初始化方法，看用super()还是super(实参列表)

#### 示例代码1：单个类

```java
public class Test{
    public static void main(String[] args){
    	Father f1 = new Father();
    	Father f2 = new Father("atguigu");
    }
}
class Father{
	private int a = getNumber();
	private String info;
	{
		System.out.println("Father(1)");
	}
	Father(){
		System.out.println("Father()无参构造");
	}
	Father(String info){
		this.info = info;
		System.out.println("Father(info)有参构造");
	}
	private int b = getNumber();
	{
		System.out.println("Father(2)");
	}
	
	public int getNumber(){
		System.out.println("Father:getNumber()");
		return 1;
	}
}
```

```java
运行结果：
Father:getNumber()
Father(1)
Father:getNumber()
Father(2)
Father()无参构造
Father:getNumber()
Father(1)
Father:getNumber()
Father(2)
Father(info)有参构造
```

![1562072678317](img/1562072678317.png)

#### 示例代码2：父子类

```java
public class Test{
    public static void main(String[] args){
    	Son s1 = new Son();
        System.out.println("-----------------------------");
    	Son s2 = new Son("atguigu");
    }
}
class Father{
	private int a = getNumber();
	private String info;
	{
		System.out.println("Father(1)");
	}
	Father(){
		System.out.println("Father()无参构造");
	}
	Father(String info){
		this.info = info;
		System.out.println("Father(info)有参构造");
	}
	private int b = getNumber();
	{
		System.out.println("Father(2)");
	}
	
	public static int getNumber(){
		System.out.println("Father:getNumber()");
		return 1;
	}
}
class Son extends Father{
	private int a = getNumber();
	{
		System.out.println("Son(1)");
	}
	private int b = getNumber();
	{
		System.out.println("Son(2)");
	}
	public Son(){
		System.out.println("Son()：无参构造");
	}
	public Son(String info){
		super(info);
		System.out.println("Son(info)：有参构造");
	}
	public static int getNumber(){
		System.out.println("Son:getNumber()");
		return 1;
	}
}
```

```java
运行结果：
Father:getNumber()
Father(1)
Father:getNumber()
Father(2)
Father()无参构造
Son:getNumber()
Son(1)
Son:getNumber()
Son(2)
Son()：无参构造
-----------------------------
Father:getNumber()
Father(1)
Father:getNumber()
Father(2)
Father(info)有参构造
Son:getNumber()
Son(1)
Son:getNumber()
Son(2)
Son(info)：有参构造
```

#### 示例代码3：父子类，方法有重写

```java
public class Test{
    public static void main(String[] args){
    	Son s1 = new Son();
    	System.out.println("-----------------------------");
    	Son s2 = new Son("atguigu");
    }
}
class Father{
	private int a = getNumber();
	private String info;
	{
		System.out.println("Father(1)");
	}
	Father(){
		System.out.println("Father()无参构造");
	}
	Father(String info){
		this.info = info;
		System.out.println("Father(info)有参构造");
	}
	private int b = getNumber();
	{
		System.out.println("Father(2)");
	}
	
	public int getNumber(){
		System.out.println("Father:getNumber()");
		return 1;
	}
}
class Son extends Father{
	private int a = getNumber();
	{
		System.out.println("Son(1)");
	}
	private int b = getNumber();
	{
		System.out.println("Son(2)");
	}
	public Son(){
		System.out.println("Son()：无参构造");
	}
	public Son(String info){
		super(info);
		System.out.println("Son(info)：有参构造");
	}
	public int getNumber(){
		System.out.println("Son:getNumber()");
		return 1;
	}
}
```

```java
运行结果：
Son:getNumber()  //子类重写getNumber()方法，那么创建子类的对象，就是调用子类的getNumber()方法，因为当前对象this是子类的对象。
Father(1)
Son:getNumber()
Father(2)
Father()无参构造
Son:getNumber()
Son(1)
Son:getNumber()
Son(2)
Son()：无参构造
-----------------------------
Son:getNumber()
Father(1)
Son:getNumber()
Father(2)
Father(info)有参构造
Son:getNumber()
Son(1)
Son:getNumber()
Son(2)
Son(info)：有参构造
```

#### 示例代码4：类初始化与实例初始化

```java
public class Test{
    public static void main(String[] args){
    	Son s1 = new Son();
    	System.out.println("----------------------------");
    	Son s2 = new Son();
    }
}
class Father{
	static{
		System.out.println("Father:static");
	}
	{
		System.out.println("Father:not_static");
	}
	Father(){
		System.out.println("Father()无参构造");
	}
}
class Son extends Father{
	static{
		System.out.println("Son:static");
	}
	{
		System.out.println("Son:not_static");
	}
	Son(){
		System.out.println("Son()无参构造");
	}
}
```

```java
运行结果：
Father:static
Son:static
Father:not_static
Father()无参构造
Son:not_static
Son()无参构造
----------------------------
Father:not_static
Father()无参构造
Son:not_static
Son()无参构造
```

结论：

类初始化肯定优先于实例初始化。

类初始化只做一次。

实例初始化是每次创建对象都要进行。

#### 构造器和非静态代码块

从某种程度上来看，非静态代码块是对构造器的补充，非静态代码块总是在构造器执行之前执行。与构造器不同的是，非静态代码块是一段固定执行的代码，它不能接收任何参数。因此非静态代码块对同一个类的所有对象所进行的初始化处理完全相同。基于这个原因，不难发现非静态代码块的基本用法，如果有一段初始化处理代码对所有对象完全相同，且无须接收任何参数，就可以把这段初始化处理代码提取到非静态代码块中。

即如果每个构造器中有相同的初始化代码，且这些初始化代码无须接收参数，就可以把它们放在非静态代码块中定义。通过把多个构造器中相同代码提取到非静态代码块中定义，能更好地提高初始代码的复用，提高整个应用的可维护性。

## 6.12  就近原则/this/super：解决复杂问题

（1）当方法中访问变量时，如果没有this.，super.，那么都是遵循就近原则，找最近声明的。

示例代码一：

```java
public class Test{
    public static void main(String[] args){
    	Son s = new Son();
    	System.out.println(s.getNum());//10
    	
    	Daughter d = new Daughter();
    	System.out.println(d.getNum());//20
    }
}
class Father{
	protected int num = 10;
	public int getNum(){
		return num;
	}
}
class Son extends Father{
	private int num = 20;
}
class Daughter extends Father{
	private int num = 20;
	public int getNum(){
		return num;
	}
}
```

（2）找方法时

没有加this.和super.的，默认就是加了this.的。

如果加了this.，先从当前对象的类中找，如果没有自动从父类中查找。

如果加了super.，直接从父类开始找。

```java
public class Test{
    public static void main(String[] args){
    	Son s = new Son();
    	s.test();
    	
    	Daughter d = new Daughter();
    	d.test();
    }
}
class Father{
	protected int num = 10;
	public int getNum(){
		return num;
	}
	
}
class Son extends Father{
	private int num = 20;
	public void test(){
		System.out.println(getNum());//10
		System.out.println(this.getNum());//10
		System.out.println(super.getNum());//10
	}
}
class Daughter extends Father{
	private int num = 20;
	public int getNum(){
		return num;
	}
	public void test(){
		System.out.println(getNum());//20
		System.out.println(this.getNum());//20
		System.out.println(super.getNum());//10
	}
}
```

