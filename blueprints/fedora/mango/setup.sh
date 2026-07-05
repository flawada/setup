#!/bin/bash

git=0

set -euo pipefail

if ! rpm -q terra-release &>/dev/null; then
  sudo dnf in -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
fi

sudo dnf copr enable -y leloubil/wl-clip-persist
sudo dnf copr enable -y sneexy/zen-browser

sudo dnf in -y mangowm ghostty thunar thunar-archive-plugin file-roller loupe zen-browser waybar mako wlsunset swaybg wl-clip-persist cliphist gtklock playerctl rofi wlogout blueman-manager pavucontrol nmtui xdg-desktop-portal xdg-desktop-portal-wlr xorg-x11-server-Xwayland xfce-polkit gedit nwg-look xdg-user-dirs zsh eza
# engrampa

if ! rpm -q git &>/dev/null; then
  sudo dnf in -y git
  git=1
fi

if ! rpm -q tar &>/dev/null; then
  sudo dnf in -y tar
  tar=1
fi

if ! rpm -q sassc &>/dev/null; then
  sudo dnf in -y sassc
  sassc=1
fi

xdg-user-dirs-update


curl -sLf https://raw.githubusercontent.com/flawada/blueprint/main/blueprints/fedora/mango/files.tar | tar -xf - --strip-components=1 -C "$HOME"

#if ! [ -e "$HOME/.zshrc" ]; then
#    printf "%bError: Something went wrong when downloading. %b\n" "$RED" "$NC"
#    exit 1
#fi

# add checksum check
# echo "hash path" | sha256sum --check

sudo chsh -s "$(which zsh)" "$USER"
printf '[Service]\nExecStart=\nExecStart=-/usr/sbin/agetty --autologin %s --noclear %%I $TERM\n' "$USER" | sudo systemctl edit getty@tty1 --stdin
if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ]; then
  git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
fi
if [ ! -d "$HOME/.zsh/zsh-syntax-highlighting" ]; then
  git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.zsh/zsh-syntax-highlighting"
fi
curl -sS https://starship.rs/install.sh | sh -s -- -y

git clone --depth 1 https://github.com/vinceliuice/Graphite-gtk-theme
./Graphite-gtk-theme/install.sh -c dark
rm -rf Graphite-gtk-theme

curl -Lso "$HOME/.config/mango/wallpaper.png" https://w.wallhaven.cc/full/xe/wallhaven-xe7ylv.png

if [[ $git -eq 1 ]]; then
  sudo dnf rm -y git
fi

if [[ $tar -eq 1 ]]; then
  sudo dnf rm -y tar
fi

if [[ $sassc -eq 1 ]]; then
  sudo dnf rm -y sassc
fi

clear

if lsmod | grep -q nouveau; then
  printf "Nvidia hardware detected. Install rpmfusion?\nNote: This will install modern drivers. Dont use if you have a legacy card.\n"
  while true; do
    read -rn 1 -p "(y/n): " yn
    printf "\n"
    case $yn in
      [Yy]* )
        sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
        sudo dnf install -y  gcc kernel-headers kernel-devel akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs xorg-x11-drv-nvidia-libs.i686
        printf "Compiling driver modules. This might take a while"
        if sudo akmods | grep -q OK; then
          printf "Something went wrong. 5 min sleep to insure installation."
          sleep 300
        fi
        while ! sudo akmods | grep -q OK; do
          printf "."
          sleep 10
        done
        printf "\n"
        break;;
      [Nn]* ) break;;
      * ) printf "Invalid\n";;
    esac
  done
  clear
fi

printf "rebooting in 10s..\n"
sleep 10
sudo reboot
