

#### 1、在官网下载MySQL安装包

[下载地址](https://dev.mysql.com/downloads/mysql/)

```shell
Select Operating System:	
		Red Hat Enterprise Linux / Oracle Linux
Select OS Version:			
		Red Hat Enterprise Linux 7 / Oracle Linux 7 (x86, 64-bit)
#安装包
    Compressed TAR Archive
    (mysql-8.0.24-el7-x86_64.tar.gz)
```



#### 2、查看是否安装mariadb

` sudo  rpm -qa | grep mariadb`



#### 3、卸载mariadb

`sudo rpm -e --nodeps  mariadb-libs`



#### 4、安装MySQL依赖包 libaio

`sudo yum install libaio`



#### 5、解压

```shell
tar -zxvf mysql-8.0.24-el7-x86_64.tar.gz -C /opt/module/
cd /opt/module/
ln -s mysql-8.0.24-el7-x86_64 mysql
```



#### 6、添加mysql用户和组

```shell
sudo groupadd mysql
sudo useradd mysql -g mysql -s /sbin/false
#sudo useradd mysql -g mysql -s /sbin/nologin -M
sudo chown -R mysql:mysql mysql
```



#### 7、配置文件

默认配置文件路径

```sql
/etc/my.cnf /etc/mysql/my.cnf /usr/local/mysql/etc/my.cnf /opt/module/mysql/my.cnf ~/.my.cnf
```



`sudo vim /etc/my.cnf`

内容如下

```shell
[client]
# 设置mysql客户端连接服务端时默认使用的端口
port=3306
default-character-set=utf8mb4

[mysql]
# 设置mysql客户端默认字符集
default-character-set=utf8mb4

[mysqld]
#启动后使用mysql用户运行
#user=mysql
# 设置3306端口
port=3306
# 设置mysql的安装目录
basedir=/opt/module/mysql
# 设置mysql数据库的数据的存放目录
datadir=/opt/module/mysql/data
socket=/opt/module/mysql/mysql.sock
# 允许最大连接数
max_connections=200
# 允许连接失败的次数。这是为了防止有人从该主机试图攻击数据库系统
max_connect_errors=10
# 服务端使用的字符集默认为UTF8
character-set-server=utf8mb4

collation-server=utf8mb4_unicode_ci
# 创建新表时将使用的默认存储引擎
default-storage-engine=INNODB

# 默认使用mysql_native_password插件认证
default_authentication_plugin=mysql_native_password
```



#### 8、初始化

```shell
cd bin
sudo ./mysqld --initialize --console
#记录初始密码
```



#### 9、添加服务

`sudo vim /lib/systemd/system/mysql.service`

内容如下

```shell
[Unit]
Description=mysql
After=network.target

[Service]
Type=forking
User=mysql
Group=mysql
ExecStart=/opt/module/mysql/support-files/mysql.server start
ExecReload=/opt/module/mysql/support-files/mysql.server restart
ExecStop=/opt/module/mysql/support-files/mysql.server stop
PrivateTmp=true 

[Install]
WantedBy=multi-user.target
```



#### 10、启动服务、开机启动

```shell
sudo systemctl daemon-reload                 刷新服务  
sudo systemctl enable mysql.service          设置开机自启动
sudo systemctl disable mysql.service         停止开机自启动
sudo systemctl start mysql.service　         启动mysql服务
sudo systemctl stop mysql.service　          停止mysql服务
sudo systemctl restart mysql.service　       重启mysql服务
sudo systemctl status mysql.service          查看服务当前状态
sudo systemctl list-units --type=service     查看所有已启动的服务
```

查看运行状态

`ps -ef|grep mysql`



#### 11、添加环境变量

`sudo vim /etc/profile.d/mysql.sh`

```shell
export MYSQL_HOME=/opt/module/mysql
export PATH=$MYSQL_HOME/bin:$PATH
```

`source /etc/profile`



#### 12、修改密码

```shell
mysql -u root -p
#输入初始密码
#修改密码
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'xxxxxx';
```



#### 13、错误处理

- ./mysqld: error while loading shared libraries: libnuma.so.1: cannot open shared object file: No such file or directory

  `sudo yum -y install numactl`

- Can’t connect to local MySQL server through socket ‘/tmp/mysql.sock

  `ln -s /opt/module/mysql/mysql.sock /tmp/mysql.sock`

  













