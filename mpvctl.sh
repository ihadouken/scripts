#!/bin/bash
socket=${XDG_CACHE_HOME:="$HOME/.cache"}/mpv-ipc-socket

while getopts "bfpr" arg; do
    case "$arg" in
        b)  echo '{ "command": [ "seek", "-10" ] }' | socat - "$socket" > /dev/null 2>&1 ;;
        f)  echo '{ "command": [ "seek", "+10" ] }' | socat - "$socket" > /dev/null 2>&1 ;;
        p)  echo 'cycle pause' | socat - "$socket" ;;
        r)  echo '{ "command": [ "set_property", "time-pos", "0" ] }' | socat - "$socket" > /dev/null 2>&1 ;;
        *)  echo "Invalid option !!"
    esac
done
