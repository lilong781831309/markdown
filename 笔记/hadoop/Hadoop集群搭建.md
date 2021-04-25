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
ssh-keygen -t rsa
ssh-copy-id hadoop10
ssh-copy-id hadoop14
ssh-copy-id hadoop16
```

# 6、准备安装目录

```shell
准备资源包目录
mkdir /opt/software

准备源码目录
mkdir /opt/src

准备安装目录
mkdir /opt/module
chown -R lilong:lilong /opt/software
chown -R lilong:lilong /opt/src
chown -R lilong:lilong /opt/module
```

# 7、安装jdk

上传 jdk 到 hadoop10 的 /opt/software

```shell
mkdir -p /opt/module/java
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

测试

```shell
source $HOME/.bash_profile
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
echo $HADOOP_HOME
```



# 9、配置集群
```shell
cd $HADOOP_HOME/etc/hadoop
```

- #### 默认配置文件 

要获取的默认文件 | 文件存放在Hadoop的jar包中的位置
---|---
[core-default.xml] | hadoop-common-3.1.3.jar/ core-default.xml
[hdfs-default.xml] | hadoop-hdfs-3.1.3.jar/ hdfs-default.xml
[hdfs-default.xml] | hadoop-hdfs-3.1.3.jar/ hdfs-default.xml
[yarn-default.xml] | hadoop-yarn-common-3.1.3.jar/ yarn-default.xml
[mapred-default.xml] | hadoop-mapreduce-client-core-3.1.3.jar/ mapred-default.xml

- #### 自定义配置文件

    配置文件存放在$HADOOP_HOME/etc/hadoop这个路径上，用户可以根据项目需求重新进行修改配置
    core-site.xml、hdfs-site.xml、yarn-site.xml、mapred-site.xml

- #### 常用端口

Daemon | App | Hadoop2 | Hadoop3
---|---|---|---
NameNode Port| 	Hadoop HDFS NameNode| 	8020 / 9000| 	9820
 -	| Hadoop HDFS NameNode HTTP UI| 	50070	| 9870
Secondary NameNode Port	| Secondary NameNode| 	50091| 	9869
- 	| Secondary NameNode HTTP UI| 	50090	| 9868
DataNode Port| 	Hadoop HDFS DataNode IPC| 	50020| 	9867
- | 	Hadoop HDFS DataNode| 	50010| 	9866
- | 	Hadoop HDFS DataNode HTTP UI| 	50075| 	9864



- #### hadoop-env.sh


```shell
#配置JAVA_HOME
export JAVA_HOME=/opt/module/java/jdk1.8.0_212
#文件最后添加各进程启动身份
export HDFS_NAMENODE_USER=lilong
export HDFS_DATANODE_USER=lilong
export HDFS_SECONDARYNAMENODE_USER=lilong
export YARN_RESOURCEMANAGER_USER=lilong
export YARN_NODEMANAGER_USER=lilong 
```



- #### core-site.xml

```xml
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

    <!-- 设置HDFS web UI用户身份 -->
    <property>
        <name>hadoop.http.staticuser.user</name>
        <value>lilong</value>
    </property>

    <!-- 整合hive -->
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

</configuration>
```




- #### hdfs-site.xml

```xml
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
```




- #### yarn-site.xml

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
    
    <!-- 是否将对容器实施物理内存限制 -->
    <property>
        <name>yarn.nodemanager.pmem-check-enabled</name>
        <value>false</value>
    </property>
    
    <!-- 是否将对容器实施虚拟内存限制。 -->
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



- #### mapred-site.xml

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
    
    <property>
      <name>yarn.app.mapreduce.am.env</name>
      <value>HADOOP_MAPRED_HOME=${HADOOP_HOME}</value>
    </property>

    <property>
      <name>mapreduce.map.env</name>
      <value>HADOOP_MAPRED_HOME=${HADOOP_HOME}</value>
    </property>

    <property>
      <name>mapreduce.reduce.env</name>
      <value>HADOOP_MAPRED_HOME=${HADOOP_HOME}</value>
    </property>
    
</configuration>
```



- #### workers

```shell
hadoop10
hadoop14
hadoop16
```

==注意：该文件中添加的内容结尾不允许有空格，文件中不允许有空行==

# 10、编写常用脚本

- #### 编写 jpsall,查询所有机器java进程

```shell
cd 
cd bin
touch jpsall
chmod u+x jpsall
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

- #### 编写 hadoop_cluster,群起hadoop服务

```shell
touch hadoop_cluster
chmod u+x hadoop_cluster
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



- #### 同步脚本

```shell
touch xsync
chmod u+x xsync
vim xsync
```

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



- #### 配置文件同步脚本

```shell
touch env_sync
chmod u+x env_sync
vim env_sync
```

内容如下:

```shell
#!/bin/bash

$HOME/bin/xsync $HOME/.bash_profile
$HOME/bin/xsync $HOME/bin
$HOME/bin/xsync $HADOOP_HOME/etc/hadoop/hadoop-env.sh
$HOME/bin/xsync $HADOOP_HOME/etc/hadoop/core-site.xml
$HOME/bin/xsync $HADOOP_HOME/etc/hadoop/hdfs-site.xml
$HOME/bin/xsync $HADOOP_HOME/etc/hadoop/yarn-site.xml
$HOME/bin/xsync $HADOOP_HOME/etc/hadoop/mapred-site.xml
$HOME/bin/xsync $HADOOP_HOME/etc/hadoop/workers
```

执行同步

```shell
xsync /opt/module/hadoop-3.1.4/ /opt/module/java/
env_sync
```



# 11、启动服务相关命令

- #### 说明

```
如果集群是第一次启动，需要在hadoop10节点格式化NameNode
如果集群在运行过程中报错，需要重新格式化NameNode的话，一定要先停止namenode和datanode进程，并且要删除所有节点下data目录和logs目录
```

- #### 格式化

```shell
hdfs namenode -format
```

- #### 各个服务组件逐一启动/停止

分别启动/停止HDFS组件

```shell
hdfs --daemon start/stop namenode/datanode/secondarynamenode
```

启动/停止YARN

```shell
yarn --daemon start/stop  resourcemanager/nodemanager
```

启动/停止历史服务器

```shell
mapred --daemon start/stop  historyserver
```

- #### 各个模块分开启动/停止（配置ssh是前提）常用

整体启动/停止HDFS

```shell
start-dfs.sh/stop-dfs.sh
```

整体启动/停止YARN

```shell
start-yarn.sh/stop-yarn.sh
```

- #### 群起

```shell
hadoop_cluster start
```

```shell
jpsall
```