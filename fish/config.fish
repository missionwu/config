if status is-login
    exec wayfire
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

    set -l color "$normal"
    if test $__last_command_exit_status != 0
        set color "$red"
    end

    set -l cwd $cyan(prompt_pwd | path basename)

    set -l repo_info
    if set -l is_git_repo (_is_git_repo)
        set -l repo_branch (_git_branch_name)
        set repo_info "$normal($green$repo_branch$normal)"
    end

    echo -n -s $color'['$normal $cwd $repo_info $color'] '$normal
end

function ls
    command ls -hv --group-directories-first --color=always $argv
end
