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

printc "Updating system"
c sudo dnf update --refresh -y

if ! rpm -q terra-release &>/dev/null; then
  printc "Installing terra repository"
  c sudo dnf in -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
fi

if ! [[ -f "/etc/yum.repos.d/_copr:copr.fedorainfracloud.org:leloubil:wl-clip-persist.repo" ]];then
  printc "Installing wl-clip-persist copr-repository"
  c sudo dnf copr enable -y leloubil/wl-clip-persist
fi


printc "Installing mangowm"
c sudo dnf in -y mangowm
printc "Installing system basics"
c sudo dnf in -y xdg-desktop-portal xdg-desktop-portal-wlr xorg-x11-server-Xwayland xfce-polkit zsh
printc "Installing dotfile requirements"
c sudo dnf in -y mako waybar wlogout blueman-manager pavucontrol nmtui playerctl wlsunset swaybg gtklock rofi wl-clip-persist cliphist eza tar git
printc "Installing core apps"
c sudo dnf in -y firefox ghostty loupe gedit thunar thunar-archive-plugin file-roller xdg-user-dirs

if ! [[ -f "$HOME/.config/user-dirs.dirs" ]]; then
  printc "Creating user directories"
  c xdg-user-dirs-update
fi

printc "Downloading dotfiles"
c curl -Lf https://raw.githubusercontent.com/flawada/blueprint/main/install/fedora/mangowm/files.tar -o /tmp/files.tar
c tar -xf /tmp/files.tar --strip-components=1 -C "$HOME"


if ! [[ -d "$HOME/.zsh/zsh-autosuggestions" && -d "$HOME/.zsh/zsh-syntax-highlighting" ]]; then
  printc "Downloading zsh plugins"
  if ! [ -d "$HOME/.zsh/zsh-autosuggestions" ]; then
    c git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
  fi
  if ! [ -d "$HOME/.zsh/zsh-syntax-highlighting" ]; then
    c git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.zsh/zsh-syntax-highlighting"
  fi
fi

if ! [ -d "$HOME/.config/ghostty/shaders" ]; then
  printc "Downloading ghostty cursor shaders"
  c git clone https://github.com/sahaj-b/ghostty-cursor-shaders ~/.config/ghostty/shaders
fi

if ! command -v starship &> /dev/null; then
  printc "Installing starship"
  c curl -sS https://starship.rs/install.sh | sh -s -- --yes --silent
fi

if ! [ -d "$HOME/.themes/Graphite-Dark" ]; then
  printc "Downloading graphite-gtk-theme"
  sassc=0
  if ! rpm -q sassc &>/dev/null; then
    c sudo dnf in -y sassc
    sassc=1
  fi
  c git clone --depth 1 https://github.com/vinceliuice/Graphite-gtk-theme
  c cd Graphite-gtk-theme
  c ./install.sh -c dark
  c cd ..
  c rm -rf Graphite-gtk-theme
  if [[ $sassc -eq 1 ]]; then
    c sudo dnf rm -y sassc
  fi
fi

if ! [ -f "$HOME/.config/mango/wallpaper.png" ]; then
  printc "Downloading wallpaper"
  c curl -Lfo "$HOME/.config/mango/wallpaper.png" https://w.wallhaven.cc/full/5y/wallhaven-5yr153.png
fi

if ! [[ "$SHELL" == *"zsh"* ]]; then
  printc "Enabling zsh"
  c sudo chsh -s "$(which zsh)" "$USER"
fi

if ! grep -q -- "--autologin $USER" /etc/systemd/system/getty@tty1.service.d/override.conf &> /dev/null; then
  printc "Enabling autologin"
  #printf '[Service]\nExecStart=\nExecStart=-/usr/sbin/agetty --autologin %s --noclear %%I $TERM\n' "$USER" | c sudo systemctl edit getty@tty1 --stdin
  GETTY_CONF=$(printf '[Service]\nExecStart=\nExecStart=-/usr/sbin/agetty --autologin %s --noclear %%I $TERM\n' "$USER")
  c sudo systemctl edit getty@tty1 --stdin <<< "$GETTY_CONF"
  c sudo systemctl daemon-reload
fi

if grep -q "0x10de" /sys/bus/pci/devices/*/vendor && ! rpm -q akmods; then
  printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
  printf "%bNvidia hardware detected. Install rpmfusion?\nNote: This will install modern drivers. Dont use if you have a legacy card.%b\n" "$BLUE" "$NC"
  while true; do
    read -rn 1 -p "(y/n): " yn
    printf "\n"
    case $yn in
      [Yy]* )
        printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
        c sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
        c sudo dnf install -y  gcc kernel-headers kernel-devel akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs xorg-x11-drv-nvidia-libs.i686
        printf "%bCompiling driver modules.. Do not power off your machine. This can take up to 5 minutes.%b\n" "$BLUE" "$NC"
        sleep 10
        if ! sudo akmods; then
          printf "%bSomething went wrong when checking if its compiling.%b Waiting 3 minutes..%b\n" "$YELLOW" "$BLUE" "$NC"
          sleep 180
        fi
        clear
        printf "%bDone. Rebooting in 10s..%b\n" "$GREEN" "$NC"
        sleep 10
        c sudo reboot
        break;;
      [Nn]* ) break;;
      * ) printf "%bInvalid.%b\n" "$YELLOW" "$NC";;
    esac
  done
fi

clear
printf "%bDone. relogging in 10s..%b\n" "$GREEN" "$NC"
sleep 10
c loginctl terminate-user $USER
