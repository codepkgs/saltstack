{% if grains['os_family'].lower() == 'redhat' %}
kdump:
  service.dead:
    - enable: False

NetworkManager:
  service.dead:
    - enable: False

postfix:
  service.dead:
    - enable: False

iptables:
  service.dead:
    - enable: False

salt-minion:
  service.running:
    - enable: True
{% endif %}

{% if grains['os_family'].lower() == 'redhat' and grains['osmajorrelease'] == 7 %}
firwalld:
  service.dead:
    - enable: False
{% endif %}
