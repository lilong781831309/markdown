[TOC]

## 1、FileInputStream、FileOutputStream

``` java
    public static String fileInputStream(File file) {
        StringBuilder sb = new StringBuilder();
        FileInputStream fis = null;
        byte[] buf = new byte[1024];
        int n = -1;
        try {
            fis = new FileInputStream(file);
            while ((n = fis.read(buf)) > 0) {
                sb.append(new String(buf, 0, n));
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }finally{
            if(fis!=null){
                try {
                    fis.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return sb.toString();
    }
```
```java
    public static void fileOutputStream(File file) {
        FileOutputStream fos = null;
        try {
            String str = "test fileOutputStream";
            fos = new FileOutputStream(file);
            fos.write(str.getBytes());
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (fos != null) {
                try {
                    fos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
```
***
## 2、BufferedInputStream、BufferedOutputStream
``` java
    public static String bufferedInputStream(File file) {
        StringBuilder sb = new StringBuilder();
        BufferedInputStream bis = null;
        byte[] buf = new byte[1024];
        int n = -1;
        try {
            bis = new BufferedInputStream(new FileInputStream(file));
            while ((n = bis.read(buf)) > 0) {
                sb.append(new String(buf, 0, n));
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (bis != null) {
                try {
                    bis.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return sb.toString();
    }
```
```java
    public static void bufferedOutputStream(File file) {
        BufferedOutputStream bos = null;
        try {
            String str = "test bufferedOutputStream";
            bos = new BufferedOutputStream(new FileOutputStream(file));
            bos.write(str.getBytes());
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (bos != null) {
                try {
                    bos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
```
***
## 3、DataInputStream、DataOutputStream
```java
    public static void dataInputStream(File file) {
        DataInputStream dis = null;
        try {
            dis = new DataInputStream(new FileInputStream(file));
            System.out.println("readBoolean: " + dis.readBoolean());
            System.out.println("readByte: " + dis.readByte());
            System.out.println("readChar: " + dis.readChar());
            System.out.println("readShort: " + dis.readShort());
            System.out.println("readInt: " + dis.readInt());
            System.out.println("readLong: " + dis.readLong());
            System.out.println("readFloat: " + dis.readFloat());
            System.out.println("readDouble: " + dis.readDouble());
            System.out.println("readUTF: " + dis.readUTF());
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (dis != null) {
                try {
                    dis.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
```
```java
    public static void dataOutputStream(File file) {
        DataOutputStream dos = null;
        try {
            dos = new DataOutputStream(new FileOutputStream(file));
            dos.writeBoolean(true);
            dos.writeByte(1);
            dos.writeChar('a');
            dos.writeShort(2);
            dos.writeInt(3);
            dos.writeLong(4);
            dos.writeFloat(5.123F);
            dos.writeDouble(6.01234);
            dos.writeUTF("test");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (dos != null) {
                try {
                    dos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
```
***
## 4、ObjectInputStream、ObjectOutputStream
```java
    public static void objectInputStream(File file) {
        ObjectInputStream ois = null;
        try {
            ois = new ObjectInputStream(new FileInputStream(file));
            System.out.println("readBoolean: " + ois.readBoolean());
            System.out.println("readByte: " + ois.readByte());
            System.out.println("readChar: " + ois.readChar());
            System.out.println("readShort: " + ois.readShort());
            System.out.println("readInt: " + ois.readInt());
            System.out.println("readLong: " + ois.readLong());
            System.out.println("readFloat: " + ois.readFloat());
            System.out.println("readDouble: " + ois.readDouble());
            System.out.println("readUTF: " + ois.readUTF());
            System.out.println("readObject: " + ((Person) ois.readObject()));
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            if (ois != null) {
                try {
                    ois.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    public static void objectOutputStream(File file) {
        ObjectOutputStream oos = null;
        try {
            oos = new ObjectOutputStream(new FileOutputStream(file));
            oos.writeBoolean(true);
            oos.writeByte(1);
            oos.writeChar('a');
            oos.writeShort(2);
            oos.writeInt(3);
            oos.writeLong(4);
            oos.writeFloat(5.123F);
            oos.writeDouble(6.01234);
            oos.writeUTF("test");
            oos.writeObject(new Person("张三", 20));
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (oos != null) {
                try {
                    oos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    class Person implements Serializable {
        private String name;
        private int age;
    
        public Person() {
        }
    
        public Person(String name, int age) {
            this.name = name;
            this.age = age;
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
    
        @Override
        public String toString() {
            return "Person{" +
                    "name='" + name + '\'' +
                    ", age=" + age +
                    '}';
        }
    }
```
***
## 5、PushbackInputStream、PushbackReader
```java
    public static void pushbackInputStream() {
        String data = "This an example of PushbackInputStream";
        ByteArrayInputStream byteArrayInputStream = null;
        PushbackInputStream pushbackInputStream = null;
        try {
            byteArrayInputStream = new ByteArrayInputStream(data.getBytes());
            pushbackInputStream = new PushbackInputStream(byteArrayInputStream);

            //Read first character from stream
            int i = pushbackInputStream.read();
            System.out.println((char) i);

            //Push back first character to stream
            pushbackInputStream.unread(i);

            //Now Read full bytes
            byte b[] = new byte[data.getBytes().length];
            pushbackInputStream.read(b);
            System.out.println(new String(b));
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (pushbackInputStream != null) {
                    pushbackInputStream.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
```
```java
    T
    This an example of PushbackInputStream
```
```java
    public static void pushbackReader() {
        String data = "示例 pushbackReade";
        CharArrayReader charArrayReader = null;
        PushbackReader pushbackReader = null;
        try {
            charArrayReader = new CharArrayReader(data.toCharArray());
            pushbackReader = new PushbackReader(charArrayReader);

            int i = pushbackReader.read();
            System.out.println((char) i);

            pushbackReader.unread(i);

            char[] chs = new char[data.toCharArray().length];
            pushbackReader.read(chs);
            System.out.println(new String(chs));
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (charArrayReader != null) {
                charArrayReader.close();
            }
            try {
                if (pushbackReader != null) {
                    pushbackReader.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
```
```
    示
    示例 pushbackReader
```
***
## 6、PipedInputStream、PipedOutputStream
```java
    public static void main(String[] args) throws IOException {
        PipedInputStream pis = new PipedInputStream();
        PipedOutputStream pos = new PipedOutputStream();
        pis.connect(pos);
        new Thread(new Reciver(pis)).start();
        new Thread(new Sender(pos)).start();
    }
    
    class Sender implements Runnable {
        PipedOutputStream pos;
    
        public Sender(PipedOutputStream pos) {
            this.pos = pos;
        }
    
        @Override
        public void run() {
            try {
                for (int i = 0; i < 10; i++) {
                    Thread.sleep(500);
                    pos.write(("Message " + i + "\r\n").getBytes());
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                if (pos != null) {
                    try {
                        pos.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
    
        }
    }
    
    class Reciver implements Runnable {
        PipedInputStream pis;
    
        public Reciver(PipedInputStream pis) {
            this.pis = pis;
        }
    
        @Override
        public void run() {
            try {
                byte[] buff = new byte[64];
                int read;
                while ((read = pis.read(buff)) != -1) {
                    System.out.print(new String(buff, 0, read));
                }
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                if (pis != null) {
                    try {
                        pis.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }
```
***
## 7、SequenceInputStream
```java
    public static void sequenceInputStream(File srcFile1, File srcFile2, File targetFile) {
        SequenceInputStream sis = null;
        FileOutputStream fos = null;

        try {
            InputStream is1 = new FileInputStream(srcFile1);
            InputStream is2 = new FileInputStream(srcFile2);
            fos = new FileOutputStream(targetFile);
            sis = new SequenceInputStream(is1, is2);

            int c = 0;
            while ((c = sis.read()) != -1) {
                fos.write(c);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (sis != null) {
                    sis.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            try {
                if (fos != null) {
                    fos.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

```
***
## 8、ByteArrayInputStream、ByteArrayOutputStream
```java
    public static void byteArrayInputStream() {
        byte[] buf = {1, 2, 3, 'a', 'b', 'c'};
        ByteArrayInputStream bais = new ByteArrayInputStream(buf);
        int val = 0;
        System.out.println("====int value===");
        while ((val = bais.read()) != -1) {
            System.out.println(val);
        }
    }
```
```
    ====int value===
    1
    2
    3
    97
    98
    99
```
```java
    public static void byteArrayOutputStream() {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        baos.write(1);
        baos.write(2);
        baos.write(3);
        baos.write('a');
        baos.write('b');
        baos.write('c');
        byte[] buf = baos.toByteArray();
        System.out.println("====int value===");
        for (int i = 0; i < buf.length; i++) {
            System.out.println(buf[i]);
        }
    }
```
```
    ====int value===
    1
    2
    3
    97
    98
    99
```
***
## 9、FileReader、FileWriter
```java
    public static void fileReader(File file) {
        // 使用文件名称创建流对象
        FileReader fr = null;
        try {
            fr = new FileReader(file);
            int c = 0;
            while ((c = fr.read()) != -1) {
                System.out.println((char) c);
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (fr != null) {
                try {
                    fr.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
```
```
    测
    试
    a
    b
    c
```
```java
    public static void fileWriter(File file) {
        FileWriter fw = null;
        try {
            fw = new FileWriter(file);
            fw.write('你');
            fw.write('好');
            fw.write("朋友们");
            fw.write(97);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (fw != null) {
                try {
                    fw.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
```
```
    你好朋友们a
```
***
## 10、BufferedReader、BufferedWriter
```java
    public static void bufferedReader(File file) {
        // 使用文件名称创建流对象
        BufferedReader br = null;
        try {
            br = new BufferedReader(new FileReader(file));
            String line = null;
            while ((line = br.readLine()) != null) {
                System.out.println(line);
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
```
```
    第一行
    第二行
    第三行
```
```java
    public static void bufferedWriter(File file) {
        BufferedWriter bw = null;
        try {
            bw = new BufferedWriter(new FileWriter(file));
            bw.write("第一行");
            bw.newLine();
            bw.write("第二行");
            bw.newLine();
            bw.write("第三行");
            bw.newLine();
            bw.flush();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (bw != null) {
                try {
                    bw.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
```
***
## 11、InputStreamReader、OutputStreamWriter
```java
    public static void inputStreamReader() {
        InputStreamReader isr = null;
        InputStreamReader isr2 = null;
        try {
            // 定义文件路径,文件为gbk编码
            String FileName = "E:\\file_gbk.txt";

            // 创建流对象,默认UTF8编码
            isr = new InputStreamReader(new FileInputStream(FileName));
            // 创建流对象,指定GBK编码
            isr2 = new InputStreamReader(new FileInputStream(FileName), "GBK");
            // 定义变量,保存字符
            int read;
            // 使用默认编码字符流读取,乱码
            while ((read = isr.read()) != -1) {
                System.out.print((char) read); // ��Һ�
            }

            // 使用指定编码字符流读取,正常解析
            while ((read = isr2.read()) != -1) {
                System.out.print((char) read);// 大家好
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (isr != null) {
                    isr.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            try {
                if (isr2 != null) {
                    isr2.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
```
```java
    public static void outputStreamWriter() {
        OutputStreamWriter osw = null;
        OutputStreamWriter osw2 = null;
        try {
            // 定义文件路径
            String FileName = "E:\\out.txt";
            // 创建流对象,默认UTF8编码
            osw = new OutputStreamWriter(new FileOutputStream(FileName));
            // 写出数据
            osw.write("你好"); // 保存为6个字节
            osw.close();

            // 定义文件路径
            String FileName2 = "E:\\out2.txt";
            // 创建流对象,指定GBK编码
            osw2 = new OutputStreamWriter(new FileOutputStream(FileName2), "GBK");
            // 写出数据
            osw2.write("你好");// 保存为4个字节
            osw2.close();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (osw != null) {
                    osw.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
```
***
## 12、StringReader、StringWriter
### 12.1、StringReader
`使用情景:`
> `必须使用一个Reader来作为参数传递时，但你的数据源又仅仅是一个String类型数据`
```java
StringReader sr = new StringReader("just a test~")
```

### 12.2、StringWriter
`使用场景一：必须使用一个Writer来作为参数传递时`
```java
    public static void stringWriter() {
        StringWriter sw = new StringWriter();
        sw.write(1);
        sw.write("str");
        fn(sw);
    }

    public static void fn(Writer writer) {

    }
```
`使用场景二：将堆栈跟踪转换为 String`
```java
    public static void stringWriter() {
        try {
            int a = 1 / 0;
        } catch (Exception e) {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw); 
            e.printStackTrace(pw);
            String s = sw.toString(); //我们现在可以将堆栈跟踪作为字符串
        }
    }
```
***
## 13、PipedReader、PipedWriter
```java
    public static void main(String[] args) throws IOException {
        PipedReader pr = new PipedReader();
        PipedWriter pw = new PipedWriter();
        pr.connect(pw);
        new Thread(new Reciver(pr)).start();
        new Thread(new Sender(pw)).start();
    }

    class Sender implements Runnable {
        PipedWriter pw;
    
        public Sender(PipedWriter pw) {
            this.pw = pw;
        }
    
        @Override
        public void run() {
            try {
                for (int i = 0; i < 10; i++) {
                    Thread.sleep(500);
                    pw.write("Message " + i + "\r\n");
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                if (pw != null) {
                    try {
                        pw.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
    
        }
    }
    
    class Reciver implements Runnable {
        PipedReader pr;
    
        public Reciver(PipedReader pr) {
            this.pr = pr;
        }
    
        @Override
        public void run() {
            try {
                char[] buff = new char[1024];
                int read;
                while ((read = pr.read(buff)) != -1) {
                    System.out.print(new String(buff, 0, read));
                }
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                if (pr != null) {
                    try {
                        pr.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }
```
[参考一](https://blog.csdn.net/fxkcsdn/article/details/86562043)

***
## 14、CharArrayReader、CharArrayWriter
```java
    public static void charArrayReader() {
        // 使用文件名称创建流对象
        CharArrayReader car = null;
        try {
            char[] chs = {'你', '好', ',', 'h', 'e', 'l', 'l', 'o'};
            car = new CharArrayReader(chs);
            int val = 0;
            System.out.println("====char value===");
            while ((val = car.read()) != -1) {
                System.out.println((char) val);
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (car != null) {
                car.close();
            }
        }
    }
```
```
    你
    好
    ,
    h
    e
    l
    l
    o
```
```java
    public static void charArrayWriter() {
        CharArrayWriter caw = new CharArrayWriter();
        caw.write('a');
        caw.write('b');
        caw.write('c');
        caw.write('d');
        caw.write('e');
        char[] chs = caw.toCharArray();

        System.out.println("====char value===");
        for (int i = 0; i < chs.length; i++) {
            System.out.println((char) chs[i]);
        }
    }
```
***
## 15、PrintStream、PrintWriter
```java
    public static void main(String[] args) throws IOException {
        PrintStream ps = new PrintStream(new FileOutputStream("C:\\ps.txt"));
        System.setOut(ps);
        System.out.println("abc");
        System.out.println("def");
    }
    
    public static void main(String[] args) throws IOException {
        PrintWriter pw = new PrintWriter(new BufferedWriter(new OutputStreamWriter(new FileOutputStream("C:\\pw.txt"))), true);
        pw.println("abc");
        pw.println("def");
        pw.close();
    }
```
***

## 16、RandomAccessFile
```java
    public static final int KB = 1024;
    public static final int MB = KB * KB;

    public static void main(String[] args) {
        File file = new File("");

        long length = file.length();
        int pieceSize = MB;
        int pieceCount = (int) (length % pieceSize == 0 ? (length / pieceSize) : (length / pieceSize + 1));

        for (int i = 0; i < pieceCount; i++) {
            new Thread(new Runnable() {
                @Override
                public void run() {
                    RandomAccessFile raf = null;
                    try {
                        byte[] buff = new byte[pieceSize];
                        raf = new RandomAccessFile(file, "1");
                        raf.seek(pieceCount * pieceSize);
                        int read = raf.read(buff);
                        //do samething
                    } catch (FileNotFoundException e) {
                        e.printStackTrace();
                    } catch (IOException e) {
                        e.printStackTrace();
                    } finally {
                        if (raf != null) {
                            try {
                                raf.close();
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        }
                    }

                }
            }).start();
        }
    }
```
***

## 17、try-with-resource
语法格式：

```java
    try(需要关闭的资源对象的声明){
        业务逻辑代码
    }catch(异常类型 e){
        处理异常代码
    }catch(异常类型 e){
        处理异常代码
    }
    ....
```
示例代码：

```java
	public void test() {
		try(
			FileInputStream fis = new FileInputStream("d:/1.txt");
			InputStreamReader isr = new InputStreamReader(fis,"GBK");
			BufferedReader br = new BufferedReader(isr);
			
			FileOutputStream fos = new FileOutputStream("1.txt");
			OutputStreamWriter osw = new OutputStreamWriter(fos,"UTF-8");
			BufferedWriter bw = new BufferedWriter(osw);
		){
			String str;
			while((str = br.readLine()) != null){
				bw.write(str);
				bw.newLine();
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
```