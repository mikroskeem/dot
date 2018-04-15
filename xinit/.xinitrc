# NVIDIA
if (glxinfo | grep "OpenGL vendor string:" | grep -q "NVIDIA Corporation"); then
    xrandr --setprovideroutputsource modesetting NVIDIA-0
    nvidia-settings --load-config-only

    # Fix Vulkan support when vulkan-intel is installed
    export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json
else
    [ -f ~/.ilikenouveau ] && export DRI_PRIME=1
fi
xrandr --dpi 106
xrandr --auto

# X resources
xrdb -l ~/.Xresources

# Wine
export WINEDEBUG=-all

# WM
if [ "${XDG_VTNR}" -eq 2 ]; then
    exec systemd-cat --identifier="openbox-${DISPLAY}" openbox
else
    exec systemd-cat --identifier="i3-${DISPLAY}" i3
fi
