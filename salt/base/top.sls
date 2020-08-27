base:
  "*":
    - system-init
    - ntpd
    - resolv
    - nfs

  "L@vm09.fdisk.cc,vm10.fdisk.cc":
    - nginx
    - memcached

  "L@vm11.fdisk.cc":
    - java
    - jenkins
    - nginx