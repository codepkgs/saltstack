# 说明

用于安装和配置 ipvs。

因为要设置 hash 表的大小，执行完 sls 后，需要重新载入模块或重启系统。

```bash
# 移除模块
lsmod  | grep ^ip_vs | awk '{print $1}' | xargs rmmod

# 载入模块
systemctl restart systemd-modules-load.service
```

# 变量

```text
ipvs_conn_tab_size：设置hash表的大小。如果没有定义pillar数据则设置成24位。
```
