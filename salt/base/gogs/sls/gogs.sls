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
  pkg.installed:
    - pkgs:
      - gogs
    - require:
      - file: gogs_repo
