### Hadoop3编译安装

基础环境：Centos 7.7

编译环境软件安装目录

```shell
mkdir -p /opt/module
mkdir -p /opt/src
mkdir -p /opt/software
```

----

#### Hadoop编译安装

- 安装编译相关的依赖

  ```shell
  1、yum install gcc gcc-c++
  
  #下面这个命令不需要执行 手动安装cmake
  2、yum install make cmake  #(这里cmake版本推荐为3.6版本以上，版本低源码无法编译！可手动安装)
  
  3、yum install autoconf automake libtool curl
  
  4、yum install lzo-devel zlib-devel openssl openssl-devel ncurses-devel
  
  5、yum install snappy snappy-devel bzip2 bzip2-devel lzo lzo-devel lzop libXtst
  ```

- 手动安装cmake 

  ```shell
  #yum卸载已安装cmake 版本低
  yum erase cmake
  
  #解压
  tar -zxvf cmake-3.13.5.tar.gz -C /opt/src
  
  #编译安装
  cd /opt/src/cmake-3.13.5
  
  ./configure
  
  make && make install
  
  #验证
  [root@node4 ~]# cmake -version      
  cmake version 3.13.5
  
  #如果没有正确显示版本 请断开SSH连接 重写登录
  ```

- 手动安装snappy

  ```shell
  #卸载已经安装的
  cd /usr/local/lib
  
  rm -rf libsnappy*
  
  #上传解压
  tar -zxvf snappy-1.1.3.tar.gz -C /opt/src
  
  #编译安装
  cd /opt/src/snappy-1.1.3
  ./configure
  make && make install
  
  #验证是否安装
  [root@node4 snappy-1.1.3]# ls -lh /usr/local/lib |grep snappy
  -rw-r--r-- 1 root root 511K Nov  4 17:13 libsnappy.a
  -rwxr-xr-x 1 root root  955 Nov  4 17:13 libsnappy.la
  lrwxrwxrwx 1 root root   18 Nov  4 17:13 libsnappy.so -> libsnappy.so.1.3.0
  lrwxrwxrwx 1 root root   18 Nov  4 17:13 libsnappy.so.1 -> libsnappy.so.1.3.0
  -rwxr-xr-x 1 root root 253K Nov  4 17:13 libsnappy.so.1.3.0
  ```

- 安装配置JDK 1.8

  ```shell
  #解压安装包
  tar -zxvf jdk-8u212-linux-x64.tar.gz -C /opt/module/
  
  #配置环境变量
  vim ~/.bash_profile
  
  export JAVA_HOME=/opt/module/java/jdk1.8.0_212
  export JRE_HOME=$JAVA_HOME/jre
  export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
  export PATH=$JAVA_HOME/bin:$PATH
  
  source ~/.bash_profile
  
  #验证是否安装成功
  java -version
  
  java version "1.8.0_212"
  Java(TM) SE Runtime Environment (build 1.8.0_212-b10)
  Java HotSpot(TM) 64-Bit Server VM (build 25.212-b10, mixed mode)
  ```

- 安装配置maven

  ```shell
  #解压安装包
  tar -zxvf apache-maven-3.5.4-bin.tar.gz
  
  #配置环境变量
  vim ~/.bash_profile
  
  export MAVEN_HOME=/opt/module/apache-maven-3.5.4
  export MAVEN_OPTS="-Xms1024m -Xmx1024m"
  export PATH=:$MAVEN_HOME/bin:$PATH
  
  source ~/.bash_profile
  
  #验证是否安装成功
  [root@node4 ~]# mvn -v
  Apache Maven 3.5.4
  
  #添加maven 阿里云仓库地址 加快国内编译速度
  mkdir -p /var/m2/repository
  chown -R lilong:lilong /var/m2/repository
  vim /opt/module/apache-maven-3.5.4/conf/settings.xml
  ```

  内容如下:

  ```xml
  <localRepository>/var/m2/repository</localRepository>
  <mirrors>
       <mirror>
             <id>alimaven</id>
             <name>aliyun maven</name>
             <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
             <mirrorOf>central</mirrorOf>
        </mirror>
  </mirrors>
  ```

  

- 安装ProtocolBuffer 2.5.0

  ```shell
  #解压
  tar -zxvf protobuf-2.5.0.tar.gz -C /opt/src/
  
  #编译安装
  cd /opt/src/protobuf-2.5.0
  ./configure
  make && make install
  
  #验证是否安装成功
  [root@node4 protobuf-2.5.0]# protoc --version
  libprotoc 2.5.0
  ```

- 编译hadoop

  ```shell
  #上传解压源码包
  tar -zxvf hadoop-3.1.4-src.tar.gz /opt/src/
  
  #编译
  cd /opt/src/hadoop-3.1.4-src
  
  mvn clean package -Pdist,native -DskipTests -Dtar -Dbundle.snappy -Dsnappy.lib=/usr/local/lib
  
  #参数说明：
  
  Pdist,native ：把重新编译生成的hadoop动态库；
  DskipTests ：跳过测试
  Dtar ：最后把文件以tar打包
  Dbundle.snappy ：添加snappy压缩支持【默认官网下载的是不支持的】
  Dsnappy.lib=/usr/local/lib ：指snappy在编译机器上安装后的库路径
  ```

- 编译之后的安装包路径

  ```
  /opt/src/hadoop-3.1.4-src/hadoop-dist/target
  ```

- Hadoop 完全分布式安装

  - 集群规划

    | 主机  | 角色                 |
    | ----- | -------------------- |
    | node1 | NN    DN   RM  NM    |
    | node2 | SNN  DN           NM |
    | node3 | DN          NM       |

  - 基础环境

    ```
    防火墙关闭
    ssh免密登录
    集群时间同步
    JDK 1.8安装
    ```

  - 修改配置文件

    - hadoop-env.sh

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

    - core-site.xml

      ```xml
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

    - hdfs-site.xml

      ```xml
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
          
              <!-- 白名单 -->
      	<property>
      		<name>dfs.hosts</name>
      		<value>/opt/module/hadoop-3.1.4/etc/hadoop/whitelist</value>
      	</property>
      	<!-- 黑名单 -->
      	<property>
      		<name>dfs.hosts.exclude</name>
      		<value>/opt/module/hadoop-3.1.4/etc/hadoop/blacklist</value>
      	</property>
          
      </configuration>
      ```

    - mapred-site.xml

      ```xml
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

    - yarn-site.xml

      ```xml
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

    - workers

      ```shell
      hadoop10
      hadoop14
      hadoop16
      ```

    ```shell
    touch env_sync
    chmod u+x env_sync
    vim env_sync
    ```

  - 将hadoop添加到环境变量

    ```shell
    vim ~/.bash_proflie
    
    export HADOOP_HOME=/opt/module/hadoop-3.1.4
    export PATH=$HADOOP_HOME/sbin:$HADOOP_HOME/bin:$PATH
    
    source ~/.bash_proflie
    ```

  - 分发同步安装包

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

    ```shell
    xsync /opt/module/hadoop-3.1.4/ /opt/module/java/
    ```

   - 同步环境变量

     ```shell
     xsync $HOME/.bash_profile
     xsync $HOME/bin
     xsync $HADOOP_HOME/etc/hadoop/hadoop-env.sh
     xsync $HADOOP_HOME/etc/hadoop/core-site.xml
     xsync $HADOOP_HOME/etc/hadoop/hdfs-site.xml
     xsync $HADOOP_HOME/etc/hadoop/yarn-site.xml
     xsync $HADOOP_HOME/etc/hadoop/mapred-site.xml
     xsync $HADOOP_HOME/etc/hadoop/workers
     xsync $HADOOP_HOME/etc/hadoop/whitelist
     xsync $HADOOP_HOME/etc/hadoop/blacklist
     ```

     

- Hadoop集群启动

  - （==首次启动==）格式化namenode

    ```shell
    hdfs namenode -format
    ```

  - 脚本一键启动

    ```shell
    [root@node1 ~]# start-dfs.sh 
    Starting namenodes on [node1]
    Last login: Thu Nov  5 10:44:10 CST 2020 on pts/0
    Starting datanodes
    Last login: Thu Nov  5 10:45:02 CST 2020 on pts/0
    Starting secondary namenodes [node2]
    Last login: Thu Nov  5 10:45:04 CST 2020 on pts/0
    
    [root@node1 ~]# start-yarn.sh 
    Starting resourcemanager
    Last login: Thu Nov  5 10:45:08 CST 2020 on pts/0
    Starting nodemanagers
    Last login: Thu Nov  5 10:45:44 CST 2020 on pts/0
    ```

  - Web  UI页面

    - HDFS集群：http://node10:9870/
    - YARN集群：http://node14:8088/

  - 错误1:运行hadoop3官方自带mr示例出错。

    - 错误信息

      ```shell
      Error: Could not find or load main class org.apache.hadoop.mapreduce.v2.app.MRAppMaster
      
      Please check whether your etc/hadoop/mapred-site.xml contains the below configuration:
      <property>
        <name>yarn.app.mapreduce.am.env</name>
        <value>HADOOP_MAPRED_HOME=${full path of your hadoop distribution directory}</value>
      </property>
      <property>
        <name>mapreduce.map.env</name>
        <value>HADOOP_MAPRED_HOME=${full path of your hadoop distribution directory}</value>
      </property>
      <property>
        <name>mapreduce.reduce.env</name>
        <value>HADOOP_MAPRED_HOME=${full path of your hadoop distribution directory}</value>
      </property>
      ```

    - 解决  mapred-site.xml,增加以下配置

      ```xml
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
      ```

      



