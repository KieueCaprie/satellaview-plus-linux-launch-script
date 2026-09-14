#!/bin/bash
# Necessary to stop Qt-Raster weirdness in Wayland.
export QT_QPA_PLATFORM=xcb
# Get script directory.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# Define emulator location. Since this is easymode, we're only going to use bsnes-plus here.
EMULATOR="default/bsnes-plus/bsnes"

# Check for Satellaview+
if [ -e "$SCRIPT_DIR"/Satellaview+.appimage ]
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

# Check for config for Satellaview+, automate building one if there is none to be found.
# This is to ensure the least amount of pain from setup as humanly possible.
if [ -e "$SCRIPT_DIR"/config.json ]
then
    echo "Satellaview+ Config exists. Continuing."
else
    echo "Satellaview+ Config does not exist. Creating."
    jq -n --arg dl ""$SCRIPT_DIR"" --arg emu ""BSNES\u002B"" --argjson strtmin false --argjson quitonclose true '{DownloadLocation: $dl, Emulator: $emu, StartMinimized: $strtmin, ExitOnClose: $quitonclose}' > config.json
fi

# Satellaview+ - Needs a few moments to download satdata
echo "Booting up Satellaview+..."
# Original boot, use if launching directly as opposed to a terminal or 3rd party launcher
# ./Satellaview+.appimage
echo ""$SCRIPT_DIR"/Satellaview+.appimage"
cd "$SCRIPT_DIR"
"$SCRIPT_DIR"/Satellaview+.appimage &

# Wait until the satdata directory is available.
until [ -e "$SCRIPT_DIR"/satdata ]; do
    sleep 1
done

# Grab BS-X.sfc from the Satellaview+ site. Debating on whether it'd be better to just put it in the repository.
if [ -e "$SCRIPT_DIR"/BS-X.sfc ]
then
    echo "BS-X rom file exists. Continuing."
else
    curl -L "https://satellaview-plus.com/client/BS-X.zip" --output "$SCRIPT_DIR"/BS-X.zip
    unzip BS-X.zip
    rm "$SCRIPT_DIR"/BS-X.zip
fi

ln -s "$SCRIPT_DIR"/satdata "$SCRIPT_DIR"/default/bsnes-plus/bsxdat
# Boot BS-X - Much more simpler.
echo "Beginning boot up for BS-X..."
echo "$EMULATOR" ./roms/bs-x/bs-x.sfc
echo "Attempting "$SCRIPT_DIR"/$EMULATOR ./BS-X.sfc..."
# Ensure that bsnes-plus is actually executable before we actually launch
chmod +x "$SCRIPT_DIR"/default/bsnes-plus/bsnes
# sh -c "cd "$SCRIPT_DIR"/default/bsnes-plus && LD_LIBRARY_PATH=libs "$SCRIPT_DIR"$EMULATOR "$SCRIPT_DIR/roms/bs-x/bs-x.sfc""
LD_LIBRARY_PATH="$SCRIPT_DIR"/default/bsnes-plus/libs "$SCRIPT_DIR"/default/bsnes-plus/bsnes -bs "$SCRIPT_DIR/BS-X.sfc"
