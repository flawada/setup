#!/bin/bash

set -euo pipefail

# colors
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;94m'
GREEN='\033[0;32m'
NC='\033[0m'

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
OS=($(curl -s "https://api.github.com/repos/flawada/blueprint/contents/blueprints" | grep "name" | cut -d '"' -f 4))
if [[ "${OS[*]}" == *"$ID"* ]]; then
    printf "%bSystem: %s | supported%b\n" "$GREEN" "$PRETTY_NAME" "$NC"
else
    printf "%bSystem: %s | not supported%b\n" "$RED" "$PRETTY_NAME" "$NC"
    exit 1
fi

printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"

printf "%bLoading blueprints%b\n" "$GREEN" "$NC"
blueprints=($(curl -s "https://api.github.com/repos/flawada/blueprint/contents/blueprints/$ID" | grep "name" | cut -d '"' -f 4))
if [ "${#blueprints[@]}" -eq 0 ]; then
    printf "%bError: No blueprint found. %b\n" "$RED" "$NC"
    exit 1
elif [ "${#blueprints[@]}" -eq 1 ]; then
    blueprint="${blueprints[0]}"
else
    printf "%bSelect a blueprint:%b\n" "$BLUE" "$NC"
    select blueprint in "${blueprints[@]}"; do
        if [ -n "$blueprint" ]; then
            break
        else
            printf "%bInvalid choice%b\n" "$RED" "$NC"
        fi
    done
fi
printf "%bBlueprint %s selected..%b\n" "$GREEN" "$blueprint" "$NC"

printf "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"

printf "%bRedirecting..%b\n" "$BLUE" "$NC"
if sudo -v; then
    bash <(curl -LfsS https://raw.githubusercontent.com/flawada/blueprint/main/blueprints/$ID/$blueprint/setup.sh)
fi
