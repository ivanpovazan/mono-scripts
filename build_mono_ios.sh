#!/usr/bin/env bash

#vars
BUILD_CONFIG=
TARGET_OS=

parse_args() {
    if [ "$1" == "d" ]; then
        BUILD_CONFIG="Debug"
    elif [ "$1" == "r" ]; then
        BUILD_CONFIG="Release"
    else
        echo "Invalid value '$1' for build configuration"
        return 1;
    fi

    if [ ! -z "$2" ] && ([ "$2" == "ios" ] || [ "$2" == "iossim" ] || [ "$2" == "tvos" ] || [ "$2" == "tvossim" ] || [ "$2" == "maccat" ]) ; then
        if [ "$2" == "iossim" ] ; then
            TARGET_OS="iossimulator"
        elif [ "$2" == "tvossim" ]; then
            TARGET_OS="tvossimulator"
        elif [ "$2" == "maccat" ]; then
            TARGET_OS="maccatalyst"
        else
            TARGET_OS=$2
        fi
        echo "Chosen target os is: '$TARGET_OS'"
        return 0;
    else
        echo "Invalid value '$2' for target os"
        return 1;
    fi
}

build () {
    eval $CMD
    if [[ "$?" -eq 0 ]]; then
        echo "--------"
        echo "SUCCESS"
        echo "--------"
        return 0
    else
        echo "--------"
        echo "FAIL"
        echo "--------"
        return 1
    fi
}

main () {
    CMD="./build.sh mono+libs -c $BUILD_CONFIG -os $TARGET_OS -arch arm64"
    echo "Building from: $PWD"
    echo  "With command: $CMD"
    while true; do
        read -p "Proceed? " yn
        case $yn in
            [Yy]* ) build; ret_val=$?; return $ret_val;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

parse_args $@
ok=$?

if [ $ok -eq 0 ]; then
    main
else
    echo "--------"
    echo "Something went wrong!"
    echo "Call the script with: 'bmios d ios'"
fi