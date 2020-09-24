# 说明

## 配置 mariadb 服务器端

```ini
# 文件 /etc/my.cnf.d/server.cnf

[mariadb]
character-set-server = utf8mb4
innodb_file_per_table = ON
innodb_file_format = Barracuda
innodb_large_prefix = ON
```

## 创建数据库

```sql
CREATE DATABASE IF NOT EXISTS gogs CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
```

## Nginx 配置

```nginx
upstream gogs {
    keepalive   32;
    server      127.0.0.1:6000;
}
server {
    listen      80;
    server_name gogs.fdisk.cc;

    rewrite ^(.*)$ https://$host$1 permanent;
}

server {
    listen      443 ssl;
    server_name gogs.fdisk.cc;

    access_log  /data/logs/nginx/gogs.fdisk.cc_error.log main;
    error_log   /data/logs/nginx/gogs.fdisk.cc_error.log notice;

    ssl_certificate        /etc/nginx/certs/_.fdisk.cc.crt;
    ssl_certificate_key    /etc/nginx/certs/_.fdisk.cc.key;

    location / {
        proxy_http_version  1.1;
        proxy_set_header    Connection "";
        proxy_set_header    Host $host:$server_port;
        proxy_set_header    X-Real-IP $remote_addr;
        proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header    X-Forwarded-Proto $scheme;
        proxy_pass          http://gogs;
    }
}
```
