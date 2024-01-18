#!/bin/bash

upload() {
    [ $# -le 3 ] && printf "\nArgument not enough\n- Username (required)\n- Email (required)\n- Branch name (required)\n- Repository Name (required)\n- Commit Message (Optional)\n- init (first time only)" && return 1;
    [[ "$1" =~ ' ' ]] && printf "\nInvalid Username" && return 1;
    ! [[ "$2" =~ ^[a-zA-Z0-9._-]+@[a-zA-Z0-9._]+\.[a-z]{2,}$ ]] && printf "\nInvalid Email" && return 1;
    ! [[ "$4" =~ [a-z0-9._-]+ ]] && printf "\nInvalid Repository Name" && return 1;
    sleep 2;
    local SSH_KEY_PATH="$HOME/.ssh/github_$1";

    if ! [ -f "$HOME/.ssh/github_$1" ]; then
        eval "$(ssh-agent -s)";
        ssh-keygen -t ed25519 -E sha384 -f $SSH_KEY_PATH -N "" -C $2;
        ssh-add $SSH_KEY_PATH;
        echo -e "\e[1;38;2;255;0;0m> \e[0;38;2;220;0;0mSSH Authentication Key required by github";
        echo -e "\e[1;38;2;255;255;0m> \e[0;38;2;0;210;0mSSH Key copied";
        echo -e "\e[1;38;2;255;255;0m> \e[0;38;2;0;210;0mOpening github website";
        sleep 2;
        [[ $OSTYPE == "msys" ]] && cat "$SSH_KEY_PATH.pub" | clip && start "https://github.com/settings/ssh/new";
        [[ $OSTYPE == "linux-android" ]] && cat "$SSH_KEY_PATH.pub" | termux-clipboard-set && termux-open-url "https://github.com/settings/ssh/new";
        [[ $OSTYPE == "linux-gnu" ]] && cat "$SSH_KEY_PATH.pub" | xclip -selection clipboard && xdg-open "https://github.com/settings/ssh/new";
        read -p "$(printf "\e[1;38;2;255;255;0m> \e[1;38;2;255;255;255mEnsure SSH key added then press enter key to continue")" _;
        ssh -T git@github.com;
        # 255 Permission Denied
        [ $? -eq 255 ] && echo -e "Not Found SSH KEY on github website" && return 1;
    else
        ssh -T git@github.com;
        [ $? -eq 255 ] && {
            echo -e "\e[1;38;2;255;0;0m> \e[0;38;2;220;0;0mNot Found SSH Authentication KEY on github website"
            echo -e "\e[1;38;2;255;255;0m> \e[0;38;2;0;210;0mSSH Key copied";
            echo -e "\e[1;38;2;255;255;0m> \e[0;38;2;0;210;0mOpening github website";
            sleep 2;
            eval "$(ssh-agent -s)";
            ssh-add $SSH_KEY_PATH;
            [[ $OSTYPE == "msys" ]] && cat "$SSH_KEY_PATH.pub" | clip && start "https://github.com/settings/ssh/new";
            [[ $OSTYPE == "linux-android" ]] && cat "$SSH_KEY_PATH.pub" | termux-clipboard-set && termux-open-url "https://github.com/settings/ssh/new";
            [[ $OSTYPE == "linux-gnu" ]] && cat "$SSH_KEY_PATH.pub" | xclip -selection clipboard && xdg-open "https://github.com/settings/ssh/new";
            read -p "$(printf "\e[1;38;2;255;255;0m> \e[1;38;2;255;255;255m\nEnsure SSH key added then press enter key to continue")" _;
            ssh -T git@github.com;
            [ $? -eq 255 ] && echo -e "Not Found SSH KEY on github website" && return 1;
        }
    fi
    sleep 2;
    [[ "$6" == "init" ]] && rm -rf .git && git init && git config --local user.name "$1" && git config --local user.email "$2" && git branch -M "$3" && git remote add origin "git@github.com:$1/$4.git";
    git add . && git commit -m "${5:-✨ Refactor code}";
    git push --set-upstream -f origin "$3" || { echo -e "\e[1A\e[1;38;2;255;0;0m> \e[0;38;2;255;0;100mUpload Failed\e[0K\r" && return 1; }
    echo -e "\e[1A\e[1;38;2;255;0;255m> \e[1;38;2;255;210;255mUpload Completed\e[0K\r";
}
