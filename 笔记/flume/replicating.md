#### 功能

实时监控目录下的新文件,同时将内容记录到文件和上传到HDFS中



#### 配置

taildir-memory-avro.conf

```shell
# Name
a1.sources = r1
a1.sinks = k1 k2
a1.channels = c1 c2

# Source
a1.sources.r1.type = TAILDIR
a1.sources.r1.filegroups = g1 g2
a1.sources.r1.filegroups.g1 = /home/lilong/flume/replicating/taildir/.*\.txt$
a1.sources.r1.filegroups.g2 = /home/lilong/flume/replicating/taildir/.*\.log$
a1.sources.r1.positionFile = /opt/module/flume/conf-file/replicating/taildir_position.json
a1.sources.r1.selector.type = replicating

# Sink
# sink1
a1.sinks.k1.type = avro
a1.sinks.k1.hostname = hadoop10
a1.sinks.k1.port = 8888
# sink2
a1.sinks.k2.type = avro
a1.sinks.k2.hostname = hadoop10
a1.sinks.k2.port = 9999

# Channel
# channel1
a1.channels.c1.type = memory
a1.channels.c1.capacity = 1000
a1.channels.c1.transactionCapacity = 100

# channel2
a1.channels.c2.type = memory
a1.channels.c2.capacity = 1000
a1.channels.c2.transactionCapacity = 100

# Bind
a1.sources.r1.channels = c1 c2
a1.sinks.k1.channel = c1
a1.sinks.k2.channel = c2
```



avro-memory-hdfs.conf

```shell
# Name
a1.sources = r1
a1.sinks = k1
a1.channels = c1

# Source
a1.sources.r1.type = avro
a1.sources.r1.bind = hadoop10
a1.sources.r1.port = 8888

# Sink
a1.sinks.k1.type = hdfs
a1.sinks.k1.hdfs.path = hdfs://hadoopcluster/flume/replicating/%Y-%m-%d/%H/%M
a1.sinks.k1.hdfs.filePrefix = log
a1.sinks.k1.hdfs.inUseSuffix = .tmp
a1.sinks.k1.hdfs.round = true
a1.sinks.k1.hdfs.roundValue = 1
a1.sinks.k1.hdfs.roundUnit = minute
a1.sinks.k1.hdfs.useLocalTimeStamp = true
a1.sinks.k1.hdfs.batchSize = 5
a1.sinks.k1.hdfs.fileType = DataStream
a1.sinks.k1.hdfs.rollInterval = 60
a1.sinks.k1.hdfs.rollSize = 134217700
a1.sinks.k1.hdfs.rollCount = 0

# channel
a1.channels.c1.type = memory
a1.channels.c1.capacity = 1000
a1.channels.c1.transactionCapacity = 100

# Bind
a1.sources.r1.channels = c1
a1.sinks.k1.channel = c1
```



avro-memory-file_roll.conf

```shell
# Name
a1.sources = r1
a1.sinks = k1
a1.channels = c1

# Source
a1.sources.r1.type = avro
a1.sources.r1.bind = hadoop10
a1.sources.r1.port = 9999

# Sink
a1.sinks.k1.type = file_roll
a1.sinks.k1.sink.directory = /home/lilong/flume/replicating/file_roll

# channel
a1.channels.c1.type = memory
a1.channels.c1.capacity = 1000
a1.channels.c1.transactionCapacity = 100

# Bind
a1.sources.r1.channels = c1
a1.sinks.k1.channel = c1
```



#### 启动

```shell
flume-ng agent --conf $FLUME_HOME/conf --conf-file $FLUME_HOME/conf-file/replicating/avro-memory-hdfs.conf --name a1 -Dflume.root.logger=INFO,console

flume-ng agent --conf $FLUME_HOME/conf --conf-file $FLUME_HOME/conf-file/replicating/avro-memory-file_roll.conf --name a1 -Dflume.root.logger=INFO,console

flume-ng agent --conf $FLUME_HOME/conf --conf-file $FLUME_HOME/conf-file/replicating/taildir-memory-avro.conf --name a1 -Dflume.root.logger=INFO,console
```

