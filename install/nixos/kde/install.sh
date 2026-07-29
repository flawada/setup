#!/bin/bash

set -euo pipefail

clear

if [[ $COLUMNS -lt 75 ]]; then
  printf "* %bINSTALLATION%b\n\n" "$BLUE" "$NC"
else
  printf "%*s" "$(( (COLUMNS - 72) / 2 ))"
  printf "%b██ ▄▄  ▄▄ ▄▄▄▄▄▄ ▄▄▄▄ ▄▄▄▄▄▄ ▄▄▄  ▄▄    ▄▄     ▄▄▄ ▄▄▄▄▄▄ ▄▄  ▄▄▄  ▄▄  ▄▄%b\n" "$BLUE" "$NC"
  printf "%*s" "$(( (COLUMNS - 72) / 2 ))"
  printf "%b██ ███▄██   ██  ███▄▄   ██  ██▀██ ██    ██    ██▀██  ██   ██ ██▀██ ███▄██%b\n" "$BLUE" "$NC"
  printf "%*s" "$(( (COLUMNS - 72) / 2 ))"
  printf "%b██ ██ ▀██   ██  ▄▄██▀   ██  ██▀██ ██▄▄▄ ██▄▄▄ ██▀██  ██   ██ ▀███▀ ██ ▀██%b\n\n" "$BLUE" "$NC"
fi


printc "Downloading config"
c curl -Lf https://raw.githubusercontent.com/flawada/setup/main/install/nixos/kde/files.tar -o /tmp/files.tar
c tar -xf /tmp/files.tar --strip-components=1 -C "$HOME"


printc "Updating"
c sudo nixos-rebuild switch --impure --flake ~/.nixos

#if ! [ -f "$HOME/.config/mango/wallpaper.png" ]; then
#  printc "Downloading wallpaper"
#  c curl -Lfo "$HOME/.config/mango/wallpaper.png" https://w.wallhaven.cc/full/5y/wallhaven-5yr153.png
#fi

exit # del
clear
printf "%bDone. Rebooting in 10s..%b\n" "$GREEN" "$NC"
sleep 10
c sudo reboot
