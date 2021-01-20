{% set php74_dirs = ["php-seaslog", "php-fpm"] %}
{% set php74_install_configs = pillar['php74_install_configs'] %}

php74_user:
  user.present:
    - name: www
    - shell: /bin/bash

{% for dir in php74_dirs %}
php74_dirs_{{ dir }}:
  file.directory:
    - name: /data/logs/{{ dir }}
    - user: www
    - group: www
    - dir_mode: 0755
    - makedirs: True
    - require:
      - user: php74_user
{% endfor %}

php74_dep_pkgs:
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

php74_remi_repo:
  file.managed:
    - name: /etc/yum.repos.d/remi.repo
    - source: salt://php74/files/remi.repo
    - user: root
    - group: root
    - mode: 0644

php74_pkgs:
  pkg.installed:
    - pkgs:
      - php74
      - php74-php
      - php74-runtime
      - php74-php-bcmath
      - php74-php-cli
      - php74-php-common
      - php74-php-devel
      - php74-php-fpm
      - php74-php-gd
      - php74-php-intl
      - php74-php-json
      - php74-php-mbstring
      - php74-php-mysqlnd
      - php74-php-opcache
      - php74-php-pdo
      - php74-php-soap
      - php74-php-xml
      - php74-php-xmlrpc
      - php74-php-dba
      - php74-php-enchant
      - php74-php-gmp
      - php74-php-imap
      - php74-php-json
      - php74-php-ldap
      - php74-php-odbc
      - php74-php-pdo-dblib
      - php74-php-pgsql
      - php74-php-pspell
      - php74-php-sodium
      - php74-php-tidy
      - php74-php-lz4
      - php74-php-process
      - php74-php-pecl-crypto
      - php74-php-pecl-decimal
      - php74-php-pecl-http-devel
      - php74-php-pecl-http
      - php74-php-pecl-imagick
      - php74-php-pecl-imagick-devel
      - php74-php-pecl-mcrypt
      - php74-php-pecl-mysql
      - php74-php-pecl-oauth
      - php74-php-pecl-redis5
      - php74-php-pecl-seaslog
      - php74-php-pecl-swoole4
      - php74-php-phalcon4
      - php74-php-pecl-apcu
      - php74-php-pecl-geoip
      - php74-php-pecl-memcached
      - php74-php-pecl-mongodb
      - php74-php-pecl-zip
      - php74-php-pecl-recode
    - require:
      - file: php74_remi_repo

{% for config in php74_install_configs %}
php74_configs_{{ config.src }}:
  file.managed:
    - name: {{ config.dst }}
    - source: salt://php74/templates/{{ config.src }}
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - require:
      - pkg: php74_pkgs
{% endfor %}

php74_service:
  service.running:
    - name: php74-php-fpm
    - enable: True
    - watch:
      - file: php74_configs_*