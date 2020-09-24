{# 客户端工具配置，格式为 section: {option: value} #}
{% set mariadb_client_configs = salt['pillar.get']('mariadb_client_configs', {
    'mysql': {
        'default-character-set': 'utf8mb4'
    }
}) %}

{# 服务器端配置，格式为 section: {option: value} #}
{% set mariadb_server_configs = salt['pillar.get']('mariadb_server_configs', {
    'mariadb': {
        'character-set-server': 'utf8mb4',
        'innodb_file_per_table': 'ON',
        'innodb_file_format' : 'Barracuda',
        'innodb_large_prefix' : 'ON'
    }
}) %}

mariadb_client_config:
  ini.options_present:
    - name: /etc/my.cnf.d/mysql-clients.cnf
    - separator: '='
    - strict: True
    - sections:
        {% for section in mariadb_client_configs %}
        {{ section }}:
          {% for option, value in mariadb_client_configs[section].items() %}
          {{ option }}: {{ value }}
          {% endfor %}
        {% endfor %}
    - require:
      - pkg: mariadb_packages

mariadb_server_config:
  ini.options_present:
    - name: /etc/my.cnf.d/server.cnf
    - separator: '='
    - strict: True
    - sections:
        {% for section in mariadb_server_configs %}
        {{ section }}:
          {% for option, value in mariadb_server_configs[section].items() %}
          {{ option }}: {{ value }}
          {% endfor %}
        {% endfor %}
    - require:
      - pkg: mariadb_packages
