#!/bin/zsh
if [ -z "${1}" ]; then
    buffer="" #"[ "
    find ~/.local/share/shortcuts/ -mindepth 1 -maxdepth 1 -type f -executable -exec basename {} \; | while read _p; do
        buffer+="${_p}\n"
    done
    echo -n "${buffer}"
else
    bash ~/.local/share/shortcuts/$(basename "${1}")
fi
