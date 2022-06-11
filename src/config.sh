#!/usr/bin/bash

if [[ ! -f config.sh ]]; then
    echo "File 'config.sh' is missing."
    echo "To use template configuration type 'cp config.template.sh config.sh' and modify 'config.sh' file."
    echo "Exiting..."
    exit 1
fi

source config.sh
