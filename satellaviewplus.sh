#!/bin/bash
# Get script directory.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CONFIGFILE="./config.cfg"

# Source - https://stackoverflow.com/a/5984215
# Posted by clt60, modified by community. See post 'Timeline' for change history
# Retrieved 2026-09-14, License - CC BY-SA 3.0
eval $(sed '/:/!d;/^ *#/d;s/:/ /;' < "$CONFIGFILE" | while read -r key val
do
    #verify here
    #...
    str="$key='$val'"
    echo "$str"
done)
# End of StackOverflow source

# Check for Satellaview+
if [ -e "$SCRIPT_DIR"/Satellaview+*.appimage ]
then
    echo "Satellaview+.appimage exists. Continuing."
else
    echo "Satellaview+.appimage does NOT exist. Grabbing..."
    # Currently, I'll have to manually update this everytime they update the file.
    # There are plans to make the update process more automated so probably best to grab checksums and compare for now.
    # TODO: Figure out how to check checksums and download a new copy for future versions.
    curl "https://satellaview-plus.com/client/linux-x64/Satellaview+_V5.AppImage" --output "$SCRIPT_DIR"/Satellaview+.appimage
    echo "Marking appimage as executable (chmod +x Satellaview+.appimage)"
    chmod +x Satellaview+.appimage
fi

if [ -e "$EMULATOR" ]
then
    echo "Found emulator at: $EMULATOR. Continuing."
else
    echo "There does not appear to be an emulator at $EMULATOR."
    echo "Are you sure you've typed in the location correctly?"
    echo "Would you like to install SNES9x 1.63? [y/N]"
    read -n 1 ANSWER
    if [ $ANSWER == "y" ]
    then
        curl -L "https://github.com/snes9xgit/snes9x/releases/latest/download/Snes9x-1.63-x86_64.AppImage" --output "$SCRIPT_DIR"/SNES9x.appimage
        echo "Marking appimage as executable (chmod +x SNES9x.appimage)"
        chmod +x SNES9x.appimage
    else
        echo "Please see the config.cfg for instructions. Exiting."
        exit 1
    fi
fi

# Check for config for Satellaview+, automate building one if there is none to be found.
# This is to ensure the least amount of pain from setup as humanly possible.
if [ -e "$SCRIPT_DIR"/config.json ]
then
    echo "Satellaview+ Config exists. Continuing."
else
    echo "Satellaview+ Config does not exist. Creating."
    jq -n --arg dl ""$SCRIPT_DIR"" --arg emu ""RetroArch"" --argjson strtmin false --argjson quitonclose true '{DownloadLocation: $dl, Emulator: $emu, StartMinimized: $strtmin, ExitOnClose: $quitonclose}' > config.json
fi

# Satellaview+ - Needs a few moments to download satdata
echo "Booting up Satellaview+..."
# Original boot, use if launching directly as opposed to a terminal or 3rd party launcher
# ./Satellaview+.appimage
"$SCRIPT_DIR"/Satellaview+.appimage &

# Wait until bs-x.sfc is available.
# If setup went correctly, Satellaview+ will download the RetroArch version, which includes the vaunted bs-x.sfc that's included into the satdata.
# Using any other method will cause the program to delete BS-X.sfc everytime.
until [ -e "$SCRIPT_DIR"/roms/bs-x/bs-x.sfc ]; do
    sleep 1
done
# Boot BS-X - Much more simpler.
sleep 5
# The sleep is deliberate for handheld PCs such as Steam Deck to ensure the emulator is the last thing opened to focus on, otherwise, Satellaview+ will be in focus.
echo "Beginning boot up for BS-X..."
cd "$SCRIPT_DIR"
"$EMULATOR" ./roms/bs-x/bs-x.sfc
