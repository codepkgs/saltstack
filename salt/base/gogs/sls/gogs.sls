{% set gogs_download_url = 'https://dl.gogs.io/0.12.1/gogs_0.12.1_linux_amd64.tar.gz' %}
{% set gogs_update_config = salt['pillar.get']('gogs_update_config', False) %}

gogs_repo:
  file.managed:
    - name: /etc/yum.repos.d/gogs.repo
    - source: salt://gogs/files/gogs.repo
    - user: root
    - group: root
    - mode: 644

gogs_dep_pkgs:
  pkg.installed:
    - pkgs:
      - git

gogs_git_user:
  user.present:
    - name: git
    - shell: /bin/bash

gogs_pkgs:
  archive.extracted:
    - name: /home/git/
    - source: {{ gogs_download_url }}
    - user: git
    - group: git
    - mode: 755
    - skip_verify: True
    - keep_source: True
    - unless: test -d /home/git/gogs
    - require:
      - user: gogs_git_user

{# gogs_repository_dir:
  file.directory:
    - name: /data/gogs-repositories
    - user: git
    - group: git
    - dir_mode: 755
    - makedirs: True #}

gogs_custom_config:
  file.managed:
    - name: /home/git/gogs/custom/config/app.ini
    - source: salt://gogs/files/app.ini.j2
    - user: git
    - group: git
    - mode: 644
    - makedirs: True
    - template: jinja
    - require:
      - archive: gogs_pkgs
    {% if not gogs_update_config %}
    - unless: test -f /home/git/gogs/custom/config/app.ini
    {% endif %}

gogs_service_file:
  file.managed:
    - name: /usr/lib/systemd/system/gogs.service
    - source: salt://gogs/files/gogs.service
    - user: root
    - group: root
    - mode: 644
    - require:
      - archive: gogs_pkgs

gogs_service:
  service.running:
    - name: gogs
    - enable: True
    - require:
      - file: gogs_service_file
      - file: gogs_custom_config
    - watch:
      - file: gogs_service_file
      {% if not gogs_update_config %}
      - file: gogs_custom_config
      {% endif %}