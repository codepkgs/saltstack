{# 设置jenkins软件源的地址和jenkins版本 #}
{% if pillar['jenkin_repo_host'] is defined and pillar['jenkins_repo_host'] %}
    {% set jenkins_repo_host = pillar['jenkins_repo_host'] %}
{% else %}
    {% set jenkins_repo_host = 'https://mirrors.tuna.tsinghua.edu.cn/jenkins/redhat-stable/' %}
{% endif %}

{% if pillar['jenkin_version'] is defined and pillar['jenkins_version'] %}
    {% set jenkins_version = pillar['jenkins_version'] %}
{% else %}
    {% set jenkins_version = 'jenkins-2.235.5-1.1.noarch.rpm' %}
{% endif %}

{# 设置jenkins_real_version #}
{% set jenkins_real_version = jenkins_repo_host + jenkins_version %}

{# 安装jenkins， 只针对 RedHat 系列的操作系统 #}
jenkins_install:
  pkg.installed:
    - sources:
      - jenkins: {{ jenkins_real_version }}
    - unless: ls -l /usr/lib/jenkins/jenkins.war

{# 设置jenkins用户的shell为/bin/bash #}
jenkins_user:
  user.present:
    - name: jenkins
    - home: /var/lib/jenkins
    - shell: /bin/bash
    - require:
      - pkg: jenkins_install

{# 复制skel #}
{% for file  in ['.bash_profile', '.bashrc', '.bash_logout']%}
jenkins_user_skel_{{ file }}:
  file.managed:
    - name: /var/lib/jenkins/{{ file }}
    - source: /etc/skel/{{ file }}
    - user: jenkins
    - group: jenkins
    - mode: 644
    - subdir: True
    - require:
      - user: jenkins_user
{% endfor %}

{# jenkins config file #}
jenkins_config:
  file.managed:
    - name: /etc/sysconfig/jenkins
    - source: salt://jenkins/templates/jenkins.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: jenkins_install

jenkins_plugin_update_center:
  file.replace:
    - name: /var/lib/jenkins/hudson.model.UpdateCenter.xml
    - pattern: "^(\\s*)<url>.*</url>$"
    - repl: "\\1<url>https://mirror.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json</url>"
    - require:
      - pkg: jenkins_install

jenkins_service:
  service.running:
    - name: jenkins
    - enable: True
    - require:
      - pkg: jenkins_install
    - watch:
      - file: jenkins_config
      - file: jenkins_plugin_update_center