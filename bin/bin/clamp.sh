#!/bin/zsh

find_powerclamp () {
    find /sys/class/thermal -name "cooling_device*" | while read _p; do
        if (cat "${_p}/type" | grep -q "intel_powerclamp"); then
            echo "${_p}"
            break
        fi
    done
}

if [ -z "${1}" ]; then
    echo "Usage: ${0} 0-50"
    exit 1
fi

clamp_dev="`find_powerclamp`"

if [ ! -z "${clamp_dev}" ]; then
    sudo tee "${clamp_dev}/cur_state" <<<${1}
fi
