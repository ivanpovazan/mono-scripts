if [ -z "$1" ]; then
    echo "Pass the dotnet version you would like to get the download URL for"
    exit 1
else
    DOTNET_VERSION=$1
fi

SCRIPT_URL="https://dot.net/v1/dotnet-install.sh"
SCRIPT_NAME="dotnet-install.sh"
DOTNET_INSTALLER="/tmp/$SCRIPT_NAME"

echo "--------"
echo "Downloading the installer script into: $DOTNET_INSTALLER"
curl --retry 20 --retry-delay 2 --connect-timeout 15 -S -L $SCRIPT_URL --output $DOTNET_INSTALLER >/dev/null 2>&1
chmod +x $DOTNET_INSTALLER

echo "Fetching URL for dotnet version: '$DOTNET_VERSION' package"
CMD="$DOTNET_INSTALLER --version $DOTNET_VERSION --architecture arm64 --no-path --dry-run | grep URL.*primary: | sed 's/.*primary: //'"
RES=$(eval "$CMD")
for url in $RES;
do
    #pkg=${url%.tar.gz}.pkg
    pkg=$url
    if curl -LI --fail "$pkg" >/dev/null 2>&1; then echo "$pkg"; break; fi;
done

echo "Removing the script from: $DOTNET_INSTALLER"
rm -f $DOTNET_INSTALLER
echo "--------"