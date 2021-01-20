{% set php72_dirs = ["php-seaslog", "php-fpm"] %}
{% set php72_install_configs = pillar['php72_install_configs'] %}

php72_user:
  user.present:
    - name: www
    - shell: /bin/bash

{% for dir in php72_dirs %}
php72_dirs_{{ dir }}:
  file.directory:
    - name: /data/logs/{{ dir }}
    - user: www
    - group: www
    - dir_mode: 0755
    - makedirs: True
    - require:
      - user: php72_user
{% endfor %}

php72_dep_pkgs:
  pkg.installed:
    - pkgs:
      - gcc
      - gcc-c++
      - openssl
      - openssl-devel
      - zip
      - zlib
      - zlib-devel
      - pcre
      - pcre-devel
      - mhash
      - mhash-devel
      - gd
      - gd-devel

php72_remi_repo:
  file.managed:
    - name: /etc/yum.repos.d/remi.repo
    - source: salt://php72/files/remi.repo
    - user: root
    - group: root
    - mode: 0644

php72_pkgs:
  pkg.installed:
    - pkgs:
      - php72
      - php72-php
      - php72-runtime
      - php72-php-bcmath
      - php72-php-cli
      - php72-php-common
      - php72-php-devel
      - php72-php-fpm
      - php72-php-gd
      - php72-php-intl
      - php72-php-json
      - php72-php-mbstring
      - php72-php-mysqlnd
      - php72-php-opcache
      - php72-php-pdo
      - php72-php-soap
      - php72-php-xml
      - php72-php-xmlrpc
      - php72-php-dba
      - php72-php-enchant
      - php72-php-gmp
      - php72-php-imap
      - php72-php-json
      - php72-php-ldap
      - php72-php-odbc
      - php72-php-pdo-dblib
      - php72-php-interbase
      - php72-php-pgsql
      - php72-php-pspell
      - php72-php-recode
      - php72-php-sodium
      - php72-php-tidy
      - php72-php-lz4
      - php72-php-process
      - php72-php-pecl-crypto
      - php72-php-pecl-decimal
      - php72-php-pecl-http-devel
      - php72-php-pecl-http
      - php72-php-pecl-imagick
      - php72-php-pecl-imagick-devel
      - php72-php-pecl-mcrypt
      - php72-php-pecl-mysql
      - php72-php-pecl-oauth
      - php72-php-pecl-redis
      - php72-php-pecl-request
      - php72-php-pecl-seaslog
      - php72-php-pecl-swoole
      - php72-php-phalcon3
      - php72-php-pecl-apcu
      - php72-php-pecl-geoip
      - php72-php-pecl-libsodium
      - php72-php-pecl-memcached
      - php72-php-pecl-mongodb
      - php72-php-pecl-zip
    - require:
      - file: php72_remi_repo

{% for config in php72_install_configs %}
php72_configs_{{ config.src }}:
  file.managed:
    - name: {{ config.dst }}
    - source: salt://php72/templates/{{ config.src }}
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - require:
      - pkg: php72_pkgs
{% endfor %}

php72_service:
  service.running:
    - name: php72-php-fpm
    - enable: True
    - watch:
      - file: php72_configs_*