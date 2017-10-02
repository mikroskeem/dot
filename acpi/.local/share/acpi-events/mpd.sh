
#!/bin/bash

event="${1}"
event_name="$(echo "${event}" | awk '{print $2}')"
mpd_socket=~/.config/mpd/mpd.sock

log () {
    systemd-cat --identifier="mpd.sh" <<< "${1}"
}

case "${event_name}" in
    CDPLAY)
        log "toggle play"
        mpc -h "${mpd_socket}" toggle
        ;;
    CDNEXT)
        log "next"
        mpc -h "${mpd_socket}" next
        ;;
    CDPREV)
        log "prev"
        mpc -h "${mpd_socket}" prev
        ;;
esac
