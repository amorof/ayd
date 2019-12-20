#!/bin/bash

pkg_install()
{
    if [[ $(pkg list-installed | grep $1 | wc -l) -eq 0 ]]; then
        pkg install $1
    fi
}

pkg_install git
git pull | tail -n1
pip install -upgrade youtube-dl 1>/dev/null &
PID=$!
echo "actualizando Youtube-dl"
wait $PID


echo "Youtube-dl Actualizado "


