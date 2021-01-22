base:
  "*":
    - system-init
    - resolv
    - php72
    - php74
    - prometheus
    {# - schedule #}
  "vm03.fdisk.cc":
    - gitlab
