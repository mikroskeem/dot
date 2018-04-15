#!/bin/bash -e

FILE="/usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf"
XORG_FILE="/etc/X11/xorg.conf"

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

XORG_CONF='
Section "Module"
    Disable "nvidia"
EndSection

Section "OutputClass"
    Identifier "Intel"
    Option "PrimaryGPU" "yes"
    Driver "intel"
EndSection

Section "OutputClass"
    Identifier "nvidia"
    MatchDriver "nvidia-drm"
    Driver "none"
    ModulePath "/usr/lib/xorg/modules"
EndSection
'

NVIDIA_OFF="$(cat ~/.nvidia-off)"

has_module() {
    lsmod | grep -q "^${1}\s"
}

rmmod_loaded () {
    has_module "${1}" && \
        sudo rmmod "${1}"
}

has_nvidia () {
    has_module "nvidia"
    return ${?}
}

nvidia_off () {
    # Disable Xorg configuration
    sudo ln -sf /dev/null "${FILE}"
    echo -en "${XORG_CONF}" | sudo tee "${XORG_FILE}" 1>/dev/null

    # Remove modules and turn GPU off
    rmmod_loaded "nvidia_drm"
    rmmod_loaded "nvidia_modeset"
    rmmod_loaded "nvidia"

    echo -e "blacklist nvidia_drm\nblacklist nvidia_modeset\nblacklist nvidia" | sudo tee /etc/modprobe.d/20-nvidia.conf >/dev/null

    sudo tee /proc/acpi/bbswitch <<< OFF >/dev/null
}

nvidia_on () {
    sudo rm "${XORG_FILE}" || true
    sudo rm "${FILE}" || true

    # Restore Xorg configuration
    echo -en "$CONFIG" | sudo tee "${FILE}" 1>/dev/null

    # Turn GPU on
    sudo tee /proc/acpi/bbswitch <<<ON >/dev/null

    sudo rm /etc/modprobe.d/20-nvidia.conf

    # Load nvidia modules
    has_module "nvidia_drm" || sudo modprobe nvidia_drm modeset=1
    has_module "nvidia_modeset" || sudo modprobe nvidia_modeset
    has_module "nvidia" || sudo modprobe nvidia
}


if [ "${1}" = "restore" ]; then
    if [ "${NVIDIA_OFF}" = "yes" ]; then
        nvidia_off
    else
        nvidia_on
    fi

    exit 0
fi

if [ ! -z "${DISPLAY}" ]; then
    if [ "${NVIDIA_OFF}" = "yes" ]; then
        echo "Switched to NVIDIA"
        echo "no" > ~/.nvidia-off
    else
        echo "Switched to Intel"
        echo "yes" > ~/.nvidia-off
    fi

    echo "*** Restart your Xorg session"
    exit 0
fi

if ! readlink "${FILE}" || has_nvidia; then
    nvidia_off
    echo "Switched to Intel"
    echo "yes" > ~/.nvidia-off
else
    nvidia_on
    echo "Switched to NVIDIA"
    echo "no" > ~/.nvidia-off
fi
