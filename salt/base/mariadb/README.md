# 变量

- `mariadb_version`  
  指定要安装的 `mariadb` 的版本，默认是 `10.5`

- `mariadb_watch_configs`  
  是否监听配置文件的编号，如果配置文件发生变化，则重启 `mariadb` 服务，默认是 `True`。

- `mariadb_client_configs`  
  影响的配置文件： `/etc/my.cnf.d/mysql-client.cnf`
  客户端工具的配置，格式为`section: {option: value}`，默认配置

  ```text
  'mysql': {
         'default-character-set': 'utf8mb4'
  }
  ```

- `mariadb_server_configs`  
  影响的配置文件： `/etc/my.cnf.d/server.cnf`
  客户端工具的配置，格式为`section: {option: value}`，默认配置

  ```text
  'mariadb': {
        'character-set-server': 'utf8mb4'
   }
  ```
