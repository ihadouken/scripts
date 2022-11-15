#!/bin/bash
ss_dir="$HOME/Pictures/screenshots"
fname="maim-$(date +%Y.%m.%d.%H-%M:%S).png"

maim > "$ss_dir/$fname" && notify-send -u low -i /usr/share/icons/elementary/places/24/folder-pictures.svg "Screenshot Captured" && paplay '/usr/share/sounds/freedesktop/stereo/camera-shutter.oga' 
cp -f "$ss_dir/$fname" "$ss_dir/latest.png"
