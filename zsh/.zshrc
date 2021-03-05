# plugins
plugins=(
    z
    zsh-syntax-highlighting
    colored-man-pages
    colour-godoc
)
for plugin in $plugins; do source "$HOME/.config/zsh/$plugin/$plugin.plugin.zsh"; done

fpath=($HOME/.config/zsh/functions $fpath)

# theme
PROMPT="%F{01}%32<...<%~%<< %F{4}%#%f "
# PROMPT="%n@%m: %1~ %# "

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
alias dmesg='dmesg -L=always | less -r'
