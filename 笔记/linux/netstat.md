```shell
语法：
    netstat [选项]

参数:
    -a或--all           ：显示所有连线中的Socket
    -t或--tcp           ：显示TCP传输协议的连线状况
    -u或--udp           ：显示UDP传输协议的连线状况
    -l或--listening     ：显示监控中的服务器的Socket
    -p或--programs      ：显示正在使用Socket的程序识别码和程序名称
    -c或--continuous    ：持续列出网络状态
    -n或--numeric       ：直接使用ip地址，而不通过域名服务器
    -r或--route         ：显示路由器信息,路由表
    -e或--extend        ：显示拓展信息,如uid等
    -s或--statistice    ：显示网络工作信息统计表
    -g或--groups        ：显示多重广播功能群组组员名单
    -i或--interfaces    ：显示网络界面信息表单
    -v或--verbose       ：显示指令执行过程
    -w或--raw           ：显示RAW传输协议的连线状况
    -x或--unix          ：此参数的效果和指定"-A unix"参数相
    
常用:
    1)、找出程序运行的端口
    # netstat -ap | grep 'nginx'
    
    2)、查看运行的进程和监听的端口
    # netstat -nltp  
    
    3)、查看连接某服务端口最多的的IP地址
    # netstat -ant|grep "121.5.152.236"|awk '{print $5}'|awk -F: '{print $1}'|sort -nr|uniq –c
    
    4)、统计连接数数量
    # netstat -nat |awk '{print $6}'|sort|uniq -c
    
    5)、统计连接数数量(排序)
    #netstat -nat |awk '{print $6}'|sort|uniq -c|sort -rn
    
    6)、显示内核路由信息
    # netstat -rn
```
