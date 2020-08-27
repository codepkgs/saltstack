{# memcached source filename #}
{% set memcached_filename = salt["pillar.get"]("memcached_filename", "memcached-1.6.6.tar.gz") %}

{# memcached install path #}
{% set memcached_install_prefix = salt["pillar.get"]("memcached_install_prefix", "/usr/local/memcached") %}
{% set memcached_bin = memcached_install_prefix + "/bin/memcached" %}

{# memcached runtime user #}
{% set memcached_runtime_user = salt["pillar.get"]("memcached_runtime_user", "memcached") %}

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
    - unless: {{ memcached_bin }} | is_binary_file

memcached_make_install:
  cmd.wait:
    - name: |
        cd /tmp/memcached-* && \
        ./configure --prefix={{ memcached_install_prefix }} --enable-sasl --enable-sasl-pwdb && \
        make && make install
    - shell: /bin/bash
    - unless: {{ memcached_bin }} | is_binary_file
