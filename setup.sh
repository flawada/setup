#!/bin/bash

set -euo pipefail

# colors
export RED='\033[0;31m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;94m'
export GREEN='\033[0;32m'
export NC='\033[0m'

# functions
c() {
  while ! "$@"; do
    printf "\n%bCommand \"%b%s%b\" failed%b\n" "$RED" "$YELLOW" "$*" "$RED" "$NC"
    printf "%bYou might need to fix this problem manually before proceeding%b\n\n" "$RED" "$NC"
    printf "r = Retry this command\n"
    printf "e = Exit\n"
    printf "s = Skip this command\n"
    printf "or enter a command to run\n"
    while true;do
      read -rp "[r/e/s]: " p < /dev/tty
      case $p in
        [Rr]) printf "%bRetrying..%b\n" "$BLUE" "$NC"; break ;;
        [Ee])  printf "%bExiting..%b\n" "$RED" "$NC"; exit 1 ;;
        [Ss]) printf "%bSkipped this command%b\n" "$YELLOW" "$NC"; return 0 ;;
        *) $p || true ;;
      esac
    done
  done
}

export -f c

printc () {
  printf "\n";printf '━%.0s' $(seq 1 ${#1}); printf "┓\n"
  printf "┃ %b$1..%b ┃" "$BLUE" "$NC"
  printf "\n┗";printf '━%.0s' $(seq 1 ${#1}); printf "┛\n\n"
}

export -f printc

##########

clear

printf "$(cat << EOF
${BLUE}                               
 ▄▄▄▄ ▄▄▄▄▄ ▄▄▄▄▄▄ ▄▄ ▄▄ ▄▄▄▄  
███▄▄ ██▄▄    ██   ██ ██ ██▄█▀ 
▄▄██▀ ██▄▄▄   ██   ▀███▀ ██
${NC}
EOF
)"

printc "Checking System"
if [ -f /etc/os-release ]; then
    source /etc/os-release
else
    printf "%bError: /etc/os-release does not exist. %b\n" "$RED" "$NC"
    exit 1
fi

OS=($(curl -s "https://api.github.com/repos/flawada/blueprint/contents/blueprints" | grep "name" | cut -d '"' -f 4))
if [[ "${OS[*]}" == "$ID" ]]; then
    printf "%bSystem: %s [supported]%b\n" "$GREEN" "$PRETTY_NAME" "$NC"
else
    printf "%bSystem: %s [unsupported]%b\n" "$RED" "$PRETTY_NAME" "$NC"
    exit 1
fi

printc "Loading blueprints"
blueprints=($(curl -s "https://api.github.com/repos/flawada/blueprint/contents/blueprints/$ID" | grep "name" | grep -v "README.md" | cut -d '"' -f 4))
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
printf "%bBlueprint %s selected%b\n" "$GREEN" "$blueprint" "$NC"

printc "Redirecting"
if c sudo -v; then
    c bash <(curl -LfsS https://raw.githubusercontent.com/flawada/blueprint/main/blueprints/$ID/$blueprint/setup.sh)
fi
