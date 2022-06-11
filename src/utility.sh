#!/usr/bin/bash

function backup {
    mv "$1" "$1.$(date +"%Y_%m_%d-%H_%M-%S%_z").prev"
}
