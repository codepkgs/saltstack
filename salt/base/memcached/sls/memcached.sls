{# memcached source filename #}
{% set memcached_filename = salt["pillar.get"]("memcached_filename", "memcached-1.6.6.tar.gz") %}

{# memcached install path #}
{% set memcached_install_prefix = salt["pillar.get"]("memcached_install_prefix", "/usr/local/memcached") %}
{% set memcached_bin = memcached_install_prefix + 'bin/memcached' if memcached_install_prefix.endswith('/') else memcached_install_prefix + "/bin/memcached" %}

{# memcached runtime user #}
{% set memcached_runtime_user = salt["pillar.get"]("memcached_runtime_user", "memcached") %}

{# memcached instaces config #}
{% set memcached_default_instance = [{
        "memcached_instance_name": "memcached",
        "memcached_runtime_user": memcached_runtime_user,
        "memcached_runtime_port": 11211,
        "memcached_maxmemory": 1024,
        "memcached_maxconn": 1024,
        "memcached_options": "",
        "memcached_status": "running"
    }
    ]
%}

{% set memcached_instances = salt["pillar.get"]("memcached_instances", memcached_default_instance) %}

memcached_pkgs:
  pkg.installed:
    - pkgs:
      - gcc
      - gcc-c++
      - make
      - automake
      - cyrus-sasl
      - cyrus-sasl-devel
      - libevent-devel

memcached_user:
  user.present:
    - name: {{ memcached_runtime_user }}
    - createhome: False
    - shell: /sbin/nologin

memcached_archive:
  archive.extracted:
    - name: /tmp/
    - source: salt://memcached/files/{{ memcached_filename }}
    - skip_verify: True
    - keep_source: True
    - user: root
    - group: root
    - unless: test -x {{ memcached_bin }}

memcached_make_install:
  cmd.run:
    - name: |
        cd /tmp/memcached-* && \
        ./configure --prefix={{ memcached_install_prefix }} --enable-sasl --enable-sasl-pwdb && \
        make && make install
    - shell: /bin/bash
    - unless: test -x {{ memcached_bin }}

{% if grains['os_family'].lower() == 'redhat' and grains['osmajorrelease'] == 7 %}
{% for instance in memcached_instances %}
    {% set memcached_instance_name = instance["memcached_instance_name"] %}
    {% set memcached_runtime_user = instance["memcached_runtime_user"] %}
    {% set memcached_runtime_port = instance["memcached_runtime_port"] %}
    {% set memcached_maxmemory = instance["memcached_maxmemory"] %}
    {% set memcached_maxconn = instance["memcached_maxconn"] %}
    {% set memcached_options = instance["memcached_options"] %}
    {% set memcached_status = instance["memcached_status"] %}

memcached_service_config_{{ memcached_instance_name }}:
  file.managed:
    - name: /usr/lib/systemd/system/{{ memcached_instance_name }}.service
    - user: root
    - group: root
    - mode: 644
    - contents: |
        [Unit]
        Description=Memcached Server
        Before=httpd.service
        After=network.target

        [Service]
        Type=simple
        ExecStart={{ memcached_bin }} \
                    -u {{ memcached_runtime_user }} \
                    -p {{ memcached_runtime_port }} -m {{ memcached_maxmemory}} \
                    -c {{ memcached_maxconn }} {{ memcached_options }}

        [Install]
        WantedBy=multi-user.target
{% if memcached_status.lower() == "running" %}
memcached_service_{{ memcached_instance_name }}:
  service.running:
    - name: {{ memcached_instance_name }}
    - enable: True
    - watch:
      - file: memcached_service_config_{{ memcached_instance_name }}
    - require:
      - file: memcached_service_config_{{ memcached_instance_name }}
{% elif memcached_status.lower() == "stop" %}
memcached_service_{{ memcached_instance_name }}:
  service.dead:
    - name: {{ memcached_instance_name }}
    - enable: True
{% endif %}
{% endfor %}
{% endif %}