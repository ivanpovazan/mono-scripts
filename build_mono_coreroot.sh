#!/usr/bin/env bash

#vars
BUILD_CONFIG=

parse_args() {
    if [ -z "$1" ] || [ "$1" == "d" ]; then
        BUILD_CONFIG="Debug"
        return 0;
    elif [ "$1" == "r" ]; then
        BUILD_CONFIG="Release"
        return 0;
    else
        echo "Invalid value '$1' for build configuration"
        return 1;
    fi
}

build () {
    eval $CMD
    if [[ "$?" -eq 0 ]]; then
        echo "--------"
        echo "SUCCESS"
        echo "Exporting CORE_ROOT environment variable"
        export CORE_ROOT="$PWD/artifacts/tests/coreclr/OSX.arm64.Debug/Tests/Core_Root"
        echo "CORE_ROOT=$CORE_ROOT"
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
    CMD="src/tests/build.sh mono $BUILD_CONFIG /p:LibrariesConfiguration=$BUILD_CONFIG generatelayoutonly"
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
fi
