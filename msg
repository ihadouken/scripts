#!/bin/bash
err() {
    printf "\033[1;31m[ERROR]: %s\n\033[0m" "$1" 
    exit 1
}

send() {
    telegram-cli -W -e "msg $1 '$2'" | grep "\[[0-9]\{2,\}:[0-9]\{2,\}\]"
    exit 0
}

if [[ -z $1 ]]; then
    err "Atleast 1 argument expected, 0 given !"

else
    txt="${*:2}"
    [[ -z $txt ]] && err "No message string provided."

    conv=$(echo "dialog_list" | telegram-cli -C -D | sed '1d;:a;$!N;1,3ba;P;$d;D' | cut -d ' ' -f 2 | tr -d ':' | sed '1d')
    echo $conv
    echo

    for chat in $conv
    do    
        if [[ $chat == "$1" ]]; then
            send $chat "$txt"
        fi
    done
        
    err "Contact \"$1\" not in Address Book !"
fi



