#!/bin/bash
syncer='rsync --ignore-existing -avz'
rootbak_dir="$HOME/Backups"
confbak_dir=$rootbak_dir/dots/config-backup-$(date +%Y.%m.%d-%H.%M.%S) 

err() {
    [[ -z "$1" ]] && msg='Some error occured.' || msg="$1"
    printf '\033[1;31m%s\033[0m\n' "$msg"
    exit 1
}

data_dir_size="$(printf '%s' "$(du -sh "${XDG_DATA_HOME:-"$HOME/.local/share"}")")"

### Dotfiles ###
printf '\033[1;36m%s\033[0m\n' 'Backing dots ...'
{ mkdir -p "$confbak_dir" && cp -Rf "${XDG_CONFIG_HOME:-"$HOME/.config"}" ~/.xmonad ~/.bash* ~/.pvpn-cli ~/.local/bin ~/.links ~/.Xresources ~/.telegram-cli ~/.mbsyncrc ~/.api_keys ~/.gnupg ~/.ssh ~/.password-store ~/.ngrok2 "$confbak_dir"; } &
dotbak_proc=$!

### App Data ###
read -n 1 bak_appdata -p "Do you want to backup your App-Data (about $data_dir_size) ? (y/n): "
if [[ $bak_appdata == 'y' ]]; then
    $syncer "${XDG_DATA_HOME:-"$HOME/.local/share"}" "$rootbak_dir"/Appdata &> /dev/null &
    databak_proc=$!
else
    printf '\n\033[1;31m%s\033[0m\n\n' "[Warning]: App data won't be synced !"
fi


if ps -p $dotbak_proc; then
    echo 'Waiting for dotfile backup to finish ...'
    wait $dotbak_proc
    [[ $? -eq 1 ]] && printf '\033[1;32m%s\033[0m\n\n' "Copied dots to $confbak_dir." \
        || err "Couldn't backup dotfiles :\ "
fi

printf '\033[1;31m%s\033[0m\n' '[Warning]: This deletes all dotfile backups except the recent three.'
read -n 1 delete_old -p 'Do you want to delete the old Backups ? (y/n): '
if [[ $delete_old == 'y' ]]; then
    to_del=$(/bin/ls "$rootbak_dir/dots/" | grep config | sort -n | head -n -3)
    if [[ -n $to_del ]]; then
        for i in $to_del
        do
            rm -rf "$rootbak_dir"/dotfiles/"$i"
        done
    fi
else
    echo 'No backups removed.'
fi

if ps -p $databak_proc; then
    echo 'Waiting for app data backup to finish ...'
    wait $databak_proc
    [[ $? -eq 1 ]] && printf '\033[1;32m%s\033[0m\n\n' "Copied app data to $rootbak_dir/Appdata." \
        || err "Couldn't backup app data :\ "
fi


### Commit ###
read -n 1 commit -p "Do you want to commit $rootbak_dir to external drive ? (y/n):"
if [[ $commit == 'y' ]]; then
    sudo bakcom.sh || die 'Error commiting backup.'
    paplay '/usr/share/sounds/freedesktop/stereo/complete.oga'

    read -n 1 clean -p "Do you want to delete $rootbak_dir ? (y/n): "
    if [[ $clean == 'y' ]]; then
        # Preserve history backup
        mv "$rootbak_dir/hbak" "$TMPDIR/" && rm -fr "$rootbak_dir"
        mkdir "$rootbak_dir" && mv "$TMPDIR/hbak" "$rootbak_dir/"
    fi

else
    err 'Halted Commit.'
fi

printf 'Current dotfiles backups ...\n'
[[ -d "$rootbak_dir/dots/" ]] && exa -alh --color=always --group-directories-first "$rootbak_dir/dots/"
