#!/bin/bash

# si el fichero no existe sale, y si existe se borra,
# dejando en los dos casos un exit 0
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'
ARGS=$@
NARGS=$#

[ ! -e log.txt ] || rm log.txt

date>>log.txt

WD_AYD=$(find $HOME -type d -name ayd )

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
    if [[ $(git -C $WD_AYD fetch --dry-run 2>&1 | wc -l) -gt 0 ]]; then
        echo -e $YELLOW "Upgrading script" $NC
        add_log $GREEN "--> git pull <--"
        git -C $WD_AYD pull --force 2>>log.txt| tail -n1
        cp $WD_AYD/termux-url-opener $HOME/bin/termux-url-opener
        chmod +x $HOME/bin/termux-url-opener
        chmod +x $WD_AYD/update.sh
        exec $HOME/bin/termux-url-opener $ARGS
        exit 1
    fi
    mkdir -p $HOME/bin
    cp $WD_AYD/termux-url-opener $HOME/bin/termux-url-opener
    echo -e $YELLOW " Script up-to-date " $NC
}

termux-setup-storage &
TSS_PID=$!

add_log $GREEN "--> Installing GIT <--"
pkg_install git
add_log $GREEN "--> Installing FFMPEG <--"
pkg_install ffmpeg
add_log $GREEN "--> Installing PYTHON <--"
pkg_install python
add_log $GREEN "--> Installing PIP <--"
pip install --upgrade pip 1>/dev/null 2>>log.txt
add_log $GREEN "--> pip install --upgrade youtube-dl <--"
pip install --upgrade youtube-dl 1>/dev/null 2>>log.txt

wait $TSS_PID

upd

