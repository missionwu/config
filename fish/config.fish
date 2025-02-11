if status is-login
    set -x PATH $HOME/.bin $PATH
end

function ls
    command ls -h --color=auto --group-directories-first --sort=version $argv
end

function fish_prompt
    set -l __last_command_exit_status $status

    if not set -q -g __fish_arrow_functions_defined
        set -g __fish_arrow_functions_defined
        function _git_branch_name
            set -l branch (git symbolic-ref --quiet HEAD 2>/dev/null)
            if set -q branch[1]
                echo (string replace -r '^refs/heads/' '' $branch)
            else
                echo (git rev-parse --short HEAD 2>/dev/null)
            end
        end

        function _is_git_repo
            type -q git
            or return 1
            git rev-parse --git-dir >/dev/null 2>&1
        end
    end

    set -l cyan (set_color -o cyan)
    set -l yellow (set_color -o yellow)
    set -l red (set_color -o red)
    set -l green (set_color -o green)
    set -l blue (set_color -o blue)
    set -l normal (set_color normal)

    set -l arrow_color "$green"
    if test $__last_command_exit_status != 0
        set arrow_color "$red"
    end

    set -l arrow "$arrow_color➜ "
    if fish_is_root_user
        set arrow "$arrow_color# "
    end

    set -l cwd $cyan(basename (prompt_pwd))

    set -l repo_info
    if _is_git_repo
        set -l repo_branch $yellow(_git_branch_name)
        set repo_info "$normal($repo_branch$normal)"
    end

    echo -n -s $arrow $normal "[" $cwd $repo_info $normal "] "
end
