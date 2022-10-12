#!/bin/bash

if [[ $UID == 0 ]]; then
    echo "Root access verified."
else
    printf "\033[1;31m%s\033[0m\n" "[ERROR]: Please run as root."
    exit 1
fi

mount_dir=/mnt/Priya
[[ -d $mount_dir ]] || mkdir $mount_dir

mount /dev/sda4 $mount_dir && \
printf "\033[1;32m%s\033[0m\n" "Committing ..." || printf "\033[1;31m%s\033[0m\n" "Error mounting /dev/sda4"
rsync --human-readable -az --stats /home/hadouken/Backups/ $mount_dir/Backups && \
printf "\n\033[1;32m%s\033[0m\n" "The backup dir has been successfully commited to /dev/sda4" || printf "\033[1;31m%s\033[0m\n" "Error committing Backup."

umount $mount_dir && \
echo "Bye ;)" || printf "\033[1;31m%s\033[0m\n" "Error unmounting /dev/sda4"
