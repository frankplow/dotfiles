if status is-interactive
    function fish_mode_prompt; end

    function prompt_login --description "display user name for the prompt"
        if not set -q __fish_machine
            set -g __fish_machine
            set -l debian_chroot $debian_chroot

            if test -r /etc/debian_chroot
                set debian_chroot (cat /etc/debian_chroot)
            end

            if set -q debian_chroot[1]
                and test -n "$debian_chroot"
                set -g __fish_machine "(chroot:$debian_chroot)"
            end
        end

        # Prepend the chroot environment if present
        if set -q __fish_machine[1]
            echo -n -s (set_color yellow) "$__fish_machine" (set_color normal) ' '
        end

        # If we're running via SSH, change the host color.
        set -l color_host $fish_color_host
        if set -q SSH_TTY; and set -q fish_color_host_remote
            set color_host $fish_color_host_remote
        end

        echo -n -s (set_color $fish_color_user) "$USER" (set_color $fish_color_prompt) @ (set_color $color_host) (prompt_hostname) (set_color normal)
    end

    set fish_prompt_pwd_dir_length 3
    set fish_prompt_pwd_full_dirs 3
    function my_prompt_pwd
        if fish_is_root_user
            set_color $fish_color_cwd
        else
            set_color $fish_color_cwd_root
        end

        prompt_pwd

        set_color normal
    end

    function prompt_suffix
        set_color $fish_color_prompt_suffix

        if fish_is_root_user
            echo -n '#'
        else
            echo -n '>'
        end
    end

    set __fish_git_prompt_showcolorhints true
    set __fish_git_prompt_showdirtystate true

    function fish_prompt
        printf '\n'
        printf '%s %s%s' \
            (prompt_login) \
            (my_prompt_pwd) \
            (fish_git_prompt)
        printf '\n'
        printf '%s ' (prompt_suffix)
    end
end
