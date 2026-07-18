# autostart mango on tty1
if [[ -o login ]]; then
    if [[ -z "$DISPLAY" && "$(tty)" == "/dev/tty1" ]]; then
        exec mango
    fi
fi

# better history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

# interactive session setup
if [[ -o interactive ]]; then
    alias ls='eza --icons'
    alias din='sudo dnf in -y'
    alias drm='sudo dnf rm -y'
    alias dup='sudo dnf up -y --refresh'
    alias ff='clear; fastfetch'

    # initialize the standard Zsh completion system
    autoload -Uz compinit && compinit

    ## case-insensitive and partial-word completion
    #zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
    # case-insensitive completion
    zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

    # git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

    eval "$(starship init zsh)"

    # git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
    source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
