prometheus_node_exporter_repo:
  file.managed:
    - name: /etc/yum.repos.d/prometheus.repo
    - source: salt://prometheus/exporters/node-exporter/files/prometheus.repo
    - user: root
    - group: root
    - mode: 0644

prometheus_node_exporter_pkgs:
  pkg.installed:
    - pkgs:
      - node_exporter
    - require:
      - file: prometheus_node_exporter_repo

prometheus_node_exporter_service:
  service.running:
    - name: node_exporter
    - enable: True