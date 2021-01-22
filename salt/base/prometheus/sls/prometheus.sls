{% set prometheus_user = "prometheus" %}
{% set prometheus_download_url = pillar['prometheus_download_url'] %}
{% set prometheus_archive_dir = pillar['prometheus_download_url'].split('/')[-1].split('.tar')[0] %}
{% set prometheus_source_hash = pillar['prometheus_source_hash'] %}
{% set prometheus_bins = ["prometheus", "promtool"] %}
{% set prometheus_webs = ["console_libraries", "consoles"] %}
{% set prometheus_extra_dirs = ["rules", "exporters"] %}
prometheus_user:
  user.present:
    - name: {{ prometheus_user }}
    - shell: /sbin/nologin
    - createhome: False

prometheus_config_dir:
  file.directory:
    - name: /etc/prometheus
    - user: {{ prometheus_user }}
    - group: {{ prometheus_user }}
    - dir_mode: 755
    - recurse:
      - user
      - group
    - require:
      - user: prometheus_user

prometheus_data_dir:
  file.directory:
    - name: /data/prometheus
    - user: {{ prometheus_user }}
    - group: {{ prometheus_user }}
    - dir_mode: 755
    - recurse:
      - user
      - group
    - require:
      - user: prometheus_user

prometheus_download:
  archive.extracted:
    - name: /tmp/
    - source: {{ prometheus_download_url }}
    - source_hash: {{ prometheus_source_hash }}
    - unless: test -f /usr/local/bin/prometheus

{% for bin in prometheus_bins %}
prometheus_binary_{{ bin }}:
  file.managed:
    - name: /usr/local/bin/{{ bin }}
    - source: /tmp/{{prometheus_archive_dir}}/{{ bin }}
    - user: {{ prometheus_user }}
    - group: {{ prometheus_user }}
    - mode: 0755
    - require:
      - archive: prometheus_download
{% endfor %}

{% for web in prometheus_webs %}
prometheus_web_{{ web }}:
  cmd.run:
    - name: cp -r /tmp/{{prometheus_archive_dir}}/{{ web }} /etc/prometheus/
    - shell: /bin/bash
    - require:
      - archive: prometheus_download
{% endfor %}

{% for web in prometheus_webs %}
prometheus_webperm_{{ web }}:
  cmd.run:
    - name: chown -R {{ prometheus_user }}:{{prometheus_user}} /etc/prometheus/{{web}}
    - shell: /bin/bash
{% endfor %}

{% for dir in prometheus_extra_dirs %}
prometheus_dir_{{ dir }}:
  file.directory:
    - name: /etc/prometheus/{{dir}}
    - user: {{ prometheus_user }}
    - group: {{ prometheus_user }}
    - dir_mode: 755
    - file_mode: 644
    - clean: True
{% endfor %}

prometheus_config_file:
  file.managed:
    - name: /etc/prometheus/prometheus.yml
    - source: /tmp/{{prometheus_archive_dir}}/prometheus.yml
    - user: {{ prometheus_user }}
    - group: {{ prometheus_user }}
    - mode: 644

prometheus_service_file:
  file.managed:
    - name: /usr/lib/systemd/system/prometheus.service
    - source: salt://prometheus/templates/prometheus.service.j2
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      {% for bin in prometheus_bins %}
      - file: prometheus_binary_{{ bin }}
      {% endfor %}
      {% for web in prometheus_webs %}
      - cmd: prometheus_web_{{ web }}
      {% endfor %}

prometheus_service:
  service.running:
    - name: prometheus
    - enable: True
    - watch:
      - file: prometheus_config_file
      - file: prometheus_service_file
