#!/bin/bash

set -e
local_path=~/.cache/flawado

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

sudo dnf in -y git
mkdir -p $local_path
cd $local_path

if [ -z "$(ls -A)" ]; then
  git clone https://github.com/flawada/mango
fi

set -e
local_path=~/.cache/flawado

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

sudo dnf in -y git
mkdir -p $local_path
cd $local_path

if [ -z "$(ls -A)" ]; then
  git clone https://github.com/flawada/mango
fi

sudo dnf in -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
sudo dnf in -y mangowm

sudo dnf in -y python3-pip
pip install PySide6

sudo dnf in -y mesa-libgbm mesa-libGL

mkdir -p ~/.config/mango
echo exec-once = python ${local_path}/mango/install.py > ~/.config/mango/config.conf
mango
