base:
  "*":
    - system-init
    - resolv
    - php74
    {# - schedule #}
  "vm03.fdisk.cc":
    - gitlab
