openvpn_auth_pam_archive:
  archive.extracted:
    - name: /tmp/openvpn-2.0.9
    - source: http://swupdate.openvpn.org/community/releases/openvpn-2.0.9.tar.gz
    - user: root
    - group: root
    - skip_verify: True
    - unless: ls -l /usr/lib64/openvpn-auth-pam.so

openvpn_auth_pam_make:
  cmd.wait:
    - name: make && cp openvpn-auth-pam.so /usr/lib64/openvpn-auth-pam.so
    - cwd: /tmp/openvpn-2.0.9/plugin/auth-pam
    - shell: /bin/bash
    - unless: ls -l /usr/lib64/openvpn-auth-pam.so

openvpn_auth_pam_db_archive:
  archive.extracted:
    - name: /tmp/pam_mysql-0.7RC1
    - source: salt://openvpn/files/pam_mysql-0.7RC1.tar.gz
    - user: root
    - group: root
    - skip_verify: True

openvpn_auth_pam_db_make:
  cmd.wait:
    - name: |
        ./configure --with-pam=/usr --with-mysql=/usr --with-pam-mods-dir=/usr/lib64/security &&
        make &&
        make install
    - cwd: /tmp/pam_mysql-0.7RC1
    - shell: /bin/bash
    - unless: ls -l /usr/lib64/security/pam_mysql.so
    - require:
      - archive: openvpn_auth_pam_db_archive

openvpn_auth_pam_file:
  file.managed:
    - name: /etc/pam.d/openvpn
    - source: salt://openvpn/templates/openvpn_pam.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 644