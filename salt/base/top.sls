base:
  "*":
    - system-init
    - ntpd
    - resolv
    - nfs
  
  "L@vm11.fdisk.cc":
    - java
    - jenkins