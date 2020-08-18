{% if grains['fqdn'] == 'vm11.fdisk.cc' %}
nfs_role: server
nfs_exports:
  - name: /data/nfs
    clients:
    - hosts: '10.0.100.0/24'
      options:
        - 'rw'
        - 'async'
        - 'no_subtree_check'
        - 'no_root_squash'
{% else %}
nfs_role: client
nfs_mounts:
  - server: 10.0.100.11
    status: mount
    {# status: umount #}
    remote_dir: /data/nfs
    local_dir: /data/nfs
    persist: True
    opts: '_netdev,defaults,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2'
{% endif %}