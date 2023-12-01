# SteamWorkshopTools

This script is based on the use of SteamCMD. Read more [here](https://developer.valvesoftware.com/wiki/SteamCMD)

Русская версия доступна здесь: [тык](https://github.com/Sepera-okeq/SteamWorkshopTools/blob/main/README-RU.md)

Choose your own OS:
- [Windows](#Windows)
- [Linux](#Linux)
- [MasOS](#MasOS)


## Windows
1. Install SteamCMD by downloading this repository or [here](https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip)
2. Unpack it into a folder convenient for you. For example ``C:\SteamCMD``
3. Open PowerShell in``C:\SteamCMD`` or go there using ``cd C:\SteamCMD``
4. Create a vdf file to send to Steam.
```
 "workshopitem"
{
"appid" "394360" 
"publishedfileid" "0"
"contentfolder" "D:\Users\User\Documents\EC"
"previewfile" "D:\Users\User\Documents\EC\thumbnail.png"
"visibility" "0"
"title" "Heart of Iron IV: Economic Crisis"
"description" "here is the description of your product (which is shown when you log in to the product)"
"changenote" "update v0.7.6"
}
```
- appid - The Steam application ID. In our case, Heart of Iron IV is 394360
- publishedfileid - ID of the content in the Steam Workshop. Set to 0 if you are publishing for the first time. If not, then copy it from your page via `Copy the address of your page` and write out the mod ID.
Example: ``https://steamcommunity.com/sharedfiles/filedetails/?id=2000532465`` from the link, the mod ID is 2000532465
- contentfolder - The path to content, i.e. to mod.
- previewfile - The preview file of the content. I.e. the picture in the fashion folder *thumbnail.png*.
- visibility - The visibility of the object. 0 - open, 1 - for friends only, 2 - hidden
- title - Product Title
- description - The product description is in English.
- changenote - Description of the update in English.
5. Did you? Now it's time to send the mod to Steam!
Or we change the script-windows.bat and run it, or open PowerShell where SteamCMD is installed and write:

``./steamcmd.exe +login myLoginName myPassword +workshop_build_item "C:\SteamCMD\economic-crisis.vdf" +quit``

- myLoginName - your Steam login
- myPassword - your Steam password
- "C:\SteamCMD\economic-crisis.vdf" - the path to your vdf configuration file.

After SteamCMD uploads the necessary files to your computer, the process of filling the mod in Steam will begin. If you have SteamGuard enabled, SteamCMD will ask you to enter the key so that you can upload the mod.

## Linux
1. Use the scripts in bin/linux for your OS
  - [Debian/Ubuntu](https://github.com/Sepera-okeq/SteamWorkshopTools/blob/main/bin/linux/debian_ubuntu.sh)
  - [RedHat/CentOS](https://github.com/Sepera-okeq/SteamWorkshopTools/blob/main/bin/linux/redhat_centos.sh)
  - [Arch Linux](https://github.com/Sepera-okeq/SteamWorkshopTools/blob/main/bin/linux/arch_linux.sh)
2. After you have downloaded, create a vdf file in the same way as described in Windows in paragraph 4.
3. Did you? Now we will send the mod to Steam!

Or we change the script-linux.sh and run it, or open Terminal and write:

``steamcmd +login myLoginName myPassword +workshop_build_item "home\user\economic-crisis.vdf" +quit``

- myLoginName - your Steam login
- myPassword - your Steam password
- "C:\SteamCMD\economic-crisis.vdf" - the path to your vdf configuration file.

After SteamCMD uploads the necessary files to your computer, the process of filling the mod in Steam will begin. If you have SteamGuard enabled, SteamCMD will ask you to enter the key so that you can upload the mod.

## MasOS
1. Installation is performed via Terminal - [cmd](https://github.com/Sepera-okeq/SteamWorkshopTools/blob/main/bin/macos/macos.txt)
2. After that, use the same instructions as described in Linux for creating vdf and filling the mod, specifying only the path in your system.

After SteamCMD uploads the necessary files to your computer, the process of filling the mod in Steam will begin. If you have SteamGuard enabled, SteamCMD will ask you to enter the key so that you can upload the mod.

