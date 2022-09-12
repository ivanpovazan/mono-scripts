#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Pass the directory name as first parameter"
    exit 1
else
    if [ ! -d "$1" ]; then
        echo "Directory '$1' does not exist."
        exit 1
    else
        find $1 -type f -exec ls -l {} \; | awk '{sum += $5} END {print sum}'
    fi
fi