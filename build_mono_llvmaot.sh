#!/usr/bin/env bash

#vars
BUILD_CONFIG=
BUILD_ALL=

parse_args() {
    if [ -z "$1" ] || ([ "$1" != "d" ] && [ "$1" != "r" ]); then
        if [ -z "$1" ]; then
            echo "You must specify build configuration 'd' for Debug or 'r' for Release"
        else
            echo "Invalid value '$1' for build configuration"
        fi
        return 1;
    elif [ "$1" == "d" ]; then
        BUILD_CONFIG="Debug"
    else
        BUILD_CONFIG="Release"
    fi

    if [ -z "$2" ]; then
        BUILD_ALL=
    else
        if [ "$2" == "all" ]; then
            BUILD_ALL="+libs+clr.hosts"
        else
            echo "Invalid value '$2' for subsets"
            return 1;
        fi
    fi
    return 0
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
    CMD="./build.sh mono$BUILD_ALL -c $BUILD_CONFIG /p:MonoEnableLlvm=true /p:MonoLLVMUseCxx11Abi=true"
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