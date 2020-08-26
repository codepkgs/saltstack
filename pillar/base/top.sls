base:
  "*":
    - system-init
    - ntpd
    - resolv
    - nfs
    - schedule
    - jenkins

  "L@vm09.fdisk.cc,vm10.fdisk.cc":
    - nginx/sls/nginx_stream