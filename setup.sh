#!/bin/bash

clear

set -e
repo="config"

if [ "$(uname)" != "Linux" ]; then
  echo "this script must be run on linux"
  exit 1
fi

OS=$(grep -Po '(?<=^ID=).*' /etc/os-release | tr -d '"')

cd /tmp

sudo dnf in -y git

if ! [ -d "/tmp/$repo" ]; then
  git clone https://github.com/flawada/$repo
fi

if ! [ -d "/tmp/$repo/blueprints/$OS" ]; then
  echo "$OS is not supported yet"
  echo "suported distros: "
  ls /tmp/$repo/blueprints
  exit 1
fi

#####

clear

cd /tmp/$repo/blueprints/$OS

blueprints=()
i=0

for blueprint in */; do
  blueprints+=("$blueprint")

  echo "$i) ${blueprint%/}"

  i=$((i+1))
done

read -p "select blueprint: " item

#clear

cd ${blueprints[$item]}

sudo dnf update -y

chmod +x setup.sh
./setup.sh
