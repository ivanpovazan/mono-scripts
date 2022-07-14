#!/usr/bin/env bash
#TODO: rebuild ie rm -rf Native and Managed parts of the desired tests firts

#vars
BUILD_CONFIG=
TEST_PROJ=

parse_args() {
    if [ -z "$1" ]; then
        echo "Desired test project must be specified"
        return 1
    elif [ ! -f "src/tests/$1" ]; then
        echo "Test project: 'src/tests/$1' does not exist"
        return 1
    else
        TEST_PROJ=$1
    fi

    if [ -z "$2" ] || [ "$2" == "d" ]; then
        BUILD_CONFIG="Debug"
        return 0;
    elif [ "$2" == "r" ]; then
        BUILD_CONFIG="Release"
        return 0;
    else
        echo "Invalid value '$2' for build configuration"
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
    CMD="src/tests/build.sh $1 $BUILD_CONFIG /p:LibrariesConfiguration=$BUILD_CONFIG -test:$TEST_PROJ"
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
if [ $? -eq 0 ]; then
    main "mono"
    if [ $? -eq 0 ]; then
        main "mono_fullaot"
    else
        echo "--------"
        echo "Something went wrong!"    
    fi
else
    echo "--------"
    echo "Something went wrong!"
fi