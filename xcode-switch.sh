#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Pass the desired XCode path, for example: '/Applications/Xcode_14.1.0.app'"
    exit 1
else
    if [ ! -d "$1" ]; then
        echo "Directory '$1' does not exist."
        exit 1
    else
        echo "Setting Xcode version with: xcode-select --switch $1/Contents/Developer"
        xcode-select --switch $1/Contents/Developer
    fi
fi