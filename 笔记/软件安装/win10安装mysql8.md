



[下载地址](https://dev.mysql.com/downloads/mysql/)



#### 解压到安装目录

D:\develop\mysql\mysql-8.0.11-winx64



#### 配置环境变量

- 添加环境变量  

  ```shell
  MYSQL_HOME=D:\develop\mysql\mysql-8.0.11-winx64
  ```

- 修改Path,最前面添加

  ```shell
  %MYSQL_HOME%\bin;
  ```

  

#### 安装目录下新建 my.ini

```shell
[client]
# 设置mysql客户端连接服务端时默认使用的端口
port=3306
default-character-set=utf8mb4

[mysql]
# 设置mysql客户端默认字符集
default-character-set=utf8mb4

[mysqld]
# 设置3306端口
port=3306
# 设置mysql的安装目录
basedir=D:\develop\mysql\mysql-8.0.11-winx64
# 设置mysql数据库的数据的存放目录
datadir=D:\develop\mysql\mysql-8.0.11-winx64\data
# 允许最大连接数
max_connections=200
# 允许连接失败的次数。这是为了防止有人从该主机试图攻击数据库系统
max_connect_errors=10
# 服务端使用的字符集默认为UTF8
character-set-server=utf8mb4

collation-server=utf8mb4_unicode_ci
# 创建新表时将使用的默认存储引擎
default-storage-engine=INNODB
```



#### 以管理员的身份打开cmd

- 跳转路径到 D:\develop\mysql\mysql-8.0.11-winx64\bin
- 初始化命令   `mysqld --initialize --user=mysql --console`   ==记下初始密码==
- 添加服务       ` mysqld -install`
- 启动服务       `net start mysql`
- 登录               `mysql -u root -p`                 ==输入初始密码==
- 修改密码       `ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123456';`
