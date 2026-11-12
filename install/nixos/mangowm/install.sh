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
c curl -Lf https://raw.githubusercontent.com/flawada/setup/main/install/nixos/mangowm/files.tar -o /tmp/files.tar
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

if ! [ -f "$HOME/.config/mango/wallpaper.jpg" ]; then
  printc "Downloading wallpaper & Running one time user settings"
  c nix-shell -p xdg-user-dirs --run xdg-user-dirs-update
  c curl -Lfo "$HOME/.config/mango/wallpaper.jpg" https://w.wallhaven.cc/full/zp/wallhaven-zp2gdy.png
fi

if ! [ -d "$HOME/.themes/Graphite-Dark" ]; then
  printc "Downloading Graphite-gtk-theme"
  c nix-shell -p git --run "git clone --depth 1 https://github.com/vinceliuice/Graphite-gtk-theme /tmp/Graphite-gtk-theme"
  c nix-shell -p sassc --run "cd /tmp/Graphite-gtk-theme && ./install.sh -n Graphite -c dark -l"
fi

if ! [ -d "$HOME/.config/ghostty/shaders" ]; then
  printc "Downloading ghostty cursor shaders"
  c nix-shell -p git --run "git clone --depth 1 https://github.com/sahaj-b/ghostty-cursor-shaders ~/.config/ghostty/shaders"
fi

printc "Rebuilding system"
c sudo nixos-rebuild switch --impure --flake ~/.nixos

clear
printf "%bDone. Rebooting in 10s..%b\n" "$GREEN" "$NC"
sleep 10
c reboot
