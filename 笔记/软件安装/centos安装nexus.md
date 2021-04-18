[TOC]

# 一、安装nexus

## 1、下载nexus

```shell
wget -O /opt/software/nexus-3.30.0-01-unix.tar.gz https://www.sonatype.com/product/repository-oss 
```

```shell
cd /opt/software
```

```shell
mkdir -p /opt/module/nexus
```

```shell
tar -zxvf nexus-3.30.0-01-unix.tar.gz -C /opt/module/nexus/
```

## 2、修改配置

```shell
cd /opt/module/nexus/nexus-3.30.0-01/bin
```

```shell
cp nexus.vmoptions nexus.vmoptions.bak
```

```shell
vim nexus.vmoptions
```

添加以下内容

```shell
-Xms1024m
-Xmx1024m
-XX:MaxDirectMemorySize=1024m
```

```shell
vim /opt/module/nexus/nexus-3.30.0-01/etc/nexus-default.properties
```

修改 nexus-context-path

```shell
nexus-context-path=/nexus/
```

## 3、修改用户

```shell
groupadd nexus
```

```shell
useradd nexus -g nexus -s /sbin/nologin -M
```

## 4、配置nginx

```shell
location /nexus {
    proxy_set_header   Host              $host;
    proxy_set_header   X-Real-IP         $remote_addr;
    proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
    proxy_pass         http://127.0.0.1:8081/nexus;
    client_max_body_size 300M;  # 设置单次上传最大为300m
}
```

## 5、开机启动
```shell
vim /lib/systemd/system/nexus.service
```
添加如下内容

```shell
[Unit]
Description=nexus
After=network.target

[Service]
Type=forking
#Environment=RUN_AS_USER=root
User=nexus
Group=nexus
Environment=PATH=/opt/module/java/jdk1.8.0_131/bin:/opt/module/java/jdk1.8.0_131/jre/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:root/bin
ExecStart=/opt/module/nexus/nexus-3.30.0-01/bin/nexus start
ExecReload=/opt/module/module/nexus/nexus-3.30.0-01/bin/nexus restart
ExecStop=/opt/module/nexus/nexus-3.30.0-01/bin/nexus stop
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```
```shell
systemctl daemon-reload             刷新服务    
systemctl start nexus.service       启动服务    
systemctl enable nexus.service      设置开机启动
systemctl disable nexus.service     取消开机启动
```

## 6、登录
```shell
用户名  ：      admin
密码    ：      /opt/module/nexus/sonatype-work/nexus3/admin.password

首次登陆成功后修改密码
```

## 7、已有仓库

仓库名         |类型    | url  |用途
---            | ---    | ---  | ---
maven-releases | hosted | ---  | 存放内部发布的稳定版本
maven-snapshots| hosted | ---  | 存放内部发布的开发版本
maven-central  | proxy  | https://repo1.maven.org/maven2/ | 用于从中央仓库下载
maven-public   | group  | ---  | 方便开发人员使用

## 8、新建仓库

仓库名         | 类型   | url | 用途
---            |---     |---  |---
maven-3rdparty | hosted |---  | 存放无法从公共仓库获得，如Oracle的JDBC驱动
maven-aliyun   | proxy  |http://maven.aliyun.com/nexus/content/groups/public | 用于从阿里仓库下载
maven-jboss    | proxy  |https://repository.jboss.org/maven2/  | 用于从jboss仓库下载
maven-sonatype | proxy  |http://repository.sonatype.org/  | 用于从sonatype仓库下载
maven-google   | proxy  |https://dl.google.com/dl/android/maven2/  | 下载谷歌没有上传到maven中央仓库的依赖

## 9、调整 maven-public
    查找依赖时从上往下找,上面找不到再去下面
    
    maven-3rdparty
    maven-releases
    maven-snapshots
    maven-aliyun
    maven-jboss
    maven-sonatype
    maven-central
    maven-google

## 10、权限配置
    权限配置有特点规则,-view为前台视图权限,-admin为管理视图权限
    
    nx-repository-view-*-*-*                        view视图-所有仓库类型-该类型下所有仓库-所有权限
    nx-repository-view-*-*-add                      view视图-所有仓库类型-该类型下所有仓库-添加权限
    nx-repository-view-*-*-browse                   view视图-所有仓库类型-该类型下所有仓库-搜索权限
    nx-repository-view-*-*-delete                   view视图-所有仓库类型-该类型下所有仓库-删除权限
    nx-repository-view-*-*-edit                     view视图-所有仓库类型-该类型下所有仓库-修改权限
    nx-repository-view-*-*-read                     view视图-所有仓库类型-该类型下所有仓库-查看权限
    
    nx-repository-admin-*-*-*                       admin视图-所有仓库类型-该类型下所有仓库-所有权限
    nx-repository-admin-*-*-add                     admin视图-所有仓库类型-该类型下所有仓库-添加权限
    nx-repository-admin-*-*-browse                  admin视图-所有仓库类型-该类型下所有仓库-搜索权限
    nx-repository-admin-*-*-delete                  admin视图-所有仓库类型-该类型下所有仓库-删除权限
    nx-repository-admin-*-*-edit                    admin视图-所有仓库类型-该类型下所有仓库-修改权限
    nx-repository-admin-*-*-read                    admin视图-所有仓库类型-该类型下所有仓库-查看权限
    
    nx-repository-view-maven2-*-*                   view视图-maven2类型-该类型下所有仓库-所有权限
    nx-repository-view-maven2-*-add                 view视图-maven2类型-该类型下所有仓库-添加权限
    nx-repository-view-maven2-*-browse              view视图-maven2类型-该类型下所有仓库-搜索权限
    nx-repository-view-maven2-*-delete              view视图-maven2类型-该类型下所有仓库-删除权限
    nx-repository-view-maven2-*-edit                view视图-maven2类型-该类型下所有仓库-修改权限
    nx-repository-view-maven2-*-read                view视图-maven2类型-该类型下所有仓库-查看权限
    
    nx-repository-view-maven2-maven-central-*       view视图-maven2类型-maven-central仓库-所有权限
    nx-repository-view-maven2-maven-central-add     view视图-maven2类型-maven-central仓库-添加权限
    nx-repository-view-maven2-maven-central-browse  view视图-maven2类型-maven-central仓库-搜索权限
    nx-repository-view-maven2-maven-central-delete  view视图-maven2类型-maven-central仓库-删除权限
    nx-repository-view-maven2-maven-central-edit    view视图-maven2类型-maven-central仓库-修改权限
    nx-repository-view-maven2-maven-central-read    view视图-maven2类型-maven-central仓库-查看权限
    
    nx-repository-admin-maven2-maven-central-*      admin视图-maven2类型-maven-central仓库-所有权限
    nx-repository-admin-maven2-maven-central-browse admin视图-maven2类型-maven-central仓库-搜索权限
    nx-repository-admin-maven2-maven-central-delete admin视图-maven2类型-maven-central仓库-删除权限
    nx-repository-admin-maven2-maven-central-edit   admin视图-maven2类型-maven-central仓库-修改权限
    nx-repository-admin-maven2-maven-central-read   admin视图-maven2类型-maven-central仓库-查看权限


​	

​	
