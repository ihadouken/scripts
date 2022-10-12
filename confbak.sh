#!/bin/bash
[[ -z $XDG_CONFIG_HOME || -z $XDG_DATA_HOME ]] && echo 'XDG_CONFIG_HOME or XDG_DATA_HOME not set, exiting ...' && exit 1

### Some Definitions for use later. ###
syncer="rsync --ignore-existing -avz"
rootbak_dir=~/Backups
confbak_dir=$rootbak_dir/dots/config-backup-$(date +%Y.%m.%d-%H.%M.%S) 

err() {
    if [[ -z "$1" ]]; then
        msg="Some error occured."
    else
        msg="$1"
    fi
    printf "\033[1;31m%s\033[0m\n" "$msg"
    exit 1
}


### Some logging ... ###
bat_logger.sh >> /var/hk_bat.log 2>/dev/null
pacman -Qq > $XDG_CONFIG_HOME/installed_pkgs.log
/usr/bin/ls -la > $XDG_CONFIG_HOME/home_contents.log

data_dir_size=$(printf $(du -sh "$XDG_DATA_HOME"))

### App Data ###
printf "\033[1;34m%s\033[0m" "Do you want to sync your App-Data (about $data_dir_size) ? (y/n): "
read -n 1 isSyncing

if [[ $isSyncing == "y" ]]; then    
    $syncer $XDG_DATA_HOME $rootbak_dir/Appdata --exclude='$XDG_DATA_HOME/warzone2100/sequences.wz' > /dev/null 2>&1 && printf "\nApp-Data synced.\n\n" || err "Failed to backup App-Data !!"
else
    printf "\n\033[1;31m%s\033[0m\n\n" "[Warning]: App-Data won't be synced !"
fi


### Dotfiles ###
printf "\033[1;36m%s\033[0m\n" "Backing dots ..."
mkdir -p $confbak_dir && cp -Rf $XDG_CONFIG_HOME ~/.xmonad ~/.bash* ~/.pvpn-cli ~/.local/bin ~/.links ~/.Xresources ~/.telegram-cli ~/.mbsyncrc ~/.api_keys ~/.gnupg ~/.ssh ~/.password-store ~/.ngrok2 $confbak_dir && \
printf "\033[1;32m%s\033[0m\n\n" "Copied dots to Backups." || err "Couldn't backup dotfiles :\ "


printf "\033[1;31m%s\033[0m\n" "[Warning]: This deletes all dotfile backups except the recent three."
printf "\033[1;34m%s\033[0m" "Do you want to delete the old Backups ? (y/n): "
read -n 1 isDeleting
printf "\n"

if [[ $isDeleting == "y" ]]; then
    to_del=$(/bin/ls $rootbak_dir/dots/ | grep config | sort -n | head -n -3)
    if [[ -n $to_del ]]; then
        for i in $to_del
        do
            rm -rf $rootbak_dir/dotfiles/$i
        done
    fi
else
    echo "Backups are preserved."
fi


### Commit ###
printf "\n\033[1;34m%s\033[0m" "Do you want to commit the Backups dir to external NTFS ? (y/n): "
read -n 1 isExporting
printf "\n"

if [[ $isExporting == "y" ]]; then
    sudo bakcom.sh
    paplay '/usr/share/sounds/freedesktop/stereo/complete.oga'

    printf "\n\033[1;34m%s\033[0m" "Do you want to delete the Backups dir to save space on /home ? (y/n): "
    read -n 1 isCleaning
    printf "\n"

    if [[ $isCleaning == "y" ]]; then
        mv "$rootbak_dir/hbak" "$TMPDIR/" && rm -fr "$rootbak_dir"
        mkdir "$rootbak_dir" && mv "$TMPDIR/hbak" "$rootbak_dir/"
    else
        echo "OK, big bakdir left as-is in home directory"
    fi

else
    err "Halted Commit."
fi

echo


printf "Current dotfiles backup contents ...\n"
[[ -d "$rootbak_dir/dots/" ]] && exa -alh --color=always --group-directories-first "$rootbak_dir/dots/"
