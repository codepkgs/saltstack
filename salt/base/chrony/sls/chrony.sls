chrony_pkgs:
  pkg.installed:
    - pkgs:
      - chrony

chrony_config:
  file.managed:
    - name: /etc/chrony.conf
    - source: salt://chrony/templates/chrony.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: chrony_pkgs

chrony_service:
  service.running:
    - name: chronyd
    - enable: True
    - require:
      - file: chrony_config
    - watch:
      - file: chrony_config