#!/bin/bash

pkg_install()
{
    if [[ $(pkg list-installed | grep $1 | wc -l) -eq 1 ]]; then
        pkg install $1
    fi
}

pkg_install git
git pull
pip install -upgrade youtube-dl &
PID=$!
echo "actualizando Youtube-dl"
wait $PID


echo "Youtube-dl super Actualizado "


