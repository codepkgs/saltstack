{% set pyenv_python_versions = salt['pillar.get']('pyenv_python_versions', ['3.6.12', '3.8.5']) %}
{% set pyenv_plugins = salt['pillar.get']('pyenv_plugins', ['pyenv-virtualenv', 'pyenv-update']) %}

pyenv_dep_pkgs:
  pkg.installed:
    - pkgs:
      - git
      - zlib-devel
      - bzip2-devel
      - openssl-devel
      - ncurses-devel
      - sqlite-devel
      - readline-devel
      - tk-devel
      - gdbm-devel
      - libpcap-devel
      - xz-devel
      - libffi-devel

pyenv_rc:
  file.managed:
    - name: /etc/profile.d/pyenv.sh
    - source: salt://pyenv/files/pyenv.sh
    - user: root
    - group: root
    - mode: 644

{# 安装 python 各个版本 #}
{% for version in pyenv_python_versions %}
pyenv_install_{{ version }}:
  pyenv.installed:
    - name: {{ version }}
    - require:
      - pkg: pyenv_dep_pkgs
{% endfor %}

{# 安装pyenv 插件 #}
{% for plugin in pyenv_plugins %} #}
pyenv_plugin_{{ plugin }}:
  git.cloned:
    - name: https://github.com/pyenv/{{ plugin }}.git
    - target: /usr/local/pyenv/plugins/{{ plugin }}
    - require:
      - pkg: pyenv_dep_pkgs
{% endfor %}