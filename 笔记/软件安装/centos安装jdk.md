[TOC]

# 一、安装jdk

## 1、下载

```shell
进入oracle官网,同意下载后复制链接
或者下载到本地后上传到服务器 /opt/software/ 目录
```

```shell
wget -O /opt/software/jdk-8u281.tar.gz https://download.oracle.com/otn/java/jdk/8u281-b09/89d678f2be164786b292527658ca1605/jdk-8u281-linux-x64.tar.gz?AuthParam=1617534403_8d10ab09b6800b16d1375d853614a9a5
```

  [oracle jdk 下载](https://www.oracle.com/java/technologies/javase-downloads.html)  

## 2、解压
```shell
cd /opt/software
```

```shell
mkdir -p /opt/module/java
```

```shell
tar -zxvf jdk-8u131-linux-x64.tar.gz -C /opt/module/java
```

## 3、配置环境变量

```shell
vim /etc/profile.d/java.sh
```

添加以下内容:

    export JAVA_HOME=/opt/module/java/jdk1.8.0_131
    export JRE_HOME=$JAVA_HOME/jre
    export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
    export PATH=$JAVA_HOME/bin:$PATH
重新加载

```shell
source /etc/profile
```

测试

```shell
java -version
```

