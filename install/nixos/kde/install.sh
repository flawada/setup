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

printc "Downloading configuration"
c curl -Lf https://raw.githubusercontent.com/flawada/setup/main/install/nixos/kde/files.tar -o /tmp/files.tar
c tar -xf /tmp/files.tar --strip-components=1 -C "$HOME"

printc "Rebuilding system"
c sudo nixos-rebuild switch --impure --flake ~/.nixos

if ! [ -f "$HOME/wallpaper.jpg" ]; then
  printc "Downloading wallpaper"
  c curl -Lfo "$HOME/wallpaper.jpg" https://w.wallhaven.cc/full/k8/wallhaven-k8ldjq.jpg
fi

clear
printf "%bDone. Rebooting in 10s..%b\n" "$GREEN" "$NC"
sleep 10
c sudo reboot
