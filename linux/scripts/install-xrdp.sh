#!/bin/bash -eu

if [[ $DESKTOP =~ true ]]; then
    echo "==> Installing a package 'Remote Desktop Service'"
    apt-get -y install xrdp
    systemctl enable xrdp
fi