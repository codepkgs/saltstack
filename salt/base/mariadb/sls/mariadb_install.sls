mariadb_repo:
  file.managed:
    - name: /etc/yum.repos.d/mariadb.repo
    - source: salt://mariadb/files/mariadb.repo.j2
    - user: root
    - group: root
    - mode: 644
    - template: jinja

mariadb_packages:
  pkg.installed:
    - pkgs:
      - MariaDB-server
      - MariaDB-client
      - MariaDB-devel