# 变量

- memcached_filename  
  可选。memcached 源文件名，默认是 `memcached-1.6.6.tar.gz`

- memcached_install_prefix  
  可选。memcached 安装路径，默认是 `/usr/local/memcached`

- memcached_runtime_user  
  可选。运行 memcached 服务的用户，默认是 `memcached`

- memcached_instances  
  可选。定义要运行的 memcache 实例信息，可以定义多个实例。服务只支持 RHEL7

  定义单个实例

  ```text
  默认值：
  [
    {
        "memcached_instance_name": "memcached",
        "memcached_runtime_user": memcached_runtime_user,
        "memcached_runtime_port": 11211,
        "memcached_maxmemory": 1024,
        "memcached_maxconn": 1024,
        "memcached_options": "",
        "memcached_status": "running"
    }
  ]

  参数说明：
  memcached_instance_name：指定 memcached 实例名。
  memcached_runtime_user：指定 memcached 运行时的用户。
  memcached_runtime_port：指定 memcached 运行时的端口（TCP端口）。
  memcached_maxmemory：指定 memcached 最大允许使用的内存。
  memcached_maxconn：指定实例的最大连接数。
  memcached_options：指定实例的运行时的其他参数。
  memcached_status：指定实例的状态，有 running 和 stop。
  ```

  定义多个实例

  ```text
  [
    {
        "memcached_instance_name": "memcached",
        "memcached_runtime_user": "memcached",
        "memcached_runtime_port": 11211,
        "memcached_maxmemory": 1024,
        "memcached_maxconn": 1024,
        "memcached_options": "",
        "memcached_status": "running"
    },
    {
        "memcached_instance_name": "memcached2",
        "memcached_runtime_user": "memcached",
        "memcached_runtime_port": 11212,
        "memcached_maxmemory": 1024,
        "memcached_maxconn": 1024,
        "memcached_options": "",
        "memcached_status": "stop"
    }
  ]
  ```
