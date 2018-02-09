#!/usr/bin/sh

#定义脚本编译根路径
path="/home/shenzhiming/nginx"

#编译参数设置
./configure --prefix=$path \
    --conf-path=$path/conf/nginx.conf \
    --pid-path=$path/nginx.pid \
    --lock-path=$path/lock/nginx.lock \
    --error-log-path=$path/logs/error.log \
    --http-log-path=$path/logs/access.log \
    --with-http_gzip_static_module \
    --http-client-body-temp-path=$path/client \
    --http-proxy-temp-path=$path/proxy \
    --http-fastcgi-temp-path=$path/fastcgi \
    --http-uwsgi-temp-path=$path/uwsgi \
    --http-scgi-temp-path=$path/scgi \
    --with-http_stub_status_module \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-pcre=$path/../data/pcre-8.38 \
    --with-zlib=$path/../data/zlib-1.2.11 \
    --with-threads \
    --with-file-aio \
    --with-http_realip_module

#编译安装
make & make install
