#!/bin/bash

set -euo pipefail

# colors
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;94m'
GREEN='\033[0;32m'
NC='\033[0m'

clear

printf "$(cat << EOF
${BLUE}                                                          
██ ▄▄  ▄▄ ▄▄▄▄▄▄ ▄▄▄▄ ▄▄▄▄▄▄ ▄▄▄  ▄▄    ▄▄     ▄▄▄ ▄▄▄▄▄▄ ▄▄  ▄▄▄  ▄▄  ▄▄ 
██ ███▄██   ██  ███▄▄   ██  ██▀██ ██    ██    ██▀██  ██   ██ ██▀██ ███▄██ 
██ ██ ▀██   ██  ▄▄██▀   ██  ██▀██ ██▄▄▄ ██▄▄▄ ██▀██  ██   ██ ▀███▀ ██ ▀██ 
${NC}
EOF
)"

if ! rpm -q terra-release &>/dev/null; then
  printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
  printf "%bInstalling terra repository..%b\n" "$BLUE" "$NC"
  sudo dnf in -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
fi

printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
printf "%bInstalling copr-repositorys..%b\n" "$BLUE" "$NC"
sudo dnf copr enable -y leloubil/wl-clip-persist
sudo dnf copr enable -y sneexy/zen-browser

printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
printf "%bInstalling mangowm..%b\n" "$BLUE" "$NC"
sudo dnf in -y mangowm
printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
printf "%bInstalling system basics..%b\n" "$BLUE" "$NC"
sudo dnf in -y xdg-desktop-portal xdg-desktop-portal-wlr xorg-x11-server-Xwayland xfce-polkit zsh
printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
printf "%bInstalling dotfile requirements..%b\n" "$BLUE" "$NC"
sudo dnf in -y mako waybar wlogout blueman-manager pavucontrol nmtui playerctl wlsunset swaybg gtklock rofi wl-clip-persist cliphist eza tar git
printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
printf "%bInstalling core apps..%b\n" "$BLUE" "$NC"
sudo dnf in -y zen-browser ghostty loupe gedit thunar thunar-archive-plugin file-roller xdg-user-dirs

printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
printf "%bUpdating user directories..%b\n" "$BLUE" "$NC"
xdg-user-dirs-update

printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
printf "%bDownloading dotfiles..%b\n" "$BLUE" "$NC"
curl -Lf https://raw.githubusercontent.com/flawada/blueprint/main/blueprints/fedora/mangowm/files.tar | tar -xf - --strip-components=1 -C "$HOME"

#if ! [ -e "$HOME/.zshrc" ]; then
#    printf "%bError: Something went wrong when downloading. %b\n" "$RED" "$NC"
#    exit 1
#fi

# add checksum check
# echo "hash path" | sha256sum --check

printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
printf "%bEnabling zsh..%b\n" "$BLUE" "$NC"
sudo chsh -s "$(which zsh)" "$USER"

printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
printf "%bEnabling autologin..%b\n" "$BLUE" "$NC"
printf '[Service]\nExecStart=\nExecStart=-/usr/sbin/agetty --autologin %s --noclear %%I $TERM\n' "$USER" | sudo systemctl edit getty@tty1 --stdin

printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
printf "%bDownloading zsh plugins..%b\n" "$BLUE" "$NC"
if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ]; then
  git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
fi
if [ ! -d "$HOME/.zsh/zsh-syntax-highlighting" ]; then
  git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.zsh/zsh-syntax-highlighting"
fi

printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
printf "%bDownloading starship..%b\n" "$BLUE" "$NC"
curl -sS https://starship.rs/install.sh | sh -s -- -y

printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
printf "%bDownloading graphite-gtk-theme..%b\n" "$BLUE" "$NC"
sassc=0
if ! rpm -q sassc &>/dev/null; then
  sudo dnf in -y sassc
  sassc=1
fi
git clone --depth 1 https://github.com/vinceliuice/Graphite-gtk-theme
cd Graphite-gtk-theme
./install.sh -c dark
cd ..
rm -rf Graphite-gtk-theme
if [[ $sassc -eq 1 ]]; then
  sudo dnf rm -y sassc
fi

printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
printf "%bDownloading basic wallpaper..%b\n" "$BLUE" "$NC"
curl -Lfo "$HOME/.config/mango/wallpaper.png" https://w.wallhaven.cc/full/5y/wallhaven-5yr153.png

if lspci | grep -iq nvidia; then
  printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
  printf "Nvidia hardware detected. Install rpmfusion?\nNote: This will install modern drivers. Dont use if you have a legacy card.\n"
  while true; do
    read -rn 1 -p "(y/n): " yn
    printf "\n"
    case $yn in
      [Yy]* )
        sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
        sudo dnf install -y  gcc kernel-headers kernel-devel akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs xorg-x11-drv-nvidia-libs.i686
        printf "Compiling driver modules. This might take a while.."
        sleep 10
        while ps aux | grep -v grep | grep -qE "akmods|akmodsbuild"; do
    	    printf "."
    	    sleep 5
  	    done
        printf "\n"
        if sudo akmods; then
          printf "Done.\n"
        else
          printf "Something went wrong when checking if its compiling. Waiting 3 minutes.\n"
          sleep 180
        fi
        break;;
      [Nn]* ) break;;
      * ) printf "Invalid\n";;
    esac
  done
  printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
fi

printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"

clear

printf "%bDone. Rebooting in 10s..%b\n" "$GREEN" "$NC"
sleep 10
sudo reboot
