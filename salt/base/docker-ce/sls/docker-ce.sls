docker_dep_pkgs:
  pkg.installed:
    - pkgs:
      - yum-utils
      - device-mapper-persistent-data
      - lvm2

docker_yum_repo:
  file.managed:
    - name: /etc/yum.repos.d/docker-ce.repo
    - source: salt://docker-ce/files/docker-ce.repo
    - user: root
    - group: root
    - mode: 644

docker_pkgs:
  pkg.installed:
    - pkgs:
      - docker-ce
      - docker-ce-cli
      - containerd.io

docker_daemon_dir:
  file.directory:
    - name: /etc/docker
    - user: root
    - group: root
    - dir_mode: 755

docker_daemon_config:
  file.managed:
    - name: /etc/docker/daemon.json
    - source: salt://docker-ce/files/daemon.json
    - user: root
    - group: root
    - mode: 644

docker_iptables:
  file.line:
    - name: /usr/lib/systemd/system/docker.service
    - content: 'ExecStartPost=/usr/sbin/iptables -P FORWARD ACCEPT'
    - mode: ensure
    - after: '^ExecStart='

docker_iptables_policy:
  iptables.set_policy:
    - table: filter
    - chain: FORWARD
    - policy: ACCEPT

docker_daemon:
  service.running:
    - name: docker
    - enable: True
    - require:
      - pkg: docker_pkgs
      - file: docker_daemon_config
    - watch:
      - file: docker_daemon_config
      - file: docker_iptables