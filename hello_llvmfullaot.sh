# should be placed in src/mono/sample/HelloWorld/
REPO_ROOT=../../../..
LLVM_PATH=$REPO_ROOT/artifacts/bin/mono/OSX.arm64.Debug
MONO_SGEN=$REPO_ROOT/artifacts/obj/mono/OSX.arm64.Debug/mono/mini/mono-sgen
export MONO_PATH=$REPO_ROOT/artifacts/bin/HelloWorld/arm64/Debug/osx-arm64/publish

if [ "$1" != "build" ] && [ "$1" != "run" ]; then
    echo "Pass 'build' or 'run' as the first parameter";
    exit 1
fi

if [ "$1" == "build" ]; then
    export MONO_ENV_OPTIONS="--aot=full,llvm,llvm-path=$LLVM_PATH,mattr=crc,mattr=crypto"
    if [ "$2" == "all" ]; then 
        DLLS=$MONO_PATH/*.dll;
    else
        DLLS=$MONO_PATH/HelloWorld.dll;
    fi
    for dll in $DLLS; 
    do
        echo "> AOTing $dll";
        $MONO_SGEN $dll
        if [ $? -eq 1 ]; then
            echo "> AOTing $dll has failed.";
            exit 1
        fi
    done
else
    export MONO_ENV_OPTIONS="--full-aot"
    $MONO_SGEN $MONO_PATH/HelloWorld.dll
fi
exit 0


