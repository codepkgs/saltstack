# 说明

## 变量

- `gogs_download_url`  
   指定 `gogs` 下载的 url，默认是 `https://dl.gogs.io/0.12.1/gogs_0.12.1_linux_amd64.tar.gz`

- `gogs_update_config`  
   当用户自定义的 `custom/config/app.ini` 文件已经存在时，是否允许更新该文件。默认是 `False`。  
   `gogs` 安装完成后，会更新该文件的配置。

- `gogs_db_host`  
   连接本地数据库的地址。默认 `localhost`

- `gogs_db_port`  
   数据库的端口，默认 `3306`

- `gogs_db_user`  
   连接数据库的用户，默认是 `root`

- `gogs_db_pass`  
   连接数据库的密码，默认为空。

- `gogs_db_socket`  
   使用 socket 连接，默认是 `/var/lib/mysql/mysql.sock`

- `gogs_db_charset`  
   指定连接使用的字符集编码。默认是 `utf8mb4`

- `gogs_user_password`  
   创建 gogs 数据库时，`gogs` 用户的密码。默认是 `gogs`

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

- 创建数据库

  ```sql
  CREATE DATABASE IF NOT EXISTS gogs CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
  ```

- 授权

  ```sql
  GRANT ALL PRIVILEGES ON gogs.* TO 'gogs'@'localhost' IDENTIFIED BY 'gogs';
  FLUSH PRIVILEGES;
  ```

## Nginx 配置

```nginx
upstream gogs {
    keepalive   32;
    server      127.0.0.1:3000;
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
