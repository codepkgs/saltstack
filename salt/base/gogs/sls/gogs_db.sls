{% set gogs_db_host = salt['pillar.get']('gogs_db_host', 'localhost') %}
{% set gogs_db_port = salt['pillar.get']('gogs_db_port', 3306) %}
{% set gogs_db_user = salt['pillar.get']('gogs_db_user', 'root') %}
{% set gogs_db_pass = salt['pillar.get']('gogs_db_pass', '') %}
{% set gogs_db_socket = salt['pillar.get']('gogs_db_socket', '/var/lib/mysql/mysql.sock') %}
{% set gogs_db_charset = salt['pillar.get']('gogs_db_charset', 'utf8mb4') %}
{% set gogs_user_password = salt['pillar.get']('gogs_user_password', 'gogs') %}

gogs_python_pkgs:
  pkg.installed:
    - pkgs:
      - python2-pip
      - python3-pip
      - python2-PyMySQL
      - python36-PyMySQL

gogs_pymysql:
  pip.installed:
    - name: pymysql
    - require:
      - pkg: gogs_python_pkgs

gogs_database:
  mysql_database.present:
    - connection_host: {{ gogs_db_host }}
    - connection_port: {{ gogs_db_port }}
    - connection_user: {{ gogs_db_user }}
    - connection_pass: {{ gogs_db_pass }}
    - connection_unix_socket: {{ gogs_db_socket }}
    - connection_chraset: {{ gogs_db_charset }}
    - name: gogs
    - character_set: {{ gogs_db_charset }}

gogs_db_user:
  mysql_user.present:
    - connection_host: {{ gogs_db_host }}
    - connection_port: {{ gogs_db_port }}
    - connection_user: {{ gogs_db_user }}
    - connection_pass: {{ gogs_db_pass }}
    - connection_unix_socket: {{ gogs_db_socket }}
    - connection_chraset: {{ gogs_db_charset }}
    - name: gogs
    - host: 'localhost'
    - password: {{ gogs_user_password }}