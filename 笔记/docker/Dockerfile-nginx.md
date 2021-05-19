

```dockerfile
FROM centos:7

LABEL email="15200584536@163.com" \
      version="v1.0"

RUN cd /usr/local \
    && yum -y install wget gcc gcc-c++ automake pcre pcre-devel zlib zlib-devel openssl openssl-devel gperftools \
       perl libxml2 libxml2-devel libxslt libxslt-devel gd gd-devel perl-devel perl-ExtUtils-Embed geoip geoip-devel \
    && wget https://ftp.pcre.org/pub/pcre/pcre-8.32.tar.gz \
    && wget http://www.zlib.net/fossils/zlib-1.2.7.3.tar.gz \
    && wget https://www.openssl.org/source/old/1.0.2/openssl-1.0.2k.tar.gz \
    && wget http://nginx.org/download/nginx-1.18.0.tar.gz \
    && tar -xvf pcre-8.32.tar.gz \
    && tar -xvf zlib-1.2.7.3.tar.gz \
    && tar -xvf openssl-1.0.2k.tar.gz \
    && tar -xvf nginx-1.18.0.tar.gz \
    && cd nginx-1.18.0 \
    && ./configure \
    --prefix=/usr/local/nginx \
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
    --with-openssl=../openssl-1.0.2k \
    && make -j32 \
    && make install \
    && cd .. \
    && rm -rf pcre-8.32.tar.gz \
    && rm -rf zlib-1.2.7.3.tar.gz \
    && rm -rf openssl-1.0.2k.tar.gz \
    && rm -rf nginx-1.18.0.tar.gz

ADD entrypoint.sh /usr/sbin/entrypoint.sh

RUN chmod +x /usr/sbin/entrypoint.sh

WORKDIR /usr/local/nginx

EXPOSE 80

ENTRYPOINT /usr/sbin/entrypoint.sh
```



```shell
#!/bin/sh
/usr/local/nginx/sbin/nginx

exit()
{
    /usr/local/nginx/sbin/nginx stop
}

trap "exit" SIGTERM

flag=1
while [ $flag -ne 0 ];do
    sleep 1;\n\
    flag=`ps -ef | grep nginx | grep -v grep | wc -l`
done;
```

