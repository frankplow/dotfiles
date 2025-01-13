# Load version control system info
autoload -Uz vcs_info

# Set prompt
precmd() {
	vcs_info
	print
	print -rP "%F{8}%n@%m %~ ${vcs_info_msg_0_}"
}
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:git:*' formats '(%b%c%u)'
#zstyle ':vcs_info:git*+set-message:*' hooks git-modified
#+vi-git-modified(){
#    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
#        git status --porcelain | grep '??' &> /dev/null ; then
#        # This will show the marker if there are any untracked files in repo.
#        # If instead you want to show the marker only if there are untracked
#        # files in $PWD, use:
#        #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
#	has_untracked=true
#    else
#	has_untracked=false
#    fi

#    if [ "$has_untracked" = true ] ; then
#	hooks_com[staged]+='*'
#    fi
#}
setopt PROMPT_SUBST
PROMPT='%F{8}>%f '
