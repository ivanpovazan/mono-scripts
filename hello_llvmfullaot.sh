#!/usr/bin/env bash
# should be placed in src/mono/sample/HelloWorld/

REPO_ROOT=../../../..
LLVM_PATH=$REPO_ROOT/artifacts/bin/mono/osx.arm64.Debug
MONO_SGEN=$REPO_ROOT/artifacts/obj/mono/osx.arm64.Debug/mono/mini/mono-sgen
export MONO_PATH=$REPO_ROOT/artifacts/bin/HelloWorld/arm64/Debug/osx-arm64/publish

if [ "$1" != "build" ] && [ "$1" != "build-all" ] && [ "$1" != "run" ]; then
    echo "Pass 'build', 'build-all' or 'run' as the first parameter"
    echo "If 'build' - pass the name of the assembly as second"
    echo "If 'run' - pass 'log' as third for verbose logging"
    exit 1
fi

if [ "$1" == "build" ] || [ "$1" == "build-all" ]; then
    export MONO_ENV_OPTIONS=" --aot=full,llvm,llvm-path=$LLVM_PATH,mattr=crc,mattr=crypto"
    
    if [ "$1" == "build-all" ]; then 
        DLLS=$MONO_PATH/*.dll;
    else
        if [ -z "$2" ]; then
            echo "Please pass the name of the assembly ex: HelloWorld.dll"
            exit 1
        fi
        DLLS=$MONO_PATH/$2;
    fi
    for dll in $DLLS; 
    do
        echo "> AOTing MONO_ENV_OPTIONS=$MONO_ENV_OPTIONS $dll";
        $MONO_SGEN $dll
        if [ $? -eq 1 ]; then
            echo "> AOTing MONO_ENV_OPTIONS=$MONO_ENV_OPTIONS $dll has failed.";
            exit 1
        fi
    done
else
    export MONO_ENV_OPTIONS="--full-aot"

    if [ "$2" == "log" ]; then
        LOG_LEVEL=debug 
        LOG_MASK=aot
    fi
    
    echo "Running HelloWorld with: MONO_ENV_OPTIONS=$MONO_ENV_OPTIONS $MONO_SGEN $MONO_PATH/HelloWorld.dll";
    MONO_LOG_LEVEL=$LOG_LEVEL MONO_LOG_MASK=$LOG_MASK $MONO_SGEN $MONO_PATH/HelloWorld.dll
fi
exit 0


