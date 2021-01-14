base:
  "*":
    - system-init
    - resolv
    {# - schedule #}
  "vm03.fdisk.cc":
    - gitlab/sls/gitlab2