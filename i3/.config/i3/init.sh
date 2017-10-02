#!/bin/bash

source ~/.config/i3/common.sh

# NVIDIA sw cursor quirk workaround
if is_nvidia; then
    for output in 'eDP-1-1' 'HDMI-1-1'; do
        xrandr --output "${output}" --set 'PRIME Synchronization' '0'
        xrandr --output "${output}" --set 'PRIME Synchronization' '1'
    done
fi

# Setup acpi listener
systemd-cat --identifier="ACPI listener" bash ~/bin/acpi-events.sh &

# Setup displays
bash ~/.config/i3/displays.sh

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

# See https://github.com/flatpak/xdg-desktop-portal-gtk/issues/72
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY
