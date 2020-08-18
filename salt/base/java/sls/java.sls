{# 判断用户自定义的java版本是否是1.7.0、1.8.0和11 #}
{% if pillar['java_version'] is defined and pillar['java_version'] in ['1.7.0', '1.8.0', '11'] %}
    {% set java_version=pillar['java_version'] %}
{% else %}
    {% set java_version='11' %}
{% endif %}

java_packages:
  pkg.installed:
    - pkgs:
      - "java-{{ java_version }}-openjdk"
      - "java-{{ java_version }}-openjdk-devel"