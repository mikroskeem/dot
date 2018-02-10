# NVIDIA
if (glxinfo | grep "OpenGL vendor string:" | grep -q "NVIDIA Corporation"); then
    xrandr --setprovideroutputsource modesetting NVIDIA-0
    nvidia-settings --load-config-only
else
    [ -f ~/.ilikenouveau ] && export DRI_PRIME=1
fi
xrandr --dpi 106
xrandr --auto

# X resources
xrdb -l ~/.Xresources

# WM
exec systemd-cat --identifier="i3-${DISPLAY}" i3
