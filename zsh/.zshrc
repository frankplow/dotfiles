# plugins
plugins=(
    colored-man-pages
    z
    zsh-syntax-highlighting
)
for plugin in $plugins; do source "$HOME/.config/zsh/$plugin/$plugin.plugin.zsh"; done

# theme
PROMPT="%F{01}%32<...<%~%<< %F{4}%#%f "

# history settings
setopt noincappendhistory
setopt nosharehistory

# completion setup
autoload -Uz compinit 
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit

# vi mode
bindkey -v
export KEYTIMEOUT=1

# vi keys in tab complete
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # use beam shape cursor for each new prompt.

# aliases
setopt COMPLETE_ALIASES
alias ls='ls --color=auto'
alias pacman='pacman --color=auto'
alias v='vim'

# go doc coloring
go() {
    if [[ $1 == "doc" ]]; then
        command go "$@" | sed -re "s/\(func \|type \|interface\|struct\|const\|var\)/`tput setaf 3`&`tput sgr0`/g;s/\(map[\|string\|float64\|float32\|uint64\|uint32\|uint16\|uint8\|uint\|int64\|int32\|int16\|int8\|int\)/`tput setaf 2`&`tput sgr0`/g;s/^\s*[A-Z]+$/`tput setaf 1; tput bold`&`tput sgr0`/g"
    else
        command go "$@"
    fi
}
