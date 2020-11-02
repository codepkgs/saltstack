nodejs_depend_pkgs:
  pkg.installed:
    - pkgs:
      - ImageMagick
      - ImageMagick-devel
      - GraphicsMagick
      - GraphicsMagick-devel

nodejs_repo:
  file.managed:
    - name: /etc/yum.repos.d/nodesource-el7.repo
    - source: salt://nodejs/files/nodesource-el7.repo
    - user: root
    - group: root
    - mode: 644

nodejs_pkg:
  pkg.installed:
    - pkgs:
      - nodejs

nodejs_npm_pkgs:
  npm.installed:
    - name: pm2

nodejs_www_user:
  user.present:
    - name: www
    - shell: /bin/bash

nodejs_log_dir:
  file.directory:
    - name: /data/logs/nodejs
    - user: www
    - group: www
    - dir_mode: 755
    - makedirs: True
    - require:
      - user: nodejs_www_user

nodejs_pm2_service_file:
  file.managed:
    - name: /etc/systemd/system/pm2.service
    - source: salt://nodejs/files/pm2.service
    - user: root
    - group: root
    - mode: 644

nodejs_pm2_service:
  service.running:
    - name: pm2
    - enable: True
    - require:
      - file: nodejs_pm2_service_file
    - watch:
      - file: nodejs_pm2_service_file
