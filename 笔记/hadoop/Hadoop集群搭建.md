[TOC]

# 一、hadoop安装

# 1、集群部署规划

IP | 172.17.0.10 | 172.17.0.14 | 172.17.0.16
---|---|---|---
HOST | hadoop10| hadoop14 | hadoop16
HDFS | DataNode、NameNode| DataNode| DataNode、SecondaryNameNode
YARN | NodeManager | NodeManager、ResourceManager | NodeManager

# 2、配置sudo

分别在 hadoop10、hadoop14、hadoop16 上配置

```shell
echo "lilong ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/lilong
```

```shell
source /etc/sudoers
```

# 3、安装依赖

分别在 hadoop10、hadoop14、hadoop16 上执行

```shell
yum install -y epel-release psmisc nc net-tools rsync vim lrzsz ntp libzstd openssl-static tree iotop git
```

# 4、配置host

hadoop10上执行

```shell
echo "hadoop10" > /etc/hostname
```

hadoop14上执行

```shell
echo "hadoop14" >> /etc/hostname
```

hadoop16上执行

```shell
echo "hadoop16" >> /etc/hostname
```

分别在 hadoop10、hadoop14、hadoop16 上执行

```shell
vim /etc/hosts
```

添加以下内容:

```shell
172.17.0.10 hadoop10
172.17.0.14 hadoop14
172.17.0.16 hadoop16
```

之后全部重启

# 5、配置免密登录

分别在 hadoop10、hadoop14、hadoop16 上执行

```shell
su - lilong
```

```shell
ssh-keygen -t rsa
```

```shell
ssh-copy-id hadoop10
```

```shell
ssh-copy-id hadoop14
```

```shell
ssh-copy-id hadoop16
```

# 6、准备安装目录

准备资源包目录

```shell
mkdir /opt/software
```

准备源码目录

```shell
mkdir /opt/src
```

准备安装目录

```shell
mkdir /opt/module
```

```shell
chown -R lilong:lilong /opt/software
```

```shell
chown -R lilong:lilong /opt/src
```

```shell
chown -R lilong:lilong /opt/module
```
# 7、安装jdk

上传 jdk 到 hadoop10 的 /opt/software

```shell
mkdir -p /opt/module/java
```

```shell
tar -zxvf /opt/software/jdk-8u212-linux-x64.tar.gz -C /opt/module/java/
```

```shell
vim $HOME/.bash_profile
```

添加以下内容:

```shell
export JAVA_HOME=/opt/module/java/jdk1.8.0_212
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$JAVA_HOME/bin:$PATH
```

```shell
source $HOME/.bash_profile
```

```shell
java -version
```

# 8、安装hadoop

[hadoop下载地址](https://archive.apache.org/dist/hadoop/common/hadoop-3.1.4/)

```shell
tar -zxvf /opt/software/hadoop-3.1.4.tar.gz -C /opt/module/
```

```shell
vim $HOME/.bash_profile
```

添加以下内容:

```shell
export HADOOP_HOME=/opt/module/hadoop-3.1.4
export PATH=$HADOOP_HOME/sbin:$HADOOP_HOME/bin:$PATH
```

```shell
source $HOME/.bash_profile
```

```shell
echo $HADOOP_HOME
```

# 9、rsync 远程同步脚本

```shell
cd
```

```shell
mkdir bin
```

```shell
cd bin
```

## 1)、在~/bin目录下创建xsync同步脚本

```shell
touch xsync
```

```shell
chmod u+x xsync
```

```shell
vim xsync
```

添加以下内容:

```shell
#!/bin/bash

if [ $# -eq 0 ];then
    echo "usage: $(basename $0) file "
    exit
fi

for host in hadoop10 hadoop14 hadoop16
do
    echo "============= $host ==============="
    for file in $@
    do
        if [ -e $file ];then
            dir=$(cd -P $(dirname $file);pwd)
            filename=$(basename $file)
            ssh $host "mkdir -p ${dir}"
            rsync -av ${dir}/${filename} ${host}:${dir}
        else
            echo "file not exist $file"
        fi
    done
done
```

## 2)、在~/bin目录下创建env_sync同步脚本

```shell
touch env_sync
```

```shell
chmod u+x env_sync
```

```shell
vim env_sync
```

添加以下内容:

```shell
#!/bin/bash

$HOME/bin/xsync $HOME/.bash_profile $HOME/bin $HADOOP_HOME/etc
```

## 3)、同步方式复制数据到其他服务器

```shell
xsync /opt/module/hadoop-3.1.4/ /opt/module/java/
```

```shell
env_sync
```

# 10、配置集群
```shell
cd $HADOOP_HOME/etc/hadoop
```

## 1)、默认配置文件 
要获取的默认文件 | 文件存放在Hadoop的jar包中的位置
---|---
[core-default.xml] | hadoop-common-3.1.3.jar/ core-default.xml
[hdfs-default.xml] | hadoop-hdfs-3.1.3.jar/ hdfs-default.xml
[hdfs-default.xml] | hadoop-hdfs-3.1.3.jar/ hdfs-default.xml
[yarn-default.xml] | hadoop-yarn-common-3.1.3.jar/ yarn-default.xml
[mapred-default.xml] | hadoop-mapreduce-client-core-3.1.3.jar/ mapred-default.xml

## 2)、自定义配置文件
    配置文件存放在$HADOOP_HOME/etc/hadoop这个路径上，用户可以根据项目需求重新进行修改配置
    core-site.xml、hdfs-site.xml、yarn-site.xml、mapred-site.xml

## 3)、常用端口
Daemon | App | Hadoop2 | Hadoop3
---|---|---|---
NameNode Port| 	Hadoop HDFS NameNode| 	8020 / 9000| 	9820
 -	| Hadoop HDFS NameNode HTTP UI| 	50070	| 9870
Secondary NameNode Port	| Secondary NameNode| 	50091| 	9869
- 	| Secondary NameNode HTTP UI| 	50090	| 9868
DataNode Port| 	Hadoop HDFS DataNode IPC| 	50020| 	9867
- | 	Hadoop HDFS DataNode| 	50010| 	9866
- | 	Hadoop HDFS DataNode HTTP UI| 	50075| 	9864

## 4)、核心配置文件

```shell
vim core-site.xml
```

内容如下:

    <?xml version="1.0" encoding="UTF-8"?>
    <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
    
    <configuration>
    	<!-- 指定NameNode的地址 -->
        <property>
            <name>fs.defaultFS</name>
            <value>hdfs://hadoop10:9820</value>
        </property>
        <!-- 指定hadoop数据的存储目录 -->
        <property>
            <name>hadoop.tmp.dir</name>
            <value>/opt/module/hadoop-3.1.4/data</value>
        </property>
    
        <!-- 配置HDFS网页登录使用的静态用户为atguigu -->
        <property>
            <name>hadoop.http.staticuser.user</name>
            <value>lilong</value>
        </property>
    
        <!-- 配置lilong(superUser)允许通过代理访问的主机节点 -->
        <property>
            <name>hadoop.proxyuser.lilong.hosts</name>
            <value>*</value>
        </property>
        <!-- 配置lilong(superUser)允许通过代理用户所属组 -->
        <property>
            <name>hadoop.proxyuser.lilong.groups</name>
            <value>*</value>
        </property>
        <!-- 配置lilong(superUser)允许通过代理的用户-->
        <property>
            <name>hadoop.proxyuser.lilong.groups</name>
            <value>*</value>
        </property>
    
    </configuration>

## 5)、HDFS配置文件

```shell
vim hdfs-site.xml
```

内容如下:

    <?xml version="1.0" encoding="UTF-8"?>
    <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
    
    <configuration>
    	<!-- nn web端访问地址-->
    	<property>
            <name>dfs.namenode.http-address</name>
            <value>hadoop10:9870</value>
        </property>
    	<!-- 2nn web端访问地址-->
        <property>
            <name>dfs.namenode.secondary.http-address</name>
            <value>hadoop16:9868</value>
        </property>
    </configuration>

## 6)、YARN配置文件

```shell
vim yarn-site.xml
```

内容如下:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<configuration>
	<!-- 指定MR走shuffle -->
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <!-- 指定ResourceManager的地址-->
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>hadoop14</value>
    </property>
    <!-- 环境变量的继承 -->
    <property>
        <name>yarn.nodemanager.env-whitelist</name>
        <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
    </property>
    <!-- yarn容器允许分配的最大最小内存 -->
    <property>
        <name>yarn.scheduler.minimum-allocation-mb</name>
        <value>512</value>
    </property>
    <property>
        <name>yarn.scheduler.maximum-allocation-mb</name>
        <value>4096</value>
    </property>
    <!-- yarn容器允许管理的物理内存大小 -->
    <property>
        <name>yarn.nodemanager.resource.memory-mb</name>
        <value>4096</value>
    </property>
    <!-- 关闭yarn对物理内存和虚拟内存的限制检查 -->
    <property>
        <name>yarn.nodemanager.pmem-check-enabled</name>
        <value>false</value>
    </property>
    <property>
        <name>yarn.nodemanager.vmem-check-enabled</name>
        <value>false</value>
    </property>
    <!-- 开启日志聚集功能 -->
    <property>
        <name>yarn.log-aggregation-enable</name>
        <value>true</value>
    </property>
    <!-- 设置日志聚集服务器地址 -->
    <property>  
        <name>yarn.log.server.url</name>  
        <value>http://hadoop10:19888/jobhistory/logs</value>
    </property>
    <!-- 设置日志保留时间为7天 -->
    <property>
        <name>yarn.log-aggregation.retain-seconds</name>
        <value>604800</value>
    </property>
</configuration>
```

## 7)、MapReduce配置文件

```shell
vim mapred-site.xml
```

内容如下:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<configuration>
	<!-- 指定MapReduce程序运行在Yarn上 -->
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <!-- 历史服务器端地址 -->
    <property>
        <name>mapreduce.jobhistory.address</name>
        <value>hadoop10:10020</value>
    </property>
    <!-- 历史服务器web端地址 -->
    <property>
        <name>mapreduce.jobhistory.webapp.address</name>
        <value>hadoop10:19888</value>
    </property>
</configuration>
```

## 8)、配置workers

```shell
vim ${HADOOP_HOME}/etc/hadoop/workers
```

增加如下内容：

```shell
hadoop10
hadoop14
hadoop16
```

==注意：该文件中添加的内容结尾不允许有空格，文件中不允许有空行==

# 11、编写常用脚本

## 1)、编写 jpsall,查询所有机器java进程

```shell
cd 
```

```shell
cd bin
```

```shell
touch jpsall
```

```shell
chmod u+x jpsall
```

```shell
vim jpsall
```

添加以下内容:

```shell
#!/bin/bash

for host in hadoop10 hadoop14 hadoop16
do
    echo "========== $host =========="
    ssh $host "${JAVA_HOME}/bin/jps | grep -v Jps"
done
```

## 2)、编写 hadoop_cluster,群起hadoop服务

```shell
touch hadoop_cluster
```

```shell
chmod u+x hadoop_cluster
```

```shell
vim hadoop_cluster
```

添加以下内容:

```shell
#!/bin/bash

case $1 in
"start")
    echo "========== start hdfs =========="
    ssh hadoop10 "${HADOOP_HOME}/sbin/start-dfs.sh"
    echo "========== start yarn =========="
    ssh hadoop14 "${HADOOP_HOME}/sbin/start-yarn.sh"
    echo "========== start historyserver =========="
    ssh hadoop10 "${HADOOP_HOME}/bin/mapred --daemon start historyserver"
;;
"stop")
    echo "========== stop hdfs =========="
    ssh hadoop10 "${HADOOP_HOME}/sbin/stop-dfs.sh"
    echo "========== stop yarn =========="
    ssh hadoop14 "${HADOOP_HOME}/sbin/stop-yarn.sh"
    echo "========== stop historyserver =========="
    ssh hadoop10 "${HADOOP_HOME}/bin/mapred --daemon stop historyserver"
;;
*)
    echo "arguments: start | stop"
;;
esac
```



# 12、同步配置文件

```shell
env_sync
```

# 13、启动服务相关命令

## 1)、说明

```
如果集群是第一次启动，需要在hadoop10节点格式化NameNode
如果集群在运行过程中报错，需要重新格式化NameNode的话，一定要先停止namenode和datanode进程，并且要删除所有节点下data目录和logs目录
```

## 2)、格式化

```shell
hdfs namenode -format
```

## 3)、各个服务组件逐一启动/停止

### 3.1)、分别启动/停止HDFS组件

```shell
hdfs --daemon start/stop namenode/datanode/secondarynamenode
```

### 3.2)、启动/停止YARN

```shell
yarn --daemon start/stop  resourcemanager/nodemanager
```

### 3.3)、启动/停止历史服务器

```shell
mapred --daemon start/stop  historyserver
```

## 4)、各个模块分开启动/停止（配置ssh是前提）常用

### 4.1)、整体启动/停止HDFS

```shell
start-dfs.sh/stop-dfs.sh
```

### 4.2)、整体启动/停止YARN

```shell
start-yarn.sh/stop-yarn.sh
```

# 14、群起

```shell
hadoop_cluster start
```

```shell
jpsall
```