base:
  "*":
    - system-init
    - resolv
    - php72
    - php74
    {# - schedule #}
  "vm03.fdisk.cc":
    - gitlab
