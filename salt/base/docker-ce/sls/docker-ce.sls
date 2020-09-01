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