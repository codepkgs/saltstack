system_init_pip:
  file.managed:
    - name: /etc/pip.conf
    - source: salt://system-init/files/pip.conf
    - user: root
    - group: root
    - mode: 0644
