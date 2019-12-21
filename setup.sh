#!/bin/bash
#shebang -> Use bash as shell interpreter.

#Author: Francisco Amoros Cubells
#About: This file it's for first setup

# Create variables for colors in the shell
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

#Debug x -> Display commands and arguments as they are executed.
#Debug v -> Display input lines as they read.
set -vx 

# e -> If a command exits with an error exits.
# u -> Treat unasigned variables as errors.
set -eu
