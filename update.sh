#!/bin/bash

# si el fichero no existe sale, y si existe se borra, 
# dejando en los dos casos un exit 0
#[! -e log.txt ] || rm log.txt
date>log.txt

pkg_install()
{
    #Si no esta instalado lo instala
    if [[ $(pkg list-installed | grep $1 | wc -l) -eq 0 ]]; then
        pkg install $1
    fi
}

add_log()
{
    echo $1 >log.txt
}

pkg_install git
git pull | tail -n1

add_log "--> pip install --upgrade youtube-dl <--"
pip install --upgrade youtube-dl 1>/dev/null 2>>log.txt &
PID=$!
echo "actualizando Youtube-dl"
wait $PID


echo "Youtube-dl Actualizado "


