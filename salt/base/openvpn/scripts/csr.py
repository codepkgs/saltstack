import os
import configparser
import sys
import json

filename = 'openvpn.sls'
vars_file = 'openvpn_vars.ini'
csr_section_name = 'csr'
openvpn_section_name = 'openvpn'

ca_csr = {
    "CN": "CA",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [],
    "ca": {
        "expiry": "87600h"
    }
}

openvpn_csr = {
    "CN": "openvpn",
    "hosts": [],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": []
}


def generate_csr_names_field(csr):
    csr_contents = {}

    config = configparser.ConfigParser()
    config.read(vars_file)

    for option in config.options(csr_section_name):
        value = config.get(csr_section_name, option)
        csr_contents[option.upper()] = value
    csr['names'].append(csr_contents)

    return config, csr


def write_csr_file(filename, csr):
    with open(filename, 'w') as fdst:
        json.dump(csr, fdst, indent=4)


def generate_ca_csr_config():
    ca_csr_filename = 'files/ca-csr.json'

    _, csr = generate_csr_names_field(ca_csr)
    write_csr_file(ca_csr_filename, csr)


def generate_openvpn_csr_config():
    openvpn_csr_filename = 'files/openvpn-csr.json'

    config, csr = generate_csr_names_field(openvpn_csr)

    # 写入hosts字段
    for option in config.options(openvpn_section_name):
        if option == 'certs_hosts':
            hosts = config.get(openvpn_section_name, option)

            csr['hosts'].extend(hosts.split(','))

    write_csr_file(openvpn_csr_filename, csr)


if __name__ == "__main__":
    generate_ca_csr_config()
    generate_openvpn_csr_config()
