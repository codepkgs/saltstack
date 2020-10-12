import os
import configparser
import sys

filename = 'etcd.sls'
var_file = 'etcd_vars.ini'

section_name = 'etcd_cluster'


def gen_pillar_certs():
    ca_filename = 'certs/ca.pem'
    peer_ca_filename = 'certs/ca.pem'
    etcd_filename = 'certs/etcd.pem'
    etcd_key_filename = 'certs/etcd-key.pem'
    etcd_peer_filename = 'certs/etcd.pem'
    etcd_peer_key_filename = 'certs/etcd-key.pem'

    with open(filename, 'a') as fdst:
        with open(ca_filename, 'r') as f:
            fdst.write('etcd_trusted_ca_content: |{}'.format(os.linesep))
            for line in f:
                fdst.write('{}{}'.format('    ', line))

        with open(peer_ca_filename, 'r') as f:
            fdst.write('etcd_peer_trusted_ca_content: |{}'.format(os.linesep))
            for line in f:
                fdst.write('{}{}'.format('    ', line))

        with open(etcd_filename, 'r') as f:
            fdst.write('etcd_cert_content: |{}'.format(os.linesep))
            for line in f:
                fdst.write('{}{}'.format('   ', line))

        with open(etcd_key_filename, 'r') as f:
            fdst.write('etcd_key_content: |{}'.format(os.linesep))
            for line in f:
                fdst.write('{}{}'.format('   ', line))

        with open(etcd_peer_filename, 'r') as f:
            fdst.write('etcd_peer_cert_content: |{}'.format(os.linesep))
            for line in f:
                fdst.write('{}{}'.format('   ', line))

        with open(etcd_peer_key_filename, 'r') as f:
            fdst.write('etcd_peer_key_content: |{}'.format(os.linesep))
            for line in f:
                fdst.write('{}{}'.format('   ', line))


def gen_pillar_config():
    etcd_initial_cluster = ''
    config = configparser.ConfigParser()
    config.read(var_file)
    if not config.has_section(section_name):
        print('the section: {}, NOT FOUND'.format(section_name))
        sys.exit(0)

    for option in config.options(section_name):
        value = config.get(section_name, option)
        etcd_initial_cluster += '{}={},'.format(option, value)

    etcd_initial_cluster = etcd_initial_cluster.rstrip(',')

    with open(filename, 'w') as fdst:
        fdst.write("etcd_initial_cluster: '{}'{}".format(
            etcd_initial_cluster, os.linesep))


if __name__ == "__main__":
    gen_pillar_config()
    gen_pillar_certs()
