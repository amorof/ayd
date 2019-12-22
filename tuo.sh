#!/data/data/com.termux/files/usr/bin/bash
#shebang -> Use bash as shell interpreter.

# #!/bin/sh

#Author: Francisco Amoros Cubells
#About: This file it's for get an url of yt (provide termux) and extract an mp3

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
set -u
#set -e

#Find where is the git directory of the program
WD_AYD=$(find $HOME -type d -name ayd )

if [ $(git -C $WD_AYD fetch --dry-run 2>&1 | wc -l) -gt 0 ] ; then

  #Launch in background stdout and stderr don't show, then get the PID
  git -C $WD_AYD pull --force 1>/dev/null 2>/dev/null &
  INS_PID=$!

  #See if the process it's running then do things
  while kill -0 "$INS_PID" >/dev/null 2>&1; do
    #play an animation while it's upgrading the script
    printf "$GREEN Upgrading ayd (/) $NC \r"
    sleep .3
    printf "$GREEN Upgrading ayd (|) $NC \r"
    sleep .3
    printf "$GREEN Upgrading ayd (\) $NC \r"
    sleep .3
  done

  #show when its installed
  printf "$BLUE Upgraded  ayd      $NC \n"

  #execute the command with the new updated script
  exec $0 $@
  exit 1
fi

pip_upg_if_need()
{
  #If it isn't updated then update
  if [ $(pip list --outdated 2>&1 | grep $1 | wc -l) -gt 0 ] ; then

    #Launch in background stdout and stderr don't show, then get the PID
    pip install --upgrade $1 1>/dev/null 2>/dev/null &
    INS_PID=$!

    #See if the process it's running then do things
    while kill -0 "$INS_PID" >/dev/null 2>&1; do
      #play an animation while it's installing the program
      printf "$GREEN Upgrading $1 (/) $NC \r"
      sleep .3
      printf "$GREEN Upgrading $1 (|) $NC \r"
      sleep .3
      printf "$GREEN Upgrading $1 (\) $NC \r"
      sleep .3
    done

    #show when its installed
    printf "$BLUE Upgraded  $1        $NC \n"
  fi
}

pip_upg_if_need youtube-dl
pip_upg_if_need mutagen

case "$1" in
  *youtu*)

    printf "${YELLOW} Youtube-dl ${NC}\n"
    TMP_DIR="$(mktemp -dt musica-dl.XXXXXX)"
    OUT_DIR="/storage/emulated/0/Music/ayd"
    CONFIG="${HOME}/.config/musica-dl"

    mkdir "${TMP_DIR}"/raw "${TMP_DIR}"/cooked "${TMP_DIR}"/opt

    youtube-dl \
      --ignore-errors \
      --write-thumbnail \
      --skip-download \
      --output "${TMP_DIR}/cooked/%(title)s" \
      -- "$@" \
      1>/dev/null &


    youtube-dl \
      --ignore-errors \
      --format 'bestaudio' \
      --output "${TMP_DIR}/raw/%(title)s" \
      -- "$@" \
      1>/dev/null &

    YDL_PID=$!

    FFMPEG_PID=""

      NDL=($YDL_PID)
    while kill -0 "$NDL" >/dev/null 2>&1; do

      if [ "$(ls -A "${TMP_DIR}"/raw/)" ]; then

        for file in "${TMP_DIR}"/raw/* ; do

          filenamebase=$(basename -- "$file")
          extension="${filenamebase##*.}"

          if [ -z "${extension}" ]; then
            printf "ext->$extension          \n"

            mv "${file}" "${TMP_DIR}/opt/"

            BN=$(basename -- "${file}")

            printf "$BLUE Encoding to mp3 $BN  $NC \n"
            printf "$BLUE "${TMP_DIR}"/opt/"${BN}"  $NC \n"
            ffmpeg \
              -hide_banner \
              -i "${TMP_DIR}"/opt/"${BN}" \
              -codec:a libmp3lame \
              -qscale:a 2 \
              -vn \
              -map_metadata -1 \
              "${TMP_DIR}/cooked/${file##*/}.mp3" \
              1>>log.txt 2>>log.txt &

            YDL_PID="$! $YDL_PID"
          fi
        done
      fi

      #clear
      printf "$BLUE $YDL_PID $NC \n"
      printf "$BLUE $(ls "${TMP_DIR}/opt/") $NC \n"

      NDL=($YDL_PID)

      #Count the process finished
      count=0
      for i in "${NDL[@]}"; do

        if ! ps -p "$i" > /dev/null
        then
          ((count=count + 1))
        fi
      done

      #play an animation while it's encoding to mp3
      printf "$GREEN Encoding to mp3 (/)-($count/${#NDL[@]}) $NC \r"
      sleep .3
      printf "$GREEN Encoding to mp3 (|)-($count/${#NDL[@]}) $NC \r"
      sleep .3
      printf "$GREEN Encoding to mp3 (\)-($count/${#NDL[@]}) $NC \r"
      sleep .3

    done

    mkdir -p "${OUT_DIR}"

    for file in  "${TMP_DIR}"/cooked/* ; do
      filenamebase=$(basename -- "$file")
      extension="${filenamebase##*.}"
      filename="${filenamebase%.*}"
      #mkdir -p "${TMP_DIR}"/cooked/"${filename}"


      if [ ! "${extension}" = "jpg" ]; then
        mkdir -p "${TMP_DIR}"/cooked/"${filename}"
        mid3v2 --picture="${TMP_DIR}/cooked/${filename}.jpg" \
          "${TMP_DIR}/cooked/${filename}.${extension}"

        rm "${TMP_DIR}/cooked/${filename}.jpg"
        mv "${file}" "${TMP_DIR}"/cooked/"${filename}"/
      fi
    done

    cp -rf "${TMP_DIR}"/cooked/* "${OUT_DIR}"

    rm -rf "${TMP_DIR}"

    ;;
  *)
    printf "Unhandled URL type: $1"
esac

clear
printf "$BLUE Done. $NC"
sleep 10
