#!/bin/bash

set -e

clean() {
    rm -rf certs/* &> /dev/null
    rm -rf files/ca-csr.json &> /dev/null
    rm -rf files/openvpn-csr.json &> /dev/null
    rm -rf ../files/*.key &> /dev/null
    rm -rf ../files/*.crt &> /dev/null
    rm -rf ../files/dh.pem &> /dev/null
}

ca() {
    local cert_filename='certs/ca.pem'
    local cert_csr='ca.csr'
    local csr_json='ca-csr.json'

    # openvpn-csr
    python csr.py

    if [ ! -f "$cert_filename" ]; then
        cfssl gencert -initca ./files/$csr_json | cfssljson -bare ./certs/ca
        rm -rf ./certs/$cert_csr
    else
        echo "warning: ca cert is exist now"
    fi
}

openvpn() {
    local cert_filename='certs/openvpn.pem'
    local cert_csr='openvpn.csr'
    local csr_json='openvpn-csr.json'

    if [ ! -f "$cert_filename" ]; then
        cfssl gencert -ca ./certs/ca.pem -ca-key ./certs/ca-key.pem \
            -config ./files/config.json -profile peer \
            ./files/$csr_json | cfssljson -bare ./certs/openvpn
        rm -rf ./certs/$cert_csr &> /dev/null
    else
        echo "warning: openvpn cert is exist now"
    fi
}

gen_dh() {
    filename='../files/dh.pem'
    if [ ! -f "$filename" ]; then
        openssl dhparam -out $filename 2048
    fi
}

copy() {
    cp certs/ca.pem ../files/ca.crt
    cp certs/ca.pem ../openvpn_client_config/ca.crt
    # cp certs/ca-key.pem ../files/ca.key
    cp certs/openvpn.pem ../files/openvpn.crt
    cp certs/openvpn-key.pem ../files/openvpn.key
}

help() {
    echo "before use this script, please modify json file in files directory"
    echo "usage: $0 [clean]"
    exit 0
}


if [ "$#" -eq 0 ]; then
    ca
    openvpn
    gen_dh
    copy
    exit 0
fi

if [ "$#" -eq 1 ]; then
    ops="$1"
else
    help
fi

case $ops in
    clean)
        clean
        ;;
    *)
        help
esac
