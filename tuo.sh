#!/bin/sh
#shebang -> Use bash as shell interpreter.

#Author: Francisco Amoros Cubells
#About: This file it's for get an url of yt (provide termux) and extract an mp3
echo $0 " <-> " $@
sleep 3

# Create variables for colors in the shell
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

#Debug x -> Display commands and arguments as they are executed.
#Debug v -> Display input lines as they read.
#set -vx

# e -> If a command exits with an error exits.
# u -> Treat unasigned variables as errors.
set -eu

WD_AYD=$(find $HOME -type d -name ayd )

if [[ $(git -C $WD_AYD fetch --dry-run 2>&1 | wc -l) -gt 0 ]]; then

  #Launch in background stdout and stderr don't show, then get the PID
  git -C $WD_AYD pull --force 1>/dev/null 2>/dev/null &
  INS_PID=$!

  #See if the process it's running then do things
  while kill -0 "$INS_PID" >/dev/null 2>&1; do
    #play an animation while it's upgrading the script
    echo -ne $GREEN "Upgrading ayd (/)" $NC "\r"
    sleep .3
    echo -ne $GREEN "Upgrading ayd (|)" $NC "\r"
    sleep .3
    echo -ne $GREEN "Upgrading ayd (\)" $NC "\r"
    sleep .3
  done

  #show when its installed
  echo -ne $BLUE "Upgraded  ayd     " $NC "\n"

  #
  #execute the command with the new updated script
  exec $0 $@
  exit 1

fi


echo donete
sleep 5
