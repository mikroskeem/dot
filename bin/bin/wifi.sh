#!/bin/zsh
if [ -z "${1}" ]; then
    buffer="" #"[ "
    wpa_cli list_networks | egrep -v "Selected interface '*'|^network id" | \
        awk -F '\t' '{print $1" "$2" "$4}' | \
    while read _p; do
        buffer+="${_p}\n"
    done
    echo -n "${buffer}"
else
    wpa_cli select_network "${1}" 1>&2
fi
