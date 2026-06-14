#!/bin/bash

set -e

if ! grep -q '^ID=fedora' /etc/os-release; then
  echo "! Warning ! : This script is made for fedora everthing"
  read -p "Continure? [y/n]: " p
  case "$p" in
  [yY])
    echo "continure text"
    ;;
  *)
    echo "Exit text"
    exit
    ;;
  esac
fi

cd /tmp

sudo dnf in -y git
if ! [ -d "/tmp/mango" ]; then
  git clone https://github.com/flawada/mango
fi

#if ! rpm -q terra-release >/dev/null 2>&1; then
#  sudo dnf in -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
#fi
#sudo dnf in -y mangowm
#sudo dnf in -y mesa-libgbm mesa-libGL

bash 
