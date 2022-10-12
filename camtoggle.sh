#!/bin/bash
pkill -f /dev/video0 || setsid -f mpv --no-input-default-bindings --osd-level="0" --really-quiet --geometry="-0-0" --autofit="30%" "/dev/video0"
