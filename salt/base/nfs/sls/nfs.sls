{# 设置变量 #}
{% set dirs = [] %}

{# 检查操作系统 #}
{% if grains['os_family'].lower() == 'redhat' %}
    {% set nfs_packages = ['rpcbind', 'nfs-utils'] %}
{% endif %}

{# 检查nfs角色，并设置共享目录和服务 #}
{# nfs 服务器 #}
{% if pillar['nfs_role'] is defined and pillar['nfs_role'] == 'server' and pillar['nfs_exports'] is defined %}
    {% set nfs_services = ['rpcbind', 'nfs', 'nfs-lock'] %}
    {% for dir in pillar['nfs_exports'] %}
        {% do dirs.append(dir.name) %}
    {% endfor %}
{# nfs 客户端 #}
{% elif pillar['nfs_role'] is defined and pillar['nfs_role'] == 'client' and pillar['nfs_mounts'] is defined %}
    {% for dir in pillar['nfs_mounts'] %}
        {% do dirs.append(dir.local_dir) %}
    {% endfor %}
{% endif %}

{# 安装软件包 #}
{% for package in nfs_packages %}
nfs_packages_{{ package }}:
  pkg.installed:
    - name: {{ package }}
{% endfor %}

{# 创建共享目录或挂载目录 #}
{% for dir in dirs %}
nfs_shared_dir_{{ dir }}:
  file.directory:
    - name: {{ dir }}
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True
{% endfor %}

{# 渲染配置文件 #}
{% if pillar['nfs_role'] is defined and pillar['nfs_role'] == 'server' %}

nfs_exports:
  file.managed:
    - name: /etc/exports
    - source: salt://nfs/files/exports.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 644

{% for service in nfs_services %}
nfs_service_{{ service }}:
  service.running:
    - name: {{ service }}
    - enable: True
    - watch:
      - file: /etc/exports
{% endfor %}

{# nfs client mounts #}
{% elif pillar['nfs_role'] is defined and pillar['nfs_role'] == 'client' and pillar['nfs_mounts'] is defined %}
{% for mount in pillar['nfs_mounts'] %}
{% if mount.status.lower() == 'mount' %}
"nfs_client_mounts_{{ mount }}":
  mount.mounted:
    - name: {{ mount.local_dir }}
    - device: "{{ mount.server }}:{{mount.remote_dir }}"
    - fstype: nfs
    {% if 'opts' in mount %}
    - opts: {{ mount.opts }}
    {% else %}
    - opts: _netdev,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,defaults
    {% endif %}
    - persist: {{ mount.persist }}
{% elif mount.status.lower() == 'umount' %}
"nfs_client_umount_{{ mount }}":
  mount.unmounted:
    - name: {{ mount.local_dir }}
    - device: "{{ mount.server }}:{{mount.remote_dir }}"
    - persist: "{{ mount.persist }}"
{% endif %}
{% endfor %}

{% endif %}