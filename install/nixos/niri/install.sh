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
c curl -Lf https://raw.githubusercontent.com/flawada/setup/main/install/nixos/niri/files.tar -o /tmp/files.tar
c tar -xf /tmp/files.tar -C /tmp
c cp -r "/tmp/files/.nixos" "$HOME"
c cp -r "/tmp/files/.config" "$HOME"

printc "Modifying configuration"
printf "adjusting username and hostname\n"
#sed -i "s/USERNAME/$USER/g" "$HOME/.nixos/configuration.nix"
sed -i "s/HOSTNAME/$HOSTNAME/g" "$HOME/.nixos/flake.nix"
if grep -q "0x10de" /sys/bus/pci/devices/*/vendor; then
  printf "adding nvidia modification\n"
  cat "/tmp/files/mod/nvidia.nix" >> "$HOME/.nixos/configuration.nix"
fi
printf "closing configuration\n"
echo "}" >> "$HOME/.nixos/configuration.nix"

printc "Rebuilding system"
c nix flake update --flake ~/.nixos
c sudo nixos-rebuild boot --impure --flake ~/.nixos

if ! [ -f "$HOME/.config/niri/wallpaper.jpg" ]; then
  printc "Downloading wallpaper"
  c curl -Lfo "$HOME/.config/niri/wallpaper.jpg" https://w.wallhaven.cc/full/k8/wallhaven-k8ldjq.jpg
fi

if ! [ -d "$HOME/.config/ghostty/shaders" ]; then
  printc "Downloading ghostty cursor shaders"
  c git clone https://github.com/sahaj-b/ghostty-cursor-shaders ~/.config/ghostty/shaders
fi

clear
printf "%bDone. Rebooting in 10s..%b\n" "$GREEN" "$NC"
sleep 10
c sudo reboot
