base:
  "*":
    - system-init
    - ntpd
    - resolv
    - nfs

  "L@vm09.fdisk.cc,vm10.fdisk.cc":
    - nginx

  "L@vm11.fdisk.cc":
    - java
    - jenkins
    - nginx