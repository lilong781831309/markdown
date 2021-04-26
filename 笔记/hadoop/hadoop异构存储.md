### 存储类型

- RAM_DISK    DataNode中的内存空间
- SSD                固态硬盘
- DISK		默认的存储类型，磁盘存储

- ARCHIVE        具有存储密度高(PB级)，但计算能力小的特点，可用于支持档案存储。

- PROVIDED     远程存储



### 存储策略

- **Hot(default)**

  - 用于大量存储和计算

  - 当数据经常被使用，将保留在此策略中

  - 当block是hot时，所有副本都存储在磁盘中

- **Cold**

  - 仅仅用于存储，只有非常有限的一部分数据用于计算

  - 不再使用的数据或需要存档的数据将从热存储转移到冷存储中

  - 当block是cold时，所有副本都存储在Archive中

- **Warm**

  - 部分热，部分冷

  - 当一个块是warm时，它的一些副本存储在磁盘中，其余的副本存储在Archive中

- **One_SSD**
  - 在SSD中存储一个副本，其余的副本存储在磁盘中
- **All_SSD**
  - 将所有副本存储在SSD中

- **Lazy_Persist**
  - 用于编写内存中只有一个副本的块。副本首先写在RAM_Disk中，然后惰性地保存在磁盘中



### 存储策略命令

列出存储策略：hdfs  storagepolicies  -listPolicies

设置存储策略：hdfs  storagepolicies  -setStoragePolicy  -path  <path>  -policy  <policy>

取消存储策略：hdfs storagepolicies  -unsetStoragePolicy -path  <path>

获取存储策略：hdfs storagepolicies -getStoragePolicy -path <path>



### hdfs-site.xml

```xml
<property>
    <name>dfs.datanode.data.dir</name>
    <value>[RAM_DISK]/opt/module/hadoop-3.1.4/data/data/ram,[SSD]file:///opt/module/hadoop-3.1.4/data/data/ssd,[DISK]file:///opt/module/hadoop-3.1.4/data/data/disk,[ARCHIVE]file:///opt/module/hadoop-3.1.4/data/data/archive</value>
    <description>DataNode存储名称空间和事务日志的本地文件系统上的路径</description>
</property>

<property>
    <name>dfs.datanode.max.locked.memory</name>
    <value>2147483648</value>
</property>

```



### 挂载 tmpfs

```shell
mkdir -p /opt/module/hadoop-3.1.4/data/data/ram/
sudo chown lilong:lilong /opt/module/hadoop-3.1.4/data/data/ram/
sudo mount -t tmpfs -o size=4g tmpfs /opt/module/hadoop-3.1.4/data/data/ram/
```



### 修改 max locked memory

```shell
vim /etc/security/limits.d/20-nproc.conf
```

```shell
lilong       soft    nproc     unlimited
lilong       hard    nproc     unlimited
lilong       soft    memlock   unlimited
lilong       hard    memlock   unlimited
```



### 测试

```shell
hdfs dfs -mkdir /hot
hdfs dfs -mkdir /cold
hdfs dfs -mkdir /warm
hdfs dfs -mkdir /one_ssd
hdfs dfs -mkdir /all_ssd
hdfs dfs -mkdir /lazy_persist

hdfs  storagepolicies  -setStoragePolicy  -path  /hot           -policy  Hot
hdfs  storagepolicies  -setStoragePolicy  -path  /cold          -policy  Cold
hdfs  storagepolicies  -setStoragePolicy  -path  /warm          -policy  Warm
hdfs  storagepolicies  -setStoragePolicy  -path  /one_ssd       -policy  One_SSD
hdfs  storagepolicies  -setStoragePolicy  -path  /all_ssd       -policy  All_SSD
hdfs  storagepolicies  -setStoragePolicy  -path  /lazy_persist  -policy  Lazy_Persist
```

```shell
echo "hot" >> hot.txt ; echo "cold" >> cold.txt ; echo "warm" >> warm.txt ; 
echo "one_ssd" >> one_ssd.txt ; echo "all_ssd" >> all_ssd.txt ; echo "lazy_persist" >> lazy_persist.txt

hdfs dfs -put hot.txt /hot/
hdfs dfs -put cold.txt /cold/
hdfs dfs -put warm.txt /warm/
hdfs dfs -put one_ssd.txt /one_ssd/
hdfs dfs -put all_ssd.txt /all_ssd/
hdfs dfs -put lazy_persist.txt /lazy_persist/
```



### 查看块信息

```shell
hdfs fsck /hot/hot.txt -files -blocks -locations
```

