base:
  "*":
    - system-init
    - resolv
    - chrony
  "L@vm03.fdisk.cc":
    - gitlab
prod:
  "*":
    - resolv
