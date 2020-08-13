resolv_config:
  file.managed:
    - name: /etc/resolv.conf
    - template: jinja
    {%if grains['os_family'].lower() == 'redhat' %}
    - source: salt://resolv/files/resolv.conf.j2
    {% endif %}
    - user: root
    - group: root
    - mode: 0644
