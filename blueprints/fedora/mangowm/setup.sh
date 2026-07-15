#!/bin/bash

set -euo pipefail

# colors
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;94m'
GREEN='\033[0;32m'
NC='\033[0m'

function c() {
  while ! "$@"; do
    printf "\n%bCommand \"%b%s%b\" has failed%b\n" "$RED" "$YELLOW" "$*" "$RED" "$NC"
    printf "%bYou may have to fix the problem manually before continuing%b\n\n" "$YELLOW" "$NC"
    printf "r = Retry this command\n"
    printf "e = Exit\n"
    printf "s = Skip this command\n"
    printf "or enter a command to execute it"
    read -rp "[r/e/s]: " p
    case $p in
      [Rr]) printf "%bRetrying..%b\n "$BLUE" "$NC"" ;;
      [Ee])  printf "%bExiting..%b\n" "$RED" "$NC"; exit 1 ;;
      [Ss]) printf "%bSkipped this command%b\n" "$YELLOW" "$NC"; return 0 ;;
      *) printf "executing %s.." "$BLUE" "$p" "$NC"; $p ;;
    esac
  done
}

clear

printf "$(cat << EOF
${BLUE}                                                          
██ ▄▄  ▄▄ ▄▄▄▄▄▄ ▄▄▄▄ ▄▄▄▄▄▄ ▄▄▄  ▄▄    ▄▄     ▄▄▄ ▄▄▄▄▄▄ ▄▄  ▄▄▄  ▄▄  ▄▄ 
██ ███▄██   ██  ███▄▄   ██  ██▀██ ██    ██    ██▀██  ██   ██ ██▀██ ███▄██ 
██ ██ ▀██   ██  ▄▄██▀   ██  ██▀██ ██▄▄▄ ██▄▄▄ ██▀██  ██   ██ ▀███▀ ██ ▀██ 
${NC}
EOF
)"

printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
printf "%bUpdating system..%b\n" "$BLUE" "$NC"
c sudo dnf update --refresh -y
printf "%bUpdated system%b\n" "$GREEN" "$NC"

if ! rpm -q terra-release &>/dev/null; then
  printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
  printf "%bInstalling terra repository..%b\n" "$BLUE" "$NC"
  c sudo dnf in -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
  printf "%bInstalled terra repository%b\n" "$GREEN" "$NC"
fi

if ! [[ -f "/etc/yum.repos.d/_copr:copr.fedorainfracloud.org:leloubil:wl-clip-persist.repo" ]];then
  printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
printf "%bInstalling wl-clip-persist copr-repository..%b\n" "$BLUE" "$NC"
  c sudo dnf copr enable -y leloubil/wl-clip-persist
  printf "%bInstalled wl-clip-persist copr-repository%b\n" "$GREEN" "$NC"
fi


printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
printf "%bInstalling mangowm..%b\n" "$BLUE" "$NC"
c sudo dnf in -y mangowm
printf "%bInstalled mangowm%b\n" "$GREEN" "$NC"
printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
printf "%bInstalling system basics..%b\n" "$BLUE" "$NC"
c sudo dnf in -y xdg-desktop-portal xdg-desktop-portal-wlr xorg-x11-server-Xwayland xfce-polkit zsh
printf "%bInstalled system basics%b\n" "$GREEN" "$NC"
printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
printf "%bInstalling dotfile requirements..%b\n" "$BLUE" "$NC"
c sudo dnf in -y mako waybar wlogout blueman-manager pavucontrol nmtui playerctl wlsunset swaybg gtklock rofi wl-clip-persist cliphist eza tar git
printf "%bInstalled dotfile requirements%b\n" "$GREEN" "$NC"
printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
printf "%bInstalling core apps..%b\n" "$BLUE" "$NC"
c sudo dnf in -y firefox ghostty loupe gedit thunar thunar-archive-plugin file-roller xdg-user-dirs
printf "%bInstalled core apps%b\n" "$GREEN" "$NC"

if ! [[ -f "$HOME/.config/user-dirs.dirs" ]]; then
  printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
  printf "%bCreating user directories..%b\n" "$BLUE" "$NC"
  c xdg-user-dirs-update
  printf "%bCreated user directories%b\n" "$GREEN" "$NC"
fi

printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
printf "%bDownloading dotfiles..%b\n" "$BLUE" "$NC"
c curl -Lf https://raw.githubusercontent.com/flawada/blueprint/main/blueprints/fedora/mangowm/files.tar | tar -xf - --strip-components=1 -C "$HOME"
printf "%bDownloaded dotfiles%b\n" "$GREEN" "$NC"

# add checksum check
# echo "hash path" | sha256sum --check

if ! [[ -d "$HOME/.zsh/zsh-autosuggestions" && -d "$HOME/.zsh/zsh-syntax-highlighting" ]]; then
  printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
  printf "%bDownloading zsh plugins..%b\n\n" "$BLUE" "$NC"
  if ! [ -d "$HOME/.zsh/zsh-autosuggestions" ]; then
    c git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
  fi
  if ! [ -d "$HOME/.zsh/zsh-syntax-highlighting" ]; then
    c git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.zsh/zsh-syntax-highlighting"
  fi
  printf "%bDownloaded zsh plugins%b\n" "$GREEN" "$NC"
fi

if ! [ -d "$HOME/.config/ghostty/shaders" ]; then
  printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
  printf "%bDownloading ghostty cursor shaders..%b\n" "$BLUE" "$NC"
  c git clone https://github.com/sahaj-b/ghostty-cursor-shaders ~/.config/ghostty/shaders
  printf "%bDownloaded ghostty cursor shaders%b\n" "$GREEN" "$NC"
fi

if ! command -v starship &> /dev/null; then
  printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
  printf "%bInstalling starship..%b\n" "$BLUE" "$NC"
  c curl -sS https://starship.rs/install.sh | sh -s -- -y
  printf "%bInstalled starship%b\n" "$GREEN" "$NC"
fi

if ! [ -d "$HOME/.themes/Graphite-Dark" ]; then
  printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
  printf "%bDownloading graphite-gtk-theme..%b\n" "$BLUE" "$NC"
  sassc=0
  if ! rpm -q sassc &>/dev/null; then
    c sudo dnf in -y sassc
    sassc=1
  fi
  c git clone --depth 1 https://github.com/vinceliuice/Graphite-gtk-theme
  c cd Graphite-gtk-theme
  c ./install.sh -c dark
  c cd ..
  rm -rf Graphite-gtk-theme
  if [[ $sassc -eq 1 ]]; then
    c sudo dnf rm -y sassc
  fi
  printf "%bDownloaded graphite-gtk-theme%b\n" "$GREEN" "$NC"
fi

if ! [ -f "$HOME/.config/mango/wallpaper.png" ]; then
  printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
  printf "%bDownloading wallpaper..%b\n" "$BLUE" "$NC"
  c curl -Lfo "$HOME/.config/mango/wallpaper.png" https://w.wallhaven.cc/full/5y/wallhaven-5yr153.png
  printf "%bDownloaded wallpaper%b\n" "$GREEN" "$NC"
fi

if ! [[ "$SHELL" == *"zsh"* ]]; then
  printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
  printf "%bEnabling zsh..%b\n" "$BLUE" "$NC"
  c sudo chsh -s "$(which zsh)" "$USER"
  printf "%bEnabled zsh%b\n" "$GREEN" "$NC"
fi

if ! grep -q -- "--autologin $USER" /etc/systemd/system/getty@tty1.service.d/override.conf &> /dev/null; then
  printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
  printf "%bEnabling autologin..%b\n" "$BLUE" "$NC"
  printf '[Service]\nExecStart=\nExecStart=-/usr/sbin/agetty --autologin %s --noclear %%I $TERM\n' "$USER" | c sudo systemctl edit getty@tty1 --stdin
  c sudo systemctl daemon-reload
  printf "%bEnabled autologin%b\n" "$GREEN" "$NC"
fi

if grep -q "0x10de" /sys/bus/pci/devices/*/vendor && ! rpm -q akmods; then
  printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
  printf "%bNvidia hardware detected. Install rpmfusion?\nNote: This will install modern drivers. Dont use if you have a legacy card.%b\n" "$BLUE" "$NC"
  while true; do
    read -rn 1 -p "(y/n): " yn
    printf "\n"
    case $yn in
      [Yy]* )
        c sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
        c sudo dnf install -y  gcc kernel-headers kernel-devel akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs xorg-x11-drv-nvidia-libs.i686
        printf "%bCompiling driver modules.. Do not power off your machine. This can take up to 5 minutes.%b\n" "$BLUE" "$NC"
        sleep 10
        if ! sudo akmods; then
          printf "%bSomething went wrong when checking if its compiling. Waiting 3 minutes.%b\n" "$YELLOW" "$NC"
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
