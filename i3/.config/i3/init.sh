#!/bin/bash

# NVIDIA sw cursor quirk workaround
if (glxinfo | grep "OpenGL vendor string:" | grep -q "NVIDIA Corporation"); then
    xrandr --output 'eDP-1-1' --set 'PRIME Synchronization' '0'
    xrandr --output 'eDP-1-1' --set 'PRIME Synchronization' '1'
fi

# Polybar
systemd-cat --identifier="polybar-${DISPLAY}" polybar -r default &

# Background
sh ~/.fehbg

# Touchpad
~/bin/touchpad.sh

# Compositor
systemd-cat --identifier="compton-${DISPLAY}" compton -Cc --dbus &

# Redshift
systemd-cat --identifier="redshift-${DISPLAY}" redshift -v &

# Unclutter
unclutter --timeout 1 --fork

# Notifications
/usr/lib/notification-daemon-1.0/notification-daemon &
