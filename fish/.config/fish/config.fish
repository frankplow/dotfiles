fish_add_path /opt/homebrew/bin
fish_add_path $HOME/.cargo/bin

if command -v pyenv > /dev/null
    set PYENV_ROOT $HOME/.pyenv
    fish_add_path $PYENV_ROOT/shims
end

if command -v rbenv > /dev/null
    eval "$(rbenv init -)"
end

if command -v bat > /dev/null
    set BAT_THEME base16
end

if status is-interactive
    # Remove welcome message
    set -U fish_greeting

    # Enable vi mode
    set -g fish_cursor_insert line
    set -g fish_cursor_default block
    set -g fish_cursor_visual underscore
    fish_vi_key_bindings
    fish_vi_cursor

    # Set colors
    if not set -q CLICOLOR
        set -x CLICOLOR 1
    end

    set fish_color_prompt brblack
    set fish_color_user $fish_color_prompt
    set fish_color_host $fish_color_prompt
    set fish_color_cwd $fish_color_prompt
    set fish_color_cwd_root $fish_color_prompt
    set fish_color_prompt_suffix $fish_color_prompt
    set __fish_git_prompt_color $fish_color_prompt
    set __fish_git_prompt_color_branch $fish_color_prompt
    set __fish_git_prompt_color_dirtystate $fish_color_prompt
    set __fish_git_prompt_color_stagedstate $fish_color_prompt

    set fish_color_command green

    # Colors in less
    set -x LESS_TERMCAP_mb (printf "\033[01;31m")  
    set -x LESS_TERMCAP_md (printf "\033[01;31m")  
    set -x LESS_TERMCAP_me (printf "\033[0m")  
    set -x LESS_TERMCAP_se (printf "\033[0m")  
    set -x LESS_TERMCAP_so (printf "\033[01;44;33m")  
    set -x LESS_TERMCAP_ue (printf "\033[0m")  
    set -x LESS_TERMCAP_us (printf "\033[01;32m")
end
