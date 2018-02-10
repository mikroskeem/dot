#!/bin/bash -e

FILE="/usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf"

# Update when it gets updated in 'nvidia-utils' package
CONFIG='
Section "OutputClass"
    Identifier "intel"
    MatchDriver "i915"
    Driver "modesetting"
EndSection

Section "OutputClass"
    Identifier "nvidia"
    MatchDriver "nvidia-drm"
    Driver "nvidia"
    Option "AllowEmptyInitialConfiguration"
    Option "PrimaryGPU" "yes"
    ModulePath "/usr/lib/nvidia/xorg"
    ModulePath "/usr/lib/xorg/modules"
EndSection
'

if ! readlink "${FILE}" 1>/dev/null ; then
    sudo ln -sf /dev/null "${FILE}"
    echo "Switched to Intel"
else
    sudo rm "${FILE}"
    echo -en "$CONFIG" | sudo tee "${FILE}" 1> /dev/null
    echo "Switched to NVIDIA"
fi

echo "Don't forget to restart your Xorg session!"
