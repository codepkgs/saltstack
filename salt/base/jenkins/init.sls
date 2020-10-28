include:
  {% if grains['os_family'].lower() == 'redhat' %}
  - java
  - .sls/rhel_jenkins
  {% endif %}