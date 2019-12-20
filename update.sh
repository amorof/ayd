#!/bin/bash

pkg install git
git fetch
pip install -upgrade youtube-dl &
PID=$!
echo "actualizando Youtube-dl"
wait $PID

clear

echo "Youtube-dl Actualizado "


