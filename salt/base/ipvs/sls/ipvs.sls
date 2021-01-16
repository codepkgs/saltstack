ipvs_pkgs:
  pkg.installed:
    - pkgs:
      - ipvsadm
      - ipset
      - sysstat
      - conntrack
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
      - nf_conntrack
      - br_netfilter