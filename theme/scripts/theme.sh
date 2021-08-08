#!/usr/bin/env bash

# THEME="$HOME/themes/"$1".theme"
DOTFILES="$HOME/.dot"
# ARG=""
# for line in $(cat $THEME)
# do
#     ARG="${ARG} ${HOME}/themes/hashes/${line}.yaml"
# done

export THEME="$HOME/themes/$1"
if [ ! -e $THEME ]; then
    echo "Error. No such theme." >&2
    exit 1
fi
cp $THEME "$HOME/themes/active_theme"

. $THEME

for template in $(find $DOTFILES -name "*.envs"); do
    #TODO: use the envvar in the sed argument rather than hard-coding it
    install_path="$HOME/$(echo $template | sed -r 's/^\/home\/frank\/\.dot\/\w+\/(.*)\.envs$/\1/')"
    envsubst < $template > $install_path
done

. "$HOME/scripts/reload_theme.sh"
