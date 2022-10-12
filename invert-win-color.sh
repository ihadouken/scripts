#!/usr/bin/env bash
# quering window properties
read -r window < <(xdotool getwindowfocus)
read -r state < <(xprop -id "$window" 8c TAG_INVERT)
echo "Before: $state"

# toggle color inversion variable
[[ "$state" == *1 ]] && state=0 || state=1

# apply the inversion toggle
xprop -id "$window" -format TAG_INVERT 8c -set TAG_INVERT "$state"
