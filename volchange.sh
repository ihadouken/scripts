#!/usr/bin/env bash
while getopts 'mMtu:d:' arg; do case "$arg" in
    m) amixer -q set Master mute ;;
    M) amixer -q set Master unmute ;;
    t) amixer -q set Master toggle ;;
    d) amixer -q set Master "$OPTARG%-" unmute ;;
    u) amixer -q set Master "$OPTARG%+" unmute ;;
esac done

play '/usr/share/sounds/freedesktop/stereo/audio-volume-change.oga' &> /dev/null

info="$(amixer get Master | tail -n 1)"
[[ "$info" != *"off"* ]] && vol="$(echo "$info" | grep -o '[0-9]\{1,3\}%')"

notify-send -h "int:value:${vol:-0}" -h string:x-dunst-stack-tag:volume -a 'Volume' "Volume: ${vol:-MUTE}"
