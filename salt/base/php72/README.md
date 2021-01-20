# 说明

运行 php-fpm 的用户是 www。
日志路径为：/data/logs/php-fpm 和 /data/logs/php-seaslog

# 支持的 pillar 数据

```text
memory_limit：默认256M
upload_max_filesize：支持的上传文件的最大大小。默认为256M
post_max_size：默认256M

pm.max_children：默认配置的pm为dynamic，该值默认为cpu核心数的8倍。
pm.max_spare_servers：和 pm.max_children 一致
```
