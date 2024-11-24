#!/bin/sh

#if [[ $UID != 0 ]]; then
#    echo "Please run this script with sudo:"
#    echo "sudo $0 $*"
#    exit 1
#fi

output=$(getgo)

if [ -z "${output}" ]; then
    exit 0
else
    read -p "Removing /usr/local/go.  Are you sure? (Y|y)" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        sudo rm -rf /usr/local/go
    fi

    read -p "Install downloaded file to /usr/local/go? (Y|y)" -n 1 -r go_install
    echo    # (optional) move to a new line
    if [[ $go_install =~ ^[Yy]$ ]]
    then
        echo "Installing ${output} to /usr/local/go"
        sudo tar -C /usr/local -xzvf ${output}
    fi
fi
