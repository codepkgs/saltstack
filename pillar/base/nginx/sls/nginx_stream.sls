nginx_log_dir: "/data/logs/nginx"
nginx_runtime_user: "nginx"

nginx_http_enable: False

nginx_ssl_enable: False
nginx_ssl_certs_dir: "/etc/nginx/certs"
nginx_ssl_default_cert: "_.fdisk.cc.crt"
nginx_ssl_default_cert_key: "_.fdisk.cc.key"
nginx_ssl_enable_certs:
  - "all"

nginx_extra_config_enable: False
nginx_extra_enable_configs:
  - "all"

nginx_other_config_enable: True
nginx_other_enable_configs:
  - "all"

nginx_stream_enable: True
nginx_stream_enable_configs:
  - "all"