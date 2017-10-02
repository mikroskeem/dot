#!/bin/bash

event="${1}"
event_name="$(echo "${event}" | awk '{print $2}')"
event_type="$(echo "${event}" | awk '{print $3}')"

log () {
    systemd-cat --identifier="volume.sh" <<< "${1}"
}

if [ "${event_name}" = "HEADPHONE" ]; then
    case "${event_type}" in
        plug)
            log "jack plugged"

            # Tasks
            ;;
        unplug)
            log "jack unplugged"

            # Tasks
            ;;
    esac
fi
