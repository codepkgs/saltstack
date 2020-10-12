base:
  "*":
    - system-init
    - ntpd
    - resolv
    - nfs
    - docker-ce

  "L@vm09.fdisk.cc,vm10.fdisk.cc":
    - nginx
    - memcached
    - java

  "L@vm11.fdisk.cc":
    - java
    - jenkins
    - nginx
