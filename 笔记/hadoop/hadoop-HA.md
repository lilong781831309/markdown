

## 环境准备

  1. 修改主机名
  2. 关闭防火墙
  3. ssh免密登录
  4. 软件存放位置



## 规划集群

| hadoop10        | hadoop14        | hadoop16        |
| --------------- | --------------- | --------------- |
| NameNode        | NameNode        | NameNode        |
| ZKFC            | ZKFC            | ZKFC            |
| JournalNode     | JournalNode     | JournalNode     |
| DataNode        | DataNode        | DataNode        |
| ZK              | ZK              | ZK              |
| ResourceManager | ResourceManager | ResourceManager |
| NodeManager     | NodeManager     | NodeManager     |

## 准备安装目录



```shell
mkdir -p /opt/software
mkdir -p /opt/src
mkdir -p /opt/module

chown -R lilong:lilong /opt/software
chown -R lilong:lilong /opt/src
chown -R lilong:lilong /opt/module

software	存放安装包
src			存放解压后的源码
module		安装应用
```



## 同步脚本

```shell
[lilong@hadoop16 ~]$ mkdir -p bin
[lilong@hadoop16 ~]$ cd bin
[lilong@hadoop16 ~]$ touch xsync
[lilong@hadoop16 ~]$ chmod u+x xsync
[lilong@hadoop16 ~]$ vim xsync
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



## 安装jdk

```shell
[lilong@hadoop10 software]$ mkdir -p /opt/module/java
[lilong@hadoop10 software]$ tar -zxvf jdk-8u212-linux-x64.tar.gz -C /opt/module/java
[lilong@hadoop10 software]$ sudo vim /etc/profile.d/java.sh
```

内容如下:

```shell
export JAVA_HOME=/opt/module/java/jdk1.8.0_212
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$JAVA_HOME/bin:$PATH
```

```shell
[lilong@hadoop10 software]$ source /etc/profile
[lilong@hadoop10 software]$ java -version
java version "1.8.0_212"
Java(TM) SE Runtime Environment (build 1.8.0_212-b10)
Java HotSpot(TM) 64-Bit Server VM (build 25.212-b10, mixed mode)
```

同步

```shell
[lilong@hadoop10 software]$ xsync /opt/module/java
[lilong@hadoop10 software]$ sudo /home/lilong/bin/xsync /etc/profile.d/java.sh
```



## 安装zookeeper

```shell
[lilong@hadoop10 software]$ tar -zxvf apache-zookeeper-3.5.7-bin.tar.gz -C /opt/module/
[lilong@hadoop10 software]$ cd /opt/module/
[lilong@hadoop10 module]$ mv apache-zookeeper-3.5.7-bin zookeeper-3.5.7
[lilong@hadoop10 module]$ cd zookeeper-3.5.7/conf/
[lilong@hadoop10 conf]$ mv zoo_sample.cfg zoo.cfg
[lilong@hadoop10 conf]$ vim zoo.cfg
```

```shell
dataDir=/opt/module/zookeeper-3.5.7/data
#######################cluster##########################
server.10=hadoop10:2888:3888
server.14=hadoop14:2888:3888
server.16=hadoop16:2888:3888
```

```shell
[lilong@hadoop10 conf]$ cd ..
[lilong@hadoop10 zookeeper-3.5.7]$ mkdir data
[lilong@hadoop10 zookeeper-3.5.7]$ cd data
[lilong@hadoop10 data]$ echo 10 >> myid
```

同步

```shell
[lilong@hadoop10 data]$ xsync /opt/module/zookeeper-3.5.7
[lilong@hadoop10 data]$ ssh hadoop14 "echo 14 > /opt/module/zookeeper-3.5.7/data/myid"
[lilong@hadoop10 data]$ ssh hadoop16 "echo 16 > /opt/module/zookeeper-3.5.7/data/myid"
```

启动集群

```shell
[lilong@hadoop10 data]$ /opt/module/zookeeper-3.5.7/bin/zkServer.sh start
[lilong@hadoop10 data]$ ssh hadoop14 "/opt/module/zookeeper-3.5.7/bin/zkServer.sh start"
[lilong@hadoop10 data]$ ssh hadoop16 "/opt/module/zookeeper-3.5.7/bin/zkServer.sh start"
```

查看状态

```shell
[lilong@hadoop10 data]$ /opt/module/zookeeper-3.5.7/bin/zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /opt/module/zookeeper-3.5.7/bin/../conf/zoo.cfg
Client port found: 2181. Client address: localhost.
Mode: leader
[lilong@hadoop10 data]$ ssh hadoop14 "/opt/module/zookeeper-3.5.7/bin/zkServer.sh status"
ZooKeeper JMX enabled by default
Using config: /opt/module/zookeeper-3.5.7/bin/../conf/zoo.cfg
Client port found: 2181. Client address: localhost.
Mode: follower
[lilong@hadoop10 data]$ ssh hadoop16 "/opt/module/zookeeper-3.5.7/bin/zkServer.sh status"
ZooKeeper JMX enabled by default
Using config: /opt/module/zookeeper-3.5.7/bin/../conf/zoo.cfg
Client port found: 2181. Client address: localhost.
Mode: follower
```



## HDFS-HA集群

```shell
#编译的源码
[lilong@hadoop10 data]$ cd /opt/src/hadoop-3.1.4-src/hadoop-dist/target/
[lilong@hadoop10 target]$ tar -zxvf hadoop-3.1.4.tar.gz -C /opt/module/
[lilong@hadoop10 target]$ sudo vim /etc/profile.d/hadoop.sh
```

内容如下

```shell
export HADOOP_HOME=/opt/module/hadoop-3.1.4
export PATH=$HADOOP_HOME/sbin:$HADOOP_HOME/bin:$PATH
```

```shell
[lilong@hadoop10 target]$ source /etc/profile
[lilong@hadoop10 target]$ echo $HADOOP_HOME
/opt/module/hadoop-3.1.4
[lilong@hadoop10 target]$ cd /opt/module/hadoop-3.1.4/etc/hadoop/
```



#### hadoop-env.sh

```shell
#配置JAVA_HOME
export JAVA_HOME=/opt/module/java/jdk1.8.0_212
#文件最后添加各进程启动身份
export HDFS_NAMENODE_USER=lilong
export HDFS_DATANODE_USER=lilong
export YARN_RESOURCEMANAGER_USER=lilong
export YARN_NODEMANAGER_USER=lilong 
```



#### core-site.xml

```xml
<configuration>
    
    <!-- 把多个NameNode的地址组装成一个集群 hadoopcluster -->
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://hadoopcluster</value>
    </property>
    
    <!-- 指定hadoop运行时产生文件的存储目录 -->
    <property>
        <name>hadoop.tmp.dir</name>
        <value>/opt/module/hadoop-3.1.4/data</value>
    </property>
    
    <!-- 指定zkfc要连接的zkServer地址 -->
    <property>
	    <name>ha.zookeeper.quorum</name>
	    <value>hadoop10:2181,hadoop14:2181,hadoop16:2181</value>
    </property>

</configuration>
```



#### hdfs-site.xml

```xml
<configuration>
    
    <!-- NameNode数据存储目录 -->
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>file://${hadoop.tmp.dir}/name</value>
    </property>
    
    <!-- DataNode数据存储目录 -->
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>file://${hadoop.tmp.dir}/data</value>
    </property>
    
    <!-- JournalNode数据存储目录 -->
    <property>
        <name>dfs.journalnode.edits.dir</name>
        <value>${hadoop.tmp.dir}/jn</value>
    </property>
    
    <!-- 完全分布式集群名称 -->
    <property>
        <name>dfs.nameservices</name>
        <value>hadoopcluster</value>
    </property>
    
    <!-- 集群中NameNode节点都有哪些 -->
    <property>
        <name>dfs.ha.namenodes.hadoopcluster</name>
        <value>nn10,nn14,nn16</value>
    </property>
    
    <!-- NameNode的RPC通信地址 -->
    <property>
        <name>dfs.namenode.rpc-address.hadoopcluster.nn10</name>
        <value>hadoop10:8020</value>
    </property>
    <property>
        <name>dfs.namenode.rpc-address.hadoopcluster.nn14</name>
        <value>hadoop14:8020</value>
    </property>
    <property>
        <name>dfs.namenode.rpc-address.hadoopcluster.nn16</name>
        <value>hadoop16:8020</value>
    </property>
    
    <!-- NameNode的http通信地址 -->
    <property>
        <name>dfs.namenode.http-address.hadoopcluster.nn10</name>
        <value>hadoop10:9870</value>
    </property>
    <property>
        <name>dfs.namenode.http-address.hadoopcluster.nn14</name>
        <value>hadoop14:9870</value>
    </property>
    <property>
        <name>dfs.namenode.http-address.hadoopcluster.nn16</name>
        <value>hadoop16:9870</value>
    </property>
    
    <!-- 指定NameNode元数据在JournalNode上的存放位置 -->
    <property>
        <name>dfs.namenode.shared.edits.dir</name>
        <value>qjournal://hadoop10:8485;hadoop14:8485;hadoop16:8485/hadoopcluster</value>
    </property>
    
    <!-- 访问代理类：client用于确定哪个NameNode为Active -->
    <property>
        <name>dfs.client.failover.proxy.provider.hadoopcluster</name>
        <value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value>
    </property>
    
    <!-- 配置隔离机制，即同一时刻只能有一台服务器对外响应 -->
    <property>
        <name>dfs.ha.fencing.methods</name>
        <value>sshfence</value>
    </property>
    
    <!-- 使用隔离机制时需要ssh秘钥登录-->
    <property>
        <name>dfs.ha.fencing.ssh.private-key-files</name>
        <value>/home/lilong/.ssh/id_rsa</value>
    </property>
    
    <!-- 启用nn故障自动转移 -->
    <property>
	    <name>dfs.ha.automatic-failover.enabled</name>
	    <value>true</value>
    </property>

</configuration>
```



#### yarn-site.xml

```xml
<configuration>

    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>

    <!-- 启用resourcemanager ha -->
    <property>
        <name>yarn.resourcemanager.ha.enabled</name>
        <value>true</value>
    </property>
 
    <!-- 声明两台resourcemanager的地址 -->
    <property>
        <name>yarn.resourcemanager.cluster-id</name>
        <value>cluster-yarn</value>
    </property>
    <!--指定resourcemanager的逻辑列表-->
    <property>
        <name>yarn.resourcemanager.ha.rm-ids</name>
        <value>rm10,rm14,rm16</value>
    </property>
    
    <!-- ========== rm10的配置 ========== -->
    <!-- 指定rm10的主机名 -->
    <property>
        <name>yarn.resourcemanager.hostname.rm10</name>
        <value>hadoop10</value>
    </property>
    <!-- 指定rm10的web端地址 -->
    <property>
        <name>yarn.resourcemanager.webapp.address.rm10</name>
        <value>hadoop10:8088</value>
    </property>
    <!-- 指定rm10的内部通信地址 -->
    <property>
        <name>yarn.resourcemanager.address.rm10</name>
        <value>hadoop10:8032</value>
    </property>
    <!-- 指定AM向rm10申请资源的地址 -->
    <property>
        <name>yarn.resourcemanager.scheduler.address.rm10</name>  
        <value>hadoop10:8030</value>
    </property>
    <!-- 指定供NM连接的地址 -->  
    <property>
        <name>yarn.resourcemanager.resource-tracker.address.rm10</name>
        <value>hadoop10:8031</value>
    </property>
    
    <!-- ========== rm14的配置 ========== -->
    <!-- 指定rm14的主机名 -->
    <property>
        <name>yarn.resourcemanager.hostname.rm14</name>
        <value>hadoop14</value>
    </property>
    <property>
        <name>yarn.resourcemanager.webapp.address.rm14</name>
    <value>hadoop14:8088</value>
    </property>
    <property>
        <name>yarn.resourcemanager.address.rm14</name>
        <value>hadoop14:8032</value>
    </property>
    <property>
        <name>yarn.resourcemanager.scheduler.address.rm14</name>
        <value>hadoop14:8030</value>
    </property>
    <property>
        <name>yarn.resourcemanager.resource-tracker.address.rm14</name>
        <value>hadoop14:8031</value>
    </property>
     
    <!-- ========== rm16的配置 ========== -->
    <!-- 指定rm16的主机名 -->
    <property>
        <name>yarn.resourcemanager.hostname.rm16</name>
        <value>hadoop16</value>
    </property>
    <property>
        <name>yarn.resourcemanager.webapp.address.rm16</name>
    <value>hadoop16:8088</value>
    </property>
    <property>
        <name>yarn.resourcemanager.address.rm16</name>
        <value>hadoop16:8032</value>
    </property>
    <property>
        <name>yarn.resourcemanager.scheduler.address.rm16</name>
        <value>hadoop16:8030</value>
    </property>
    <property>
        <name>yarn.resourcemanager.resource-tracker.address.rm16</name>
        <value>hadoop16:8031</value>
    </property>
    
    <!-- 指定zookeeper集群的地址 --> 
    <property>
        <name>yarn.resourcemanager.zk-address</name>
        <value>hadoop10:2181,hadoop14:2181,hadoop16:2181</value>
    </property>

    <!-- 启用自动恢复 --> 
    <property>
        <name>yarn.resourcemanager.recovery.enabled</name>
        <value>true</value>
    </property>
 
    <!-- 指定resourcemanager的状态信息存储在zookeeper集群 --> 
    <property>
        <name>yarn.resourcemanager.store.class</name> 
        <value>org.apache.hadoop.yarn.server.resourcemanager.recovery.ZKRMStateStore</value>
    </property>
    <!-- 环境变量的继承 -->
    <property>
        <name>yarn.nodemanager.env-whitelist</name>
        <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
    </property>

</configuration>

```

同步

```shell
[lilong@hadoop10 software]$ xsync /opt/module/hadoop-3.1.4
[lilong@hadoop10 software]$ sudo /home/lilong/bin/xsync /etc/profile.d/hadoop.sh
```



## 启动集群



#### 启动Zookeeper

```shell
[lilong@hadoop10 ~]$ /opt/module/zookeeper-3.5.7/bin/zkServer.sh start
[lilong@hadoop14 ~]$ /opt/module/zookeeper-3.5.7/bin/zkServer.sh start
[lilong@hadoop16 ~]$ /opt/module/zookeeper-3.5.7/bin/zkServer.sh start
```



#### 初始化zkfc

```shell
[lilong@hadoop10 ~]$ hdfs zkfc -formatZK
```



#### 启动journalnode

```shell
[lilong@hadoop10 ~]$ hdfs --daemon start journalnode
[lilong@hadoop14 ~]$ hdfs --daemon start journalnode
[lilong@hadoop16 ~]$ hdfs --daemon start journalnode
```



#### 启动namenode

```shell
#在[nn10]上，对其进行格式化，并启动
[lilong@hadoop10 ~]$ hdfs namenode -format
[lilong@hadoop10 ~]$ hdfs --daemon start namenode

#在[nn14]和[nn16]上，同步nn10的元数据信息
[lilong@hadoop14 ~]$ hdfs namenode -bootstrapStandby
[lilong@hadoop16 ~]$ hdfs namenode -bootstrapStandby

#启动[nn14]和[nn16]
[lilong@hadoop14 ~]$ hdfs --daemon start namenode
[lilong@hadoop16 ~]$ hdfs --daemon start namenode

#将[nn10]切换为Active
[lilong@hadoop10 ~]$ hdfs haadmin -transitionToActive nn10
#查看是否Active
[lilong@hadoop10 ~]$ hdfs haadmin -getServiceState nn10
```



#### 启动datanode

```shell
[lilong@hadoop10 ~]$ hdfs --daemon start datanode
[lilong@hadoop14 ~]$ hdfs --daemon start datanode
[lilong@hadoop16 ~]$ hdfs --daemon start datanode
```



#### 启动yarn

```shell
[lilong@hadoop14 ~]$ start-yarn.sh
```

查看yarn服务状态

```shell
[lilong@hadoop14 ~]$ yarn rmadmin -getServiceState rm14
```