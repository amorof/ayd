#!/bin/bash

# si el fichero no existe sale, y si existe se borra, 
# dejando en los dos casos un exit 0
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'
[ ! -e log.txt ] || rm log.txt

date>>log.txt

pkg_install()
{
    #Si no esta instalado lo instala
    if [[ $(pkg list-installed | grep $1 | wc -l) -eq 0 ]]; then
        pkg install $1
    fi
}

add_log()
{
    echo -e $1 $2 $NC>>log.txt 
}

pkg_install git
git pull | tail -n1 2>>log.txt

add_log $GREEN "--> pip install --upgrade youtube-dl <--"
pip install --upgrade youtube-dl 1>/dev/null 2>>log.txt &
PID=$!
echo "actualizando don Youtube-dl"
wait $PID


echo "Youtube-dl Actualizado "


