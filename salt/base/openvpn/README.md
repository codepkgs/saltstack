# openvpn 连接数据库的变量

建库和建表语句参考 `scripts/db.md`。

`openvpn_db_host`：定义 openvpn 使用的数据库的 host，默认是 `localhost`  
`openvpn_db_port`：定义 openvpn 使用的数据库的 port，默认是 `3306`  
`openvpn_db_user`：定义 openvpn 连接数据库时使用的用户，默认是 `openvpn`  
`openvpn_db_pass`：定义 openvpn 连接数据库时使用的密码，默认是 `openvpn`  
`openvpn_db_name`：定义 openvpn 使用的数据库名，默认是 `openvpn`  
`openvpn_table_name`：定义 openvpn 使用的表名，默认是 `openvpn`

# 定义 `pillar` 数据

`openvpn_network`：必须。指定 openvpn server 给客户端分配的 IP 地址段和掩码，使用空格隔开。如 172.16.255.0 255.255.255.0  
`openvpn_push_routers`：必选。定义要 push 的路由。 如果没有定义，则不 push 任何路由。可以定义多个。  
`openvpn_push_dns`：可选。定义要 push 的 DNS。如果没有定义，则不 push 任何 DNS。

- `pillar` 数据示例

  ```text
  openvpn_network: "172.16.255.0 255.255.255.0"
  openvpn_push_routers:
    - comment: aliyun_vpc_1
      network: 172.16.0.0 255.240.0.0
    - comment: aliyun_vpc_2
      network: 192.168.0.0 255.255.0.0

  openvpn_push_dns:
    - 223.5.5.5
    - 223.6.6.6
  ```
