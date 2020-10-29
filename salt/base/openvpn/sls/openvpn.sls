{% set openvpn_dirs = ['client', 'server'] %}
{% set openvpn_files = ['ca.crt', 'openvpn.crt', 'openvpn.key', 'dh.pem'] %}

openvpn_dep_pkgs:
  pkg.installed:
    - pkgs:
      - gcc
      - gcc-c++
      - openssl
      - openssl-devel
      - pam
      - pam-devel
      - pkcs11-helper
      - pkcs11-helper-devel

openvpn_pkgs:
  pkg.installed:
    - pkgs:
      - openvpn

{% for dir in openvpn_dirs %}
openvpn_dirs_{{ dir }}:
  file.directory:
    - name: /etc/openvpn/{{ dir }}
    - user: root
    - group: openvpn
    - dir_mode: 750
    - makedirs: True
    - require:
      - pkg: openvpn_pkgs
{% endfor %}

{% for file in openvpn_files %}
openvpn_files_{{ file }}:
  file.managed:
    - name: /etc/openvpn/server/{{ file }}
    - source: salt://openvpn/files/{{ file }}
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: openvpn_pkgs
{% endfor %}

openvpn_config:
  file.managed:
    - name: /etc/openvpn/openvpn.conf
    - source: salt://openvpn/templates/openvpn.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: openvpn_files_*
    - watch:
      - file: openvpn_files_*

openvpn_service_other_config_absent:
  file.absent:
    - name: /usr/lib/systemd/system/openvpn-server@.service

openvpn_service_config:
  file.managed:
    - name: /usr/lib/systemd/system/openvpn-server.service
    - source: salt://openvpn/templates/openvpn-server.service.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: openvpn_config
    - watch:
      - file: openvpn_config

openvpn_service:
  service.running:
    - name: openvpn-server
    - enable: True
    - require:
      - file: openvpn_service_config
    - watch:
      - file: openvpn_service_config