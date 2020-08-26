{# nginx runtime user #}
{% if pillar['nginx_runtime_user'] is defined %}
    {% set nginx_runtime_user = pillar['nginx_runtime_user'] %}
{% else %}
    {% set nginx_runtime_user = "nginx" %}
{% endif %}

{# 默认创建 nginx_parent_log_dir #}
{% set create_nginx_parent_log_dir = True %}

{# nginx log directory #}
{% if pillar['nginx_log_dir'] is defined and pillar['nginx_log_dir'] %}
    {% set nginx_log_dir = pillar['nginx_log_dir'] %}
    {# nginx parent log directory #}
    {% if nginx_log_dir.split('/')[:-1] | length != 1 %}
        {% set nginx_parent_log_dir = '/'.join(nginx_log_dir.split('/')[:-1]) %}
    {% else %}
        {% set nginx_parent_log_dir = nginx_log_dir %}
        {% set create_nginx_parent_log_dir = False %}
    {% endif %}
{% else %}
    {% set nginx_log_dir = "/data/logs/nginx" %}
    {% set nginx_parent_log_dir = "/data/logs" %}
{% endif %}

{# nginx ssl #}
{% if pillar['nginx_ssl_enable'] is defined and pillar['nginx_ssl_enable'] %}
    {% set nginx_ssl_enable = True %}
{% else %}
    {% set nginx_ssl_enable = False %}
{% endif %}

{# nginx certs directory #}
{% if pillar['nginx_ssl_certs_dir'] is defined and pillar['nginx_ssl_certs_dir'] %}
    {% set nginx_ssl_certs_dir = pillar['nginx_ssl_certs_dir'] %}
{% else %}
    {% set nginx_ssl_certs_dir = "/etc/nginx/certs" %}
{% endif %}

{# 配置要启用的证书 #}
{% if pillar['nginx_ssl_enable_certs'] is defined and pillar['nginx_ssl_enable_certs'][0] | lower == 'all' %}
    {% set nginx_ssl_enable_certs = ['all'] %}
{% else %}
    {% set nginx_ssl_enable_certs = pillar['nginx_ssl_enable_certs'] %}
{% endif %}

{# 是否要启用额外的配置 #}
{% if pillar['nginx_extra_config_enable'] is defined and pillar['nginx_extra_config_enable'] %}
    {% set nginx_extra_config_enable = True %}
{% else %}
    {% set nginx_extra_config_enable = False %}
{% endif %}

{# 配置要启用的额外的配置 #}
{% if pillar['nginx_extra_enable_configs'] is defined and pillar['nginx_extra_enable_configs'][0] | lower == 'all' %}
    {% set nginx_extra_enable_configs = ['all'] %}
{% else %}
    {% set nginx_extra_enable_configs = pillar['nginx_extra_enable_configs'] %}
{% endif %}

{# 是否启用nginx stream #}
{% if pillar['nginx_stream_enable'] is defined and pillar['nginx_stream_enable'] %}
    {% set nginx_stream_enable = True %}
{% else %}
    {% set nginx_stream_enable = False %}
{% endif %}

{# 配置要启用的额外的stream配置 #}
{% if pillar['nginx_stream_enable_configs'] is defined and pillar['nginx_stream_enable_configs'][0] | lower == 'all' %}
    {% set nginx_stream_enable_configs = ['all'] %}
{% else %}
    {% set nginx_stream_enable_configs = pillar['nginx_stream_enable_configs'] %}
{% endif %}

nginx_packages:
  pkg.installed:
    - pkgs:
      - nginx
      - nginx-mod-stream

nginx_runtime_user:
  user.present:
    - name: {{ nginx_runtime_user }}
    - shell: /sbin/nologin
    - createhome: False
    - system: True

{% if create_nginx_parent_log_dir %}
nginx_parent_log_dir:
  file.directory:
    - name: {{ nginx_parent_log_dir }}
    - user: root
    - group: root
    - dir_mode: 755
    - mkdirs: True
{% endif %}

nginx_log_dir:
  file.directory:
    - name: {{ nginx_log_dir }}
    - user: {{ nginx_runtime_user }}
    - group: {{ nginx_runtime_user }}
    - makedirs: True
    - dir_mode: 755
    - require:
      - user: nginx_runtime_user

{% if nginx_ssl_enable %}
nginx_certs_config:
  file.recurse:
    - name: {{ nginx_ssl_certs_dir }}
    - source: salt://nginx/files/certs
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - clean: True
    {% if nginx_ssl_enable_certs[0] | lower != 'all' %}
    - include_pat: {{ nginx_ssl_enable_certs }}
    {% endif %}
{% endif %}

nginx_config:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://nginx/templates/nginx.conf.j2
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: nginx_packages
      - user: nginx_runtime_user
      - file: nginx_log_dir
      {% if nginx_ssl_enable %}
      - file: nginx_certs_config
      {% endif %}

{% if nginx_stream_enable %}
nginx_stream_dir:
  file.directory:
    - name: /etc/nginx/stream.d
    - user: root
    - group: root
    - makedirs: True
    - dir_mode: 755

nginx_stream_config:
  file.recurse:
    - name: /etc/nginx/stream.d
    - source: salt://nginx/files/stream.d
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - clean: True
    {% if nginx_stream_enable_configs[0] | lower != 'all' %}
    - include_pat: {{ nginx_stream_enable_configs }}
    {% endif %}
    - require:
      - file: nginx_stream_dir
{% endif %}

{% if nginx_extra_config_enable %}
nginx_extra_config:
  file.recurse:
    - name: /etc/nginx/conf.d
    - source: salt://nginx/files/conf.d
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - clean: True
    {% if nginx_extra_enable_configs[0] | lower != 'all' %}
    - include_pat: {{ nginx_extra_enable_configs }}
    {% endif %}
    - require:
      - pkg: nginx_packages
      - user: nginx_runtime_user
      - file: nginx_log_dir
{% endif %}

nginx_service:
  service.running:
    - name: nginx
    - enable: True
    - watch:
      - file: nginx_config
      {% if nginx_extra_config_enable %}
      - file: nginx_extra_config
      {% endif %}
      {% if nginx_stream_enable %}
      - file: nginx_stream_config
      {% endif %}
      {% if nginx_ssl_enable %}
      - file: nginx_certs_config
      {% endif %}