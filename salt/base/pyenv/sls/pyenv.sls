{% set pyenv_python_versions = salt['pillar.get']('pyenv_python_versions', ['3.6.12']) %}

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

{% if salt['file.directory_exists']('/usr/local/pyenv') %}
pyenv_install:
  cmd.script:
    - name: /tmp/pyenv-installer.sh
    - source: salt://pyenv/files/pyenv-installer.sh
    - shell: /bin/bash
{% endif %}

pyenv_rc:
  file.managed:
    - name: /etc/profile.d/pyenvrc.sh
    - source: salt://pyenv/files/pyenvrc
    - user: root
    - group: root
    - mode: 644

{% for version in pyenv_python_versions %}
pyenv_install_{{ version }}:
  pyenv.installed:
    - name: {{ version }}
    - require:
      - pkg: pyenv_dep_pkgs
{% endfor %}
