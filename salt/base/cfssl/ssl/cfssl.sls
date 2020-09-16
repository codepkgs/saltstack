{% set cfssl_url = 'https://github.com/cloudflare/cfssl/releases/download/v1.4.1/cfssl_1.4.1_linux_amd64' %}
{% set cfssljson_url = 'https://github.com/cloudflare/cfssl/releases/download/v1.4.1/cfssljson_1.4.1_linux_amd64' %}
{% set cfssl_url_map = {'cfssl': cfssl_url, 'cfssljson': cfssljson_url } %}

{% for name, url in cfssl_url_map.items() %}
cfssl_{{ name }}:
  file.managed:
    - name: /usr/local/bin/{{ name }}
    - source: {{ url }}
    - skip_verify: True
    - keep_source: True
    - user: root
    - group: root
    - mode: 755
    - unless: test -x /usr/local/bin/{{ name }}
{% endfor %}

cfssl_dir:
  file.directory:
    - name: /etc/cfssl
    - user: root
    - group: root
    - dir_mode: 755
    - makedirs: True

cfssl_default_config:
  file.managed:
    