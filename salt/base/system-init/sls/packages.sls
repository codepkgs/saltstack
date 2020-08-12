{% if grains['os_family'].lower() == 'redhat' %}
system_init_packages:
  pkg.installed:
    - pkgs:
        - gcc
        - gcc-c++
        - net-tools
        - htop
        - iftop
        - ack
        - tmux
        - nmap-ncat
        - wget
        - python3
{% endif %}