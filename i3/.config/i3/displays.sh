#!/bin/bash
source ~/.config/i3/common.sh

LID="$(cat /proc/acpi/button/lid/LID0/state | awk '/^state:/{print $2}')"
LID_OUTPUT="eDP-1"

# Yee...
if is_nvidia; then
    LID_OUTPUT="${LID_OUTPUT}-1"
fi

if [ "${LID}" = "closed" ]; then
    xrandr --output "${LID_OUTPUT}" --off
#elif [ "${LID}" = "open" ]; then
fi
