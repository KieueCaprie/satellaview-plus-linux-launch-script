# satellaviewplus-linux-launch-script
### This is NOT affiliated with any projects mentioned, please review all code in the shell file before executing!
A launch script created specifically for launching Satellaview + (https://satellaview-plus.com) and BS-X in an emulator of your choice. The script defaults to the basic SNES9x appimage if there are none defined (https://github.com/snes9xgit/snes9x).

# Currently supports
- Linux - Tested on ArchLinux (tested on EndeavourOS).

# Known issues
* AMD64 devices cannot launch SNES9x, rendering the script useless.

# How to use
1. Download the repository by using ```git clone https://github.com/KieueCaprie/satellaview-plus-linux-launch-script.git``` or by clicking on Code in the main Github page and clicking "Download ZIP".
2. If you've downloaded the zip, remember to place it in an easily accessible spot.
3. Navigate to the folder containing the launch script.
4. Make "satellaviewplus.sh" executable by either using ```chmod +x satellaviewplus.sh``` or by right-clicking, going to properties, going to the Permissions tab, and checking "Allow executing file as program".
5. Execute the script.

TODO:
- Figure out how to get the most up-to-date Linux client for Satellaview+ in case of future updates. Current script downloads V5.
- Compile SNES9x in an AMD64 environment, somehow.

# satellaview-plus-linux-launch-script-easymode
A launch script created specifically for launching Satellaview + (https://satellaview-plus.com) and BS-X in BSNES-Plus. Intended for use for people who just want something that at least works without much setup needed.

# Currently supports
- Linux - Tested on EndeavourOS (an Arch Linux distro) and SteamOS (via Steam Deck)

# Known issues
* Configs are sometimes forgotten. Workaround is to restart the script until it sticks. Alternatively, booting the script up in a proper desktop environment can help with troubleshooting.
* BSNES-Plus may crash on initial startup. This is normal. It may also forget the included config. This, too, is normal, unfortunately.

# How to use
1. Follow the directions as above, except with ```satellaviewplus-easymode.sh```.
2. If running through Steam, add as a Non Steam Game by navigating to Steam > Games > Add a Non-Steam Game to my Library... > Browse > ```satellaviewplus-easymode.sh```'s location.

TODO:
- Figure out how to fix the known issues! It's annoying to have a pre-built config only for it to just explode anyway!

# Human statement
No generative AI was used in any step of the process and it will stay that way. This script was built with blood, sweat, and tears. Mostly tears (mine), lot of tears. So many tears.
