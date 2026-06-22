#!/bin/bash

set -e

# colors
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

if [ -f /etc/os-release ]; then
    source /etc/os-release
else
    printf "%bError: /etc/os-release does not exist. %b\n" "$RED" "$NC"
    exit 1
fi


OS=($(curl -s "https://api.github.com/repos/flawada/config/contents/blueprints" | grep "name" | cut -d '"' -f 4))

if [[ "${OS[*]}" == *"$ID"* ]]; then
    printf "%bSupported distro%b\n" "$GREEN" "$NC"
fi


blueprints=($(curl -s "https://api.github.com/repos/flawada/config/contents/blueprints/$ID" | grep "name" | cut -d '"' -f 4))


printf "%bSelect a config:%b\n" "$BLUE" "$NC"
select blueprint in "${blueprints[@]}"; do
    # Check if the user's choice matches an item in our list
    if [ -n "$blueprint" ]; then
        break
    else
        echo "Invalid choice"
    fi
done


curl -sL https://raw.githubusercontent.com/flawada/blueprint/main/blueprints/$ID/$blueprint/files.tar | tar -xf - -C /tmp

cd /tmp/files

### install: gum, tar (gunzip)
case "$ID" in
  fedora)
    printf "%bFedora%b\n" "$GREEN" "$NC"
    ;;
  *)
    printf "%bError: non supported linux distribution. %b\n" "$RED" "$NC"
    exit 1
    ;;
esac

bash setup.sh

#### deprecated ####

#printf "%s\n" "${blueprints[@]}"
#blueprint=$(printf "%s\n" "${blueprints[@]}" | gum choose --header "Choose a config:")

#cd /tmp
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
