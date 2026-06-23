#!/bin/bash

set -e

# colors
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;94m'
GREEN='\033[0;32m'
NC='\033[0m'

#####

clear

printf "$(cat << EOF
${BLUE}                               
 ▄▄▄▄ ▄▄▄▄▄ ▄▄▄▄▄▄ ▄▄ ▄▄ ▄▄▄▄  
███▄▄ ██▄▄    ██   ██ ██ ██▄█▀ 
▄▄██▀ ██▄▄▄   ██   ▀███▀ ██
${NC}
EOF
)"

printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"

printf "%bChecking System..%b\n" "$BLUE" "$NC"

if [ -f /etc/os-release ]; then
    source /etc/os-release
else
    printf "%bError: /etc/os-release does not exist. %b\n" "$RED" "$NC"
    exit 1
fi

OS=($(curl -s "https://api.github.com/repos/flawada/config/contents/blueprints" | grep "name" | cut -d '"' -f 4))

if [[ "${OS[*]}" == *"$ID"* ]]; then
    printf "%bSystem: %s | supported%b\n" "$GREEN" "$PRETTY_NAME" "$NC"
else
    printf "%bSystem: %s | not supported%b\n" "$RED" "$PRETTY_NAME" "$NC"
    exit 1
fi

blueprints=($(curl -s "https://api.github.com/repos/flawada/config/contents/blueprints/$ID" | grep "name" | cut -d '"' -f 4))

printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"

printf "%bSelect a config:%b\n" "$BLUE" "$NC"
select blueprint in "${blueprints[@]}"; do
    if [ -n "$blueprint" ]; then
        break
    else
        printf "%bInvalid choice%b\n" "$RED" "$NC"
    fi
done

printf "%bConfig selected%b\n" "$GREEN" "$NC"

printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"

printf "%bDownloading..%b\n" "$BLUE" "$NC"

curl -sL https://raw.githubusercontent.com/flawada/blueprint/main/blueprints/$ID/$blueprint/files.tar | tar -xf - -C /tmp

if ! [ -f /tmp/files/setup.sh ]; then
    printf "%bError:/tmp/files/setup.sh does not exist. Something went wrong when downloading. %b\n" "$RED" "$NC"
    exit 1
else

printf "%bDownloaded to /tmp%b\n" "$GREEN" "$NC"

printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"

printf "%bInstalling..%b\n" "$BLUE" "$NC"

while ! sudo -v; do
  sleep 1
done

bash /tmp/files/setup.sh
