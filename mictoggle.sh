#!/bin/bash
mic_sink='alsa_input.pci-0000_00_1f.3.analog-stereo'
pactl set-source-mute "$mic_sink" toggle

state=$(amixer get Capture | grep -o '\[on\|off\]' | uniq | tr -d '[]')

if [[ $state = "on" ]]; then
    icon="/usr/share/icons/Papirus-Light/24x24/panel/mic-on.svg"
	urgency="critical -t 15000"

elif [[ $state = "off" ]]; then
    icon="/usr/share/icons/Papirus-Light/16x16/panel/microphone-sensitivity-high.svg"
	urgency="low"
else 
    icon="/usr/share/icons/Papirus-Light/16x16/panel/microphone-sensitivity-high.svg"
	urgency="medium"
	state="in indeterminate state"
fi

notify-send -u $urgency -i $icon "Global Mic is $state"
