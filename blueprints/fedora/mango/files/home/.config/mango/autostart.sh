#! /bin/bash
#dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
#systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
#eval "$(dbus-launch --sh-syntax)" &

export XDG_CURRENT_DESKTOP=wlroots

#lock
gtklock -b ~/.config/mango/wallpaper.png &

# fast launch on GTK/Qt apps
fc-cache -f &
gtk-update-icon-cache -q &

# notifications daemon
mako &

# night light
wlsunset -T 3501 -t 3500 &

# wallpaper
swaybg -i ~/.config/mango/wallpaper.png &

# bar
waybar -c ~/.config/mango/waybar/config.jsonc -s ~/.config/mango/waybar/style.css &

# keep clipboard content
wl-clip-persist --clipboard regular --reconnect-tries 0 &

# clipboard content manager
wl-paste --type text --watch cliphist store &

# polkit (auth) / needs update
if ! pgrep -x "xfce-polkit" >/dev/null; then
  /usr/lib/xfce-polkit/xfce-polkit &
fi

# autostart apps
#ghostty -e nvim &
