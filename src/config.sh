#!/usr/bin/bash

if [[ ! -f config.sh ]]; then
    echo "Failed to load configuration file, 'config.sh' not found."
    exit 1
fi

source config.sh
