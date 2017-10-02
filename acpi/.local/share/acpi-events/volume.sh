#!/bin/bash

event="${1}"
event_name="$(echo "${event}" | awk '{print $2}')"

AUDIO_DEV="alsa_output.pci-0000_00_1b.0.analog-stereo"

log () {
    systemd-cat --identifier="volume.sh" <<< "${1}"
}

case "${event_name}" in
    VOLUP)
        log "Volume +1%"
        pactl set-sink-volume "${AUDIO_DEV}" +1%
        ;;
    VOLDN)
        log "Volume -1%"
        pactl set-sink-volume "${AUDIO_DEV}" -1%
        ;;
    MUTE)
        log "Mute toggle"
        pactl set-sink-mute "${AUDIO_DEV}" toggle
        ;;
esac
