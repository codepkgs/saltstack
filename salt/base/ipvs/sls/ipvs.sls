ipvs_pkgs:
  pkg.installed:
    - pkgs:
      - ipvsadm
      - ipset
      - sysstat
      - libnetfilter_conntrack
      - libseccomp

ipvs_modules:
  kmod.present:
    - mods:
      - ip_vs
      - ip_vs_rr
      - ip_vs_wrr
      - ip_vs_lc
      - ip_vs_wlc
      - ip_vs_sh
      - ip_vs_dh
      - nf_conntrack
      - br_netfilter

ipvs_module_config:
  file.managed:
    - name: /etc/modules-load.d/ipvs.conf
    - source: salt://ipvs/files/ipvs.conf
    - user: root
    - group: root
    - mode: 0644

ipvs_hashtable_config:
  file.managed:
    - name: /etc/modprobe.d/ipvs.conf
    - source: salt://ipvs/templates/ipvs.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 0644

ipvs_modules_service:
  service.running:
    - name: systemd-modules-load
    - enable: True
    - watch:
      - file: ipvs_module_config

ipvs_rules_file:
  file.touch:
    - name: /etc/sysconfig/ipvsadm

ipvs_rules_service:
  service.running:
    - name: ipvsadm
    - enable: True
    - require:
      - file: ipvs_rules_file