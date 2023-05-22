#!/bin/bash
upload() {
    ssh -T git@github.com &> /dev/null || [ $? -eq 255 ] && {
        local _PATH="$HOME/.ssh/github_$1";
        eval "$(ssh-agent -s)" &> /dev/null;
        ssh-add $_PATH &> /dev/null || {
            ssh-keygen -t ed25519 -E sha384 -f $_PATH -N "" -C $2 &> /dev/null;
            ssh-add $_PATH &> /dev/null;
        }
    }
    [ $# -le 4 ] && printf "\e[1A\e[1;38;2;255;0;0m> \e[0;38;2;255;0;100mNot enough arguments\e[0K\r" && return 1;
    [[ "$6" == "init" ]] && rm -rf .git && git init &> /dev/null && git config --local user.name $1 && git config --local user.email $2 && git branch -M $3 && git remote add origin git@github.com:$1/$4.git;
    git add . && git commit -m "${5:-✨ Refactor code}" &> /dev/null && git push --set-upstream -f origin $3 &> /dev/null || {
        ssh -T git@github.com || [ $? -eq 255 ] && {
            echo -e "\e[1;38;2;255;0;0m> \e[0;38;2;220;0;0mPermission Denied you should add SSH Key\n\e[1;38;2;255;255;0m> \e[0;38;2;0;210;0mKey has copied";
            sleep 2;
            [[ $OSTYPE == "msys" ]] && cat "$_PATH.pub" | clip && start "https://github.com/settings/ssh/new";
            read -p "$(printf "\e[1;38;2;255;255;0m> \e[1;38;2;255;255;255mpress any key to continue")" _;
            git push --set-upstream -f origin $3 &> /dev/null || { printf "\e[1A\e[1;38;2;255;0;0m> \e[0;38;2;255;0;100mUpload Failed\e[0K\r" && return 1; }
        }
        printf "\e[1A\e[1;38;2;255;0;0m> \e[0;38;2;255;255;0mNothing Update\e[0K\r" && return 0;
    }
    printf "\e[1A\e[1;38;2;255;0;255m> \e[1;38;2;255;210;255mUpload Completed\e[0K\r";
}