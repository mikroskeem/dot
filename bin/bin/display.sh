#!/bin/zsh
if [ -z "${1}" ]; then
    buffer="" #"[ "
    find ~/.screenlayout/ -mindepth 1 -maxdepth 1 -name "*.sh" -exec basename {} \; | while read _p; do
        buffer+="${_p}\n"
    done
    echo -n "${buffer}"
else
    # TODO: preprocess
    bash ~/.screenlayout/$(basename "${1}")
fi
