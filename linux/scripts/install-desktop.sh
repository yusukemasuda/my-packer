#!/bin/bash -eu

if [[ $DESKTOP =~ true ]]; then
    echo "==> Installing a package 'Ubuntu Desktop'"
    apt-get -y install ubuntu-desktop
fi