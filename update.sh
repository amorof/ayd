#!/bin/bash

# si el fichero no existe sale, y si existe se borra,
# dejando en los dos casos un exit 0
SCRIPTNAME=$0
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
    if [[ $(pkg list-installed 2>/dev/null| grep $1 | wc -l) -eq 0 ]]; then
        echo -e $YELLOW "Installing -> " $1 $NC
        pkg install $1 2>/dev/null
    fi
}

add_log()
{
    echo -e $1 $2 $NC>>log.txt
}

upd()
{
    if [[ $(git fetch --dry-run 2>&1 | wc -l) -gt 0 ]]; then
        echo -e $YELLOW "Upgrading script" $NC
        add_log $GREEN "--> git pull <--"
        git pull --force 2>>log.txt| tail -n1
        mv termux-url-opener $HOME/bin/termux-url-opener
        chmod +x $HOME/bin/termux-url-opener
        chmod +x $SCRIPTNAME
        exec $HOME/bin/termux-url-opener $@
        exit 1
    fi
    echo -e $YELLOW "Script up-to-date" $NC
}

setup-termux-storage &

add_log $GREEN "--> Installing GIT <--"
pkg_install git
add_log $GREEN "--> Installing FFMPEG <--"
pkg_install ffmpeg
add_log $GREEN "--> Installing PYTHON <--"
pkg_install python
add_log $GREEN "--> Installing PIP <--"
pkg_install pip
add_log $GREEN "--> pip install --upgrade youtube-dl <--"
pip install --upgrade youtube-dl 1>/dev/null 2>>log.txt

upd

