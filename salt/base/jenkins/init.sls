include:
  {% if grains['os_family'].lower() == 'redhat' %}
  - .sls/rhel_jenkins
  {% endif %}