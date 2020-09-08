openresty_repo:
  file.managed:
    - name: /etc/yum.repos.d/openresty.repo
    - source: salt://openresty/files/openresty.repo
    - user: root
    - group: root
    - mode: 644

openresty_pkgs:
  pkg.installed:
    - pkgs:
      - openresty
      - openresty-resty
