

### 启用ACL

#### hdfs-site.xml

```xml
<!-- ACL权限控制 -->
<property>
    <name>dfs.namenode.acls.enabled</name>
    <value>true</value>
</property>
```



### ACL操作

```shell
hadoop fs -getfacl [-R] <path>
显示文件和目录的访问控制列表（ACL）。如果目录具有默认ACL，则getfacl还将显示默认ACL。

hadoop fs [generic options] -setfacl [-R] [{-b|-k} {-m|-x <acl_spec>} <path>]|[--set <acl_spec> <path>]
设置文件和目录的访问控制列表（ACL）。

hadoop fs -ls <args>
ls的输出将在带有ACL的任何文件或目录的权限字符串后附加一个'+'字符。
```



#### 查看ACL权限

hadoop fs -getfacl path

```shell
[lilong@hadoop10 hadoop]$ hadoop fs -getfacl /test
# file: /test
# owner: lilong
# group: supergroup
user::rwx
group::r-x
other::r-x
```



#### 使用ACL给用户单独设置权限       

hadoop fs -setfacl -m user:==username==:rwx path

```shell
[lilong@hadoop10 hadoop]$ hadoop fs -setfacl -m user:test:rwx /test
[lilong@hadoop10 hadoop]$ hadoop fs -getfacl /test
# file: /test
# owner: lilong
# group: supergroup
user::rwx
user:test:rwx
group::r-x
mask::rwx
other::r-x
```

**测试**

```shell
[test@hadoop10 ~]$ /opt/module/hadoop-3.1.4/bin/hadoop fs -put test.txt /test/
[test@hadoop10 ~]$ 

[test2@hadoop10 ~]$ /opt/module/hadoop-3.1.4/bin/hadoop fs -put test2.txt /test/
put: Permission denied: user=test2, access=WRITE, inode="/test":lilong:supergroup:drwxrwxr-x
[test2@hadoop10 ~]$ 

[test3@hadoop10 ~]$ /opt/module/hadoop-3.1.4/bin/hadoop fs -put test3.txt /test/
put: Permission denied: user=test3, access=WRITE, inode="/test":lilong:supergroup:drwxrwxr-x
[test3@hadoop10 ~]$ 
```



#### 使用ACL给组单独设置权限   

hadoop fs -setfacl -m group:==groupname==:rwx path

```shell
[lilong@hadoop10 hadoop]$ hadoop fs -setfacl -m group:test:rwx /test
[lilong@hadoop10 hadoop]$ hadoop fs -getfacl /test
# file: /test
# owner: lilong
# group: supergroup
user::rwx
user:test:rwx
group::r-x
group:test:rwx
mask::rwx
other::r-x
```

**测试**

```shell
usermod -a -G test test2
/opt/module/hadoop-3.1.4/bin/hadoop fs -put test2.txt /test/
[test2@hadoop10 ~]$ /opt/module/hadoop-3.1.4/bin/hadoop fs -put test2.txt /test/
[test2@hadoop10 ~]$ 
```



#### ACL权限显示 

附加一个'+'字符

```shell
[lilong@hadoop10 hadoop]$ hadoop fs -ls /
Found 10 items
drwxr-xr-x   - lilong supergroup          0 2021-04-26 19:35 /all_ssd
drwxr-xr-x   - lilong supergroup          0 2021-04-26 19:35 /cold
drwxr-xr-x   - lilong supergroup          0 2021-04-26 19:35 /hot
drwxr-xr-x   - lilong supergroup          0 2021-04-26 19:35 /lazy_persist
drwxr-xr-x   - lilong supergroup          0 2021-04-26 19:35 /one_ssd
drwxr-xr-x   - lilong supergroup          0 2021-04-27 16:40 /smail
drwxr-xr-x   - lilong supergroup          0 2021-04-27 00:28 /system
drwxrwxr-x+  - lilong supergroup          0 2021-04-27 18:00 /test
drwxrwx---   - lilong supergroup          0 2021-04-26 21:09 /tmp
drwxr-xr-x   - lilong supergroup          0 2021-04-26 19:35 /warm
```



#### 删除指定的ACL条目

hadoop fs -setfacl -x user:==username== /path

```shell
[lilong@hadoop10 hadoop]$ hadoop fs -setfacl -x user:test /test
[lilong@hadoop10 hadoop]$ hadoop fs -getfacl /test
# file: /test
# owner: lilong
# group: supergroup
user::rwx
group::r-x
group:test:rwx
mask::rwx
other::r-x
```



#### 删除所有ACL条目

**==保留用户，组和其他条目以与权限位兼容==**

hadoop fs -setfacl -b path

```shell
[lilong@hadoop10 hadoop]$ hadoop fs -setfacl -b /test
[lilong@hadoop10 hadoop]$ hadoop fs -getfacl /test
# file: /test
# owner: lilong
# group: supergroup
user::rwx
group::r-x
other::r-x
```



#### 设置默认的ACl权限

以后在该目录中新建文件或者子目录时，新建的文件/目录的ACL权限都是之前设置的default ACLs

hadoop fs -setfacl -m default:user:==username==:rwx path

```shell
[lilong@hadoop10 hadoop]$ hadoop fs -setfacl -m default:user:test:rwx /test
[lilong@hadoop10 hadoop]$ hadoop fs -getfacl /test
# file: /test
# owner: lilong
# group: supergroup
user::rwx
group::r-x
other::r-x
default:user::rwx
default:user:test:rwx
default:group::r-x
default:mask::rwx
default:other::r-x
```

```shell
[lilong@hadoop10 hadoop]$ hadoop fs -mkdir /test/sub
[lilong@hadoop10 hadoop]$ hadoop fs -getfacl /test/sub
# file: /test/sub
# owner: lilong
# group: supergroup
user::rwx
user:test:rwx
group::r-x
mask::rwx
other::r-x
default:user::rwx
default:user:test:rwx
default:group::r-x
default:mask::rwx
default:other::r-x
```



#### 删除默认ACL权限

hadoop fs -setfacl -k path

```shell
[lilong@hadoop10 hadoop]$ hadoop fs -setfacl -k /test
[lilong@hadoop10 hadoop]$ hadoop fs -getfacl /test
# file: /test
# owner: lilong
# group: supergroup
user::rwx
group::r-x
other::r-x
```



#### 完全替换ACL

==丢弃所有现有条目。 acl_spec必须包含用户，组和其他条目，以便与权限位兼容==

hadoop fs -setfacl --set user::==rwx==,group::==rwx==,other::==rwx==,user:test:==rwx==  path

```shell
[lilong@hadoop10 hadoop]$ hadoop fs -setfacl --set user::rw-,group::r--,other::r--,user:test:rw-   /test
[lilong@hadoop10 hadoop]$ hadoop fs -getfacl /test
# file: /test
# owner: lilong
# group: supergroup
user::rw-
user:test:rw-
group::r--
mask::rw-
other::r--
```