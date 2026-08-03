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
c tar -xf /tmp/files.tar -C /tmp
c cp -r "/tmp/files/.nixos" "$HOME"

printc "Modifying configuration"
printf "\n%bAdjusting username and hostname%b\n" "$BLUE" "$NC"
sed -i "s/USERNAME/$USER/g" "$HOME/.nixos/configuration.nix"
sed -i "s/HOSTNAME/$HOSTNAME/g" "$HOME/.nixos/flake.nix"
sed -i "s/USERNAME/$USER/g" "$HOME/.nixos/home.nix"
if grep -q "0x10de" /sys/bus/pci/devices/*/vendor; then
  printf "\n%bAdding nvidia modification%b\n" "$BLUE" "$NC"
  cat "/tmp/files/mod/nvidia.nix" >> "$HOME/.nixos/configuration.nix"
fi
printf "\n%bClosing configuration%b\n" "$BLUE" "$NC"
echo "}" >> "$HOME/.nixos/configuration.nix"

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
