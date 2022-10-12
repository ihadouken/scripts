#!/bin/bash
filename="$HOME/Pictures/screenshots/maim-$(date +"%Y.%m.%d.%H-%M:%S").png"

maim > $filename && notify-send -u low -i /usr/share/icons/elementary/places/24/folder-pictures.svg "Screenshot Captured" && paplay '/usr/share/sounds/freedesktop/stereo/camera-shutter.oga' 
ln "$filename" "${filename%/*}latest.png"
