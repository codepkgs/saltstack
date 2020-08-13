{# redhat 6 #}
{% if grains['os_family'].lower() == 'redhat' and grains['osmajorrelease'] == 6 %}
system_init_repo_epel:
  file.managed:
    - name: /etc/yum.repos.d/epel.repo
    - source: salt://system-init/files/epel_6.repo
    - user: root
    - group: root
    - mode: 0644
{# redhat 7 #}
{% elif grains['os_family'].lower() == 'redhat' and grains['osmajorrelease'] == 7 %}
system_init_repo_epel:
  file.managed:
    - name: /etc/yum.repos.d/epel.repo
    - source: salt://system-init/files/epel_7.repo
    - user: root
    - group: root
    - mode: 0644
{% endif %}

{# centos 6 #}
{% if grains['os'].lower() == 'centos' and grains['osmajorrelease'] == 6 %}
system_init_repo_centos:
  file.managed:
    - name: /etc/yum.repos.d/CentOS-Base.repo
    - source: salt://system-init/files/CentOS-Base_6.repo
    - user: root
    - group: root
    - mode: 0644
{# centos 7 #}
{% elif grains['os'].lower() == 'centos' and grains['osmajorrelease'] == 7 %}
system_init_repo_centos:
  file.managed:
    - name: /etc/yum.repos.d/CentOS-Base.repo
    - source: salt://system-init/files/CentOS-Base_7.repo
    - user: root
    - group: root
    - mode: 0644
{% endif %}