sudo dnf install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release -y

sudo dnf in mangowm foot thunar waybar mako wlsunset swaybg wl-clipboard gtklock playerctl rofi wlogout blueman-manager pavucontrol nm-connection-editor xorg-x11-server-Xwayland xfce-polkit cliphist tar -y

sudo dnf in nwg-look gedit engrampa firefox xdg-user-dirs -y
xdg-user-dirs-update

curl -sS https://starship.rs/install.sh | sh -s -- -y
echo 'eval "$(starship init bash)"' >> ~/.bashrc

cp -r /tmp/blueprint/blueprints/fedora/mangowm-fedora/config/* ~/.config/
curl -Lso ~/.config/mango/wallpaper.png https://w.wallhaven.cc/full/xe/wallhaven-xe7ylv.png

mango