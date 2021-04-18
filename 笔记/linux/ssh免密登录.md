```shell
1、ssh-keygen -t rsa
2、ssh-copy-id host

~/.ssh下文件
    known_hosts	    记录ssh访问过计算机的公钥(public key)
    id_rsa	        生成的私钥
    id_rsa.pub	    生成的公钥
    authorized_keys	存放授权过的无密登录服务器公钥
```

