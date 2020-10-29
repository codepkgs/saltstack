openvpn_auth_pam_archive:
  archive.extracted:
    - name: /tmp
    - source: http://swupdate.openvpn.org/community/releases/openvpn-2.0.9.tar.gz
    - user: root
    - group: root
    - skip_verify: True
    - unless: ls -l /usr/lib64/openvpn-auth-pam.so

openvpn_auth_pam_make:
  cmd.run:
    - name: make && cp openvpn-auth-pam.so /usr/lib64/openvpn-auth-pam.so
    - cwd: /tmp/openvpn-2.0.9/plugin/auth-pam
    - shell: /bin/bash
    - unless: ls -l /usr/lib64/openvpn-auth-pam.so

openvpn_auth_pam:
   pkg.installed:
    - sources:
      - pam_mysql: salt://openvpn/files/pam_mysql-0.7-0.20.rc1.el7.x86_64.rpm

openvpn_auth_pam_file:
  file.managed:
    - name: /etc/pam.d/openvpn
    - source: salt://openvpn/templates/openvpn_pam.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 644