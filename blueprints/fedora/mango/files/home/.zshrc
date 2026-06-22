# interactive session setup
if [[ -o interactive ]]; then
    alias ls='eza --icons'
    alias di='sudo dnf in -y'
    alias dr='sudo dnf rm -y'
    alias ff='clear; fastfetch'
fi

# autostart mango on tty1
if [[ -o login ]]; then
    if [[ -z "$DISPLAY" && "$(tty)" == "/dev/tty1" ]]; then
        exec mango
    fi
fi

# Better history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

# Initialize the standard Zsh completion system
autoload -Uz compinit && compinit

## Case-insensitive and partial-word completion
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Load Fish-like Auto-suggestions / git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(starship init zsh)"

# Load Fish-like Syntax Highlighting / git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
