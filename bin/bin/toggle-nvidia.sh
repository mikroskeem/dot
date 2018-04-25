#!/bin/bash -e

FILE="/usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf"
XORG_FILE="/etc/X11/xorg.conf"

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
    sudo mount --bind /dev/null "${FILE}"
    echo -en "${XORG_CONF}" | sudo tee "${XORG_FILE}" 1>/dev/null

    # Remove modules and turn GPU off
    rmmod_loaded "nvidia_drm"
    rmmod_loaded "nvidia_modeset"
    rmmod_loaded "nvidia"

    sudo tee /proc/acpi/bbswitch <<< OFF >/dev/null
}

nvidia_on () {
    [ -f "${XORG_FILE}" ] && sudo rm "${XORG_FILE}"

    # Restore Xorg configuration
    if (cat /proc/mounts | grep -q "${FILE}"); then
        sudo umount "${FILE}"
    fi

    # Turn GPU on
    sudo tee /proc/acpi/bbswitch <<<ON >/dev/null

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
