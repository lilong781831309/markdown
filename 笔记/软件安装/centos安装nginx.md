[TOC]

# 一、安装nginx

## 1、安装软件和第三方库

```shell
yum -y install gcc gcc-c++ automake pcre pcre-devel zlib zlib-devel openssl openssl-devel
```

```shell
yum -y install perl libxml2 libxml2-devel libxslt libxslt-devel gd gd-devel perl-ExtUtils-Embed geoip geoip-devel
```
## 2、创建nginx用户

```shell
groupadd nginx
```

```shell
useradd nginx -g nginx -s /sbin/nologin -M
```

```shell
-s  表示指定用户所用的shell，此处为/sbin/nologin，表示不登录。
-M  表示不创建用户主目录。
-g  表示指定用户的组名为nginx。
```

## 3、下载对应版本软件包

```shell
wget -O /opt/software/pcre-8.32.tar.gz https://ftp.pcre.org/pub/pcre/pcre-8.32.tar.gz
```

```shell
tar -zxvf pcre-8.32.tar.gz -C /opt/src/
```

```shell
wget -O /opt/software/zlib-1.2.7.3.tar.gz http://www.zlib.net/fossils/zlib-1.2.7.3.tar.gz
```

```shell
tar -zxvf zlib-1.2.7.3.tar.gz -C /opt/src/
```

```shell
wget -O /opt/software/openssl-1.0.2k.tar.gz https://www.openssl.org/source/old/1.0.2/openssl-1.0.2k.tar.gz
```

```shell
tar -zxvf openssl-1.0.2k.tar.gz -C /opt/src/
```

## 4、安装nginx     

```shell
wget -O /opt/software/nginx-1.18.0.tar.gz https://nginx.org/download/nginx-1.18.0.tar.gz
```

```shell
tar -zxvf nginx-1.18.0.tar.gz -C /opt/src/
```

```shell
cd /opt/src/nginx-1.18.0
```

## 5、生成Makefile文件

### 5.1、查看configure参数

```shell
./configure --help
```

### 5.2、参数配置

```shell
./configure --user=nginx --group=nginx \
--prefix=/opt/module/nginx-1.18.0 \
--with-threads \
--with-file-aio \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_xslt_module=dynamic \
--with-http_image_filter_module=dynamic \
--with-http_geoip_module=dynamic \
--with-http_perl_module=dynamic \
--with-http_sub_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_mp4_module  \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_auth_request_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_degradation_module \
--with-http_slice_module \
--with-http_stub_status_module \
--with-mail=dynamic \
--with-mail_ssl_module \
--with-stream=dynamic \
--with-stream_ssl_module \
--with-stream_realip_module \
--with-stream_geoip_module \
--with-stream_ssl_preread_module \
--with-google_perftools_module \
--with-pcre-jit  \
--with-debug \
--with-pcre=../pcre-8.32 \
--with-zlib=../zlib-1.2.7.3 \
--with-openssl=../openssl-1.0.2k
```


​    
​    参数说明:
​    --user                              指定程序运行时的非特权用户
​    --group                             指定程序运行时的非特权用户组
​    --prefix                            安装目录

### 5.3、报错处理  

- **错误1**

  ```shell
  ./configure: error: the HTTP XSLT module requires the libxml2/libxslt libraries.
  ```

  解决方法

  ```shell
  yum -y install libxml2 libxml2-devel
  ```

  ```shell
  yum -y install libxslt-devel
  ```

- **错误2**

  ```shell
  ./configure: error: the HTTP image filter module requires the GD library.
  ```

  解决方法 

  ```shell
  yum -y install gd-devel
  ```

  

- **错误3**

  ```shell
  ./configure: error: perl 5.8.6 or higher is required
  ```

  解决方法:  去掉 ==with perl=path==

  

- **错误4**

  ```shell
  ./configure: error: perl 5.8.6 or higher is required
  ```

  解决方法

  ```shell
  yum -y install perl-devel perl-ExtUtils-Embed
  ```

  

- **错误5**

  ```shell
  ./configure: error: the GeoIP module requires the GeoIP library.
  ```

  解决方法

  ```shell
  yum -y install geoip-devel
  ```

  

- **错误6**

  ```shell
  ./configure: error: the Google perftools module requires the Google perftools library.
  ```

  解决方法

  ```shell
  yum -y install gperftools
  ```

  

## 6、编译安装

```shell
make -j4
```

```shell
make install
```

```shell
make clean
```

```shell
ln -s /opt/module/nginx-1.18.0 /opt/module/nginx
```

## 7、配置文件
```shell
vim /opt/module/nginx/conf/nginx.conf
```

修改如下

```
user  nginx nginx;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;
load_module "modules/ngx_http_geoip_module.so";
load_module "modules/ngx_http_image_filter_module.so";
load_module "modules/ngx_http_perl_module.so";
load_module "modules/ngx_http_xslt_filter_module.so";
load_module "modules/ngx_mail_module.so";
load_module "modules/ngx_stream_module.so";

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    gzip  on;

    server {
        listen       80;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   html;
            index  index.html index.htm;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
}
```
 ## 8、测试

```shell
cd /opt/module/nginx/sbin
```

```shell
./nginx -t
```

 ## 9、开机启动
```shell
vim /lib/systemd/system/nginx.service
```
添加以下内容

```shell
[Unit]
Description=nginx 
After=network.target 
   
[Service] 
Type=forking 
#User=nginx     #使用1024以下端口需以root用户启动
#Group=nginx    #使用1024以下端口需以root用户启动
ExecStart= /opt/module/nginx/sbin/nginx
ExecReload= /opt/module/nginx/sbin/nginx  reload
ExecStop= /opt/module/nginx/sbin/nginx  quit
PrivateTmp= true 
   
[Install] 
WantedBy=multi-user.target
```

相关配置解释

```shell
[Unit]
Description      描述服务
After            描述服务类别

[Service]        服务运行参数的设置
Type=forking     后台运行的形式
User             服务启动用户
Group            服务启动用户组
ExecStart        服务的具体运行命令
ExecReload       服务重启命令
ExecStop         服务停止命令
PrivateTmp=True  表示给服务分配独立的临时空间

[Install]        服务安装的相关设置
WantedBy=multi-user.target  可设置为多用户

注意：[Service]的启动、重启、停止命令全部要求使用绝对路径
```

systemctl 命令使用

```shell
systemctl enable nginx.service          设置开机自启动
systemctl disable nginx.service         停止开机自启动
systemctl start nginx.service　         启动nginx服务
systemctl stop nginx.service　          停止nginx服务
systemctl restart nginx.service　       重启nginx服务
systemctl status nginx.service          查看服务当前状态
systemctl list-units --type=service     查看所有已启动的服务
```

## 10、开启防火墙
```shell
systemctl status firewalld.service      查看firewall服务状态  
systemctl start firewalld.service       启动firewall服务
systemctl restart firewalld.service     重启firewall服务
systemctl stop firewalld.service        停止firewall服务
systemctl enable firewalld.service      设置firewall服务开机自启动
systemctl disable firewalld.service     禁止firewall服务开机启动
```

## 11、开放端口  
```shell
firewall-cmd --state                                                查看firewall状态（关闭后显示notrunning，开启后显示running）
firewall-cmd --reload                                               重启firewall
firewall-cmd --list-all                                             查看防火墙规则
firewall-cmd --zone=public --query-port=80/tcp                      查询端口是否开放
firewall-cmd --list-ports                                           查询开放的端口
firewall-cmd --zone=public --add-port=80/tcp --permanent            开放80端口
firewall-cmd --zone=public --add-port=8080-8085/tcp --permanent     开放8080-8085端口
firewall-cmd --zone=public --remove-port=80/tcp --permanent         移除端口
```