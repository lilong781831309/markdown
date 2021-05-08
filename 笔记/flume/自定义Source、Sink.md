

#### 自定义Source

```java
package org.example.flume.source;

import org.apache.flume.Context;
import org.apache.flume.Event;
import org.apache.flume.EventDeliveryException;
import org.apache.flume.PollableSource;
import org.apache.flume.conf.Configurable;
import org.apache.flume.event.SimpleEvent;
import org.apache.flume.source.AbstractSource;

import java.nio.charset.StandardCharsets;
import java.util.UUID;
import java.util.concurrent.TimeUnit;


public class CustomeSource extends AbstractSource implements Configurable, PollableSource {

    private Long delay;
    private String prefix;

    @Override
    public Status process() throws EventDeliveryException {
        try {
            TimeUnit.MILLISECONDS.sleep(delay);
            Event event = getSomeData();
            getChannelProcessor().processEvent(event);
        } catch (Exception e) {
            e.printStackTrace();
            return Status.BACKOFF;
        }
        return Status.READY;
    }

    private Event getSomeData() {
        String data  = UUID.randomUUID().toString();

        SimpleEvent event = new SimpleEvent();
        event.getHeaders().put("prefix", prefix);
        event.setBody((prefix + data).getBytes(StandardCharsets.UTF_8));

        return event ;
    }

    @Override
    public long getBackOffSleepIncrement() {
        return 0;
    }

    @Override
    public long getMaxBackOffSleepInterval() {
        return 0;
    }

    @Override
    public void configure(Context context) {
        delay = context.getLong("delay", 0L);
        prefix = context.getString("prefix", "log-");
    }

}
```



#### 自定义Sink

```java
package org.example.flume.sink;

import org.apache.flume.Channel;
import org.apache.flume.Context;
import org.apache.flume.Event;
import org.apache.flume.EventDeliveryException;
import org.apache.flume.Transaction;
import org.apache.flume.conf.Configurable;
import org.apache.flume.sink.AbstractSink;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.nio.charset.StandardCharsets;

public class CustomeSink extends AbstractSink implements Configurable {

    private static final Logger logger = LoggerFactory.getLogger(CustomeSink.class);

    @Override
    public Status process() throws EventDeliveryException {
        Channel ch = getChannel();
        Transaction txn = ch.getTransaction();
        txn.begin();
        try {
            Event event = ch.take();
            storeSomeData(event);
            txn.commit();
            return Status.READY;
        } catch (Throwable t) {
            txn.rollback();
            return Status.BACKOFF;
        } finally{
            txn.close();
        }
    }

    private void storeSomeData(Event event) {
        String printData  = event.getHeaders() + " ::: "+ new String(event.getBody(), StandardCharsets.UTF_8);
        logger.info(printData);
    }

    @Override
    public void configure(Context context) {

    }

}
```



#### 配置

custome-memory-custome.conf

```shell
#Named
a1.sources = r1
a1.channels = c1
a1.sinks = k1 

#Source
a1.sources.r1.type = org.example.flume.source.CustomeSource
a1.sources.r1.prefix = log--
a1.sources.r1.delay = 500

#Channel
a1.channels.c1.type = memory
a1.channels.c1.capacity = 10000
a1.channels.c1.transactionCapacity = 100

#Sink
a1.sinks.k1.type = org.example.flume.sink.CustomeSink

#Bind
a1.sources.r1.channels = c1 
a1.sinks.k1.channel = c1 
```



#### 启动

```shell
flume-ng agent --conf $FLUME_HOME/conf --conf-file $FLUME_HOME/conf-file/custome-memory-custome.conf --name a1 -Dflume.root.logger=INFO,console
```

