{# 配置文件发生变化时是否自动重启 mariadb 服务 #}
{% set mariadb_watch_configs = salt['pillar.get']('mariadb_watch_configs', True) %}

mariadb_service:
  service.running:
    - name: mariadb
    - enable: True
    - require:
      - pkg: mariadb_packages
    {% if mariadb_watch_configs %}
    - watch:
      - ini: mariadb_client_config
      - ini: mariadb_server_config
    {% endif %}