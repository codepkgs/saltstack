nginx_log_dir: "/data/logs/nginx"
nginx_runtime_user: "nginx"

{# 是否启用nginx http 功能 #}
nginx_http_enable: True

{# 是否启用ssl #}
nginx_ssl_enable: True

{# SSL证书目录 #}
nginx_ssl_certs_dir: "/etc/nginx/certs"

{# SSL默认证书，用于默认的 https 配置 #}
nginx_ssl_default_cert: "_.fdisk.cc.crt"
nginx_ssl_default_cert_key: "_.fdisk.cc.key"

{# 启用的证书，需要使用通配符匹配key和crt，如果第一个元素为 "all"，则表示启用certs下的所有证书 #}
{# 如果没有定义该变量，则也表示启用certs下的所有证书 #}
nginx_ssl_enable_certs:
  - "all"

{# 是否要启用 nginx extra config #}
nginx_extra_config_enable: True

{# 启用的额外的配置，支持通配。如果第一个元素为 "all"，则表示启用所有配置 #}
{# 如果没有定义该变量，则表示启用所有配置(只会启用以.conf结尾的配置) #}
nginx_extra_enable_configs:
  - "all"

{# 是否要复制其他的配置到 /etc/nginx/ 目录下 #}
nginx_other_config_enable: True

{# 要复制的其他的配置，支持通配。如果第一个元素为 "all"，则表示启用所有配置 #}
{# 如果没有定义该变量，则表示启用所有配置(只会启用以.conf结尾的配置) #}
nginx_other_enable_configs:
  - "all"

{# 是否启用nginx stream 功能 #}
nginx_stream_enable: True

{# 启用的额外的stream 的配置，支持通配。如果第一个元素为 "all"，则表示启用所有配置 #}
{# 如果没有定义该变量，则表示启用所有配置(只会启用以.conf结尾的配置) #}
nginx_stream_enable_configs:
  - "all"