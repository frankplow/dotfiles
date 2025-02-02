if command -v git &>/dev/null; then
    alias gs="git status"
    alias ga="git add"
    alias gc="git commit"
    alias gco="git checkout"
    alias gl="git log"
    alias gd="git diff"
fi

if command -v bat &>/dev/null; then
    set BAT_THEME base16
    alias bat="bat -p"
fi

function rpaste {
    readonly path=${1:?"Usage: rpaste <path>"}
    if set -q XDG_CONFIG_DIR && test -d _Z_DATA; then
        set confdir "$XDG_CONFIG_DIR/rpaste"
    else
        set confdir "$HOME/.config/rpaste"
    fi
    curl -F "file=@$path" -H "@$confdir/auth" "https://files.frankplowman.com"
}

function bellend {
    eval "$argv" && tput bel
}

if command -v ls &>/dev/null; then
    alias ls="ls --color=auto"
fi
