# 创建数据库和表

- 创建数据库

  ```sql
  mysql> create database openvpn default charset utf8;
  mysql> grant all privileges on openvpn.* to 'openvpn'@'localhost' identified by 'openvpn';
  mysql> flush privileges;
  ```

* 创建表结构

  ```sql
  mysql> use openvpn;
  mysql> create table vpnuser (
      username char(32) not null,
      password varchar(128) not null,
      active int(10) not null default 1,
      primary key (username) );
  ```
