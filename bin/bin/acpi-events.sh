#!/bin/bash

acpi_listen | while read _event; do
    find ~/.local/share/acpi-events/ -mindepth 1 -maxdepth 1 -name "*.sh" | while read _script; do
        test -x "${_script}" && {
            echo "Executing: ${_script}"
            "${_script}" "${_event}" &
        }
    done
done
