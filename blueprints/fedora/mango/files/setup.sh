#!/bin/bash

set -e

sudo dnf install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release -y
sudo dnf copr enable -y leloubil/wl-clip-persist
sudo dnf copr enable -y sneexy/zen-browser

sudo dnf in -y mangowm ghostty thunar zen-browser waybar mako wlsunset swaybg wl-clip-persist cliphist gtklock playerctl rofi wlogout blueman-manager pavucontrol nm-connection-editor xdg-desktop-portal xdg-desktop-portal-wlr xorg-x11-server-Xwayland xfce-polkit gedit nwg-look xdg-user-dirs zsh eza git

# engrampa

xdg-user-dirs-update

cp -r /tmp/files/home/. ~
curl -Lso ~/.config/mango/wallpaper.png https://w.wallhaven.cc/full/xe/wallhaven-xe7ylv.png

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
sudo chsh -s $(which zsh) $USER
curl -sS https://starship.rs/install.sh | sh -s -- -y

printf '[Service]\nExecStart=\nExecStart=-/usr/sbin/agetty --autologin %s --noclear %%I $TERM\n' "$USER" | sudo systemctl edit getty@tty1 --stdin

clear
printf "rebooting in 10s..\n"
sleep 10
reboot
