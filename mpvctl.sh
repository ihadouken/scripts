#!/bin/bash
if [[ "$1" != '-s' ]]; then
    echo "Specify a socket with '-s' as the 1st argument"
    exit
fi

# if [[ "$*" != *"s"* ]]; then
#     echo "Specify a socket with '-s' as the 1st argument"
#     exit
# fi

while getopts "s:bfpr" arg; do
    case "$arg" in
        s)  socket="$OPTARG" ;;
        b)  echo '{ "command": [ "seek", "-10" ] }' | socat - "$socket" > /dev/null 2>&1 ;;
        f)  echo "$socket" && echo '{ "command": [ "seek", "+10" ] }' | socat - "$socket" > /dev/null 2>&1 ;;
        p)  echo 'cycle pause' | socat - "$socket" ;;
        r)  echo '{ "command": [ "set_property", "time-pos", "0" ] }' | socat - "$socket" > /dev/null 2>&1 ;;
        *)  echo "Invalid option !!"
    esac
done
