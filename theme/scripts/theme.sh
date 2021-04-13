#!/usr/bin/env bash

THEME="$HOME/themes/"$1".theme"
TEMPLATES="$HOME/themes/templates"
DOTFILES="$HOME/.dot"
ARG=""
for line in $(cat $THEME)
do
    ARG="${ARG} ${HOME}/themes/hashes/${line}.yaml"
done

for template in $(find $DOTFILES -name "*.envs"); do
    #TODO: use the envvar in the sed argument rather than hard-coding it
    install_path="$HOME/$(echo $template | sed -r 's/^\/home\/frank\/\.dot\/\w+\/(.*)\.envs$/\1/')"
    envsubst < $template > $install_path
done

exec "$HOME/themes/reload.sh" &> /dev/null
