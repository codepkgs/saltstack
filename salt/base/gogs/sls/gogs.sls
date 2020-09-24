{% set gogs_download_url = 'https://github.com/gogs/gogs/releases/download/v0.12.1/gogs_0.12.1_linux_amd64.zip' %}

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
  file.managed:
    - name: /home/git/gogs.zip
    - source: {{ gogs_download_url }}
    - user: git
    - group: git
    - mode: 644
    - skip_verify: True

gogs_pkgs_unzip:
  cmd.run:
    - name: unzip /home/git/gogs.zip
    - shell: /bin/bash
    - runas: git
    - unless: test -d /home/git/gogs