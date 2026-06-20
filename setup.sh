#!/bin/bash

set -e

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

repo='config'

OS=$(grep -Po '(?<=^ID=).*' /etc/os-release | tr -d '"')

case '$OS' in
  fedora)
    printf "%bFedora%b\n" "$GREEN" "$NC"
    ;;
  *)
    printf "%bError%b\n" "$RED" "$NC"
    exit 1
    ;;
esac

cd /tmp










#### deprecated ####

#sudo dnf in -y git
#
#if ! [ -d "/tmp/$repo" ]; then
#  git clone https://github.com/flawada/$repo
#fi
#
#if ! [ -d "/tmp/$repo/blueprints/$OS" ]; then
#  echo "$OS is not supported yet"
#  echo "suported distros: "
#  ls /tmp/$repo/blueprints
#  exit 1
#fi
#
#####
#
#clear
#
#cd /tmp/$repo/blueprints/$OS
#
#blueprints=()
#i=0
#
#for blueprint in */; do
#  blueprints+=("$blueprint")
#
#  echo "$i) ${blueprint%/}"
#
#  i=$((i+1))
#done
#
#read -p "select blueprint: " item
#
#clear
#
#cd ${blueprints[$item]}
#
#sudo dnf update -y
#
#chmod +x setup.sh
#./setup.sh
