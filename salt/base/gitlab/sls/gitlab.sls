{% if pillar['gitlab_external_url'] is defined and pillar['gitlab_external_url'] %}
  {% set gitlab_hostname = pillar['gitlab_external_url'].split('//')[1] %}
{% endif %}

gitlab_dep_pkgs:
  pkg.installed:
    - pkgs:
      - curl
      - policycoreutils-python
      - openssh-server

gitlab_repo:
  file.managed:
    - name: /etc/yum.repos.d/gitlab-ce.repo
    - source: salt://gitlab/files/gitlab-ce.repo
    - user: root
    - group: root
    - mode: 644

gitlab_pkgs:
  pkg.installed:
    - pkgs:
      - gitlab-ce

gitlab_config_backup:
  file.managed:
    - name: /etc/gitlab/gitlab.rb.backup
    - source: /etc/gitlab/gitlab.rb
    - user: root
    - group: root
    - mode: 644
    - unless: test -f '/etc/gitlab/gitlab.rb.backup'
    - require:
      - pkg: gitlab_pkgs

{% if salt['pillar.get']('gitlab_data_dir', '/var/opt/gitlab/git-data') %}
gitlab_data_dir:
  file.directory:
    - name: {{ salt['pillar.get']('gitlab_data_dir', '/var/opt/gitlab/git-data') }}
    - user: git
    - group: root
    - dir_mode: 700
    - makedirs: True
{% endif %}

gitlab_config:
  file.managed:
    - name: /etc/gitlab/gitlab.rb
    - source: salt://gitlab/templates/gitlab.rb.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 640

{% if salt['pillar.get']('gitlab_nginx_ssl_enable', False) %}
gitlab_nginx_ssl_dir:
  file.directory:
    - name: /etc/gitlab/ssl
    - user: root
    - group: root
    - makedirs: True
    - dir_mode: 755

gitlab_nginx_ssl_cert:
  file.managed:
    - name: /etc/gitlab/ssl/{{ gitlab_hostname }}.crt
    - source: salt://gitlab/files/certs/{{ pillar['gitlab_nginx_ssl_cert'] }}
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: gitlab_nginx_ssl_dir

gitlab_nginx_ssl_cert_key:
  file.managed:
    - name: /etc/gitlab/ssl/{{ gitlab_hostname }}.key
    - source: salt://gitlab/files/certs/{{ pillar['gitlab_nginx_ssl_cert_key'] }}
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: gitlab_nginx_ssl_dir

gitlab_nginx_reload:
  cmd.wait:
    - name: gitlab-ctl hup nginx
    - watch:
      - file: gitlab_nginx_ssl_cert
      - file: gitlab_nginx_ssl_cert_key
{% endif %}

gitlab_reconfigure:
  cmd.wait:
    - name: gitlab-ctl reconfigure
    - watch:
      - file: gitlab_config
    - require:
      - pkg: gitlab_pkgs

gitlab_service:
  service.running:
    - name: gitlab-runsvdir
    - enable: True
    - onlyif: test -f '/usr/lib/systemd/system/gitlab-runsvdir.service'
    - require:
      - pkg: gitlab_pkgs
