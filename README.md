<p align="center"><img src="./assets/Readme/nix_flake.png" width=400px></p>

<h1 align="center">
  Santhosh's NixOS Configs
</h1>

## Installation
1. Download and install the OS with GNOME config from here: https://nixos.org/download/
2. Once the OS is setup, open terminal and do the following:
```shell
cd /etc/nixos
mkdir ./temp
mv ./* ./temp
git clone https://github.com/ABSanthosh/nixos-config.git
mv ./nixos-config/* ./
mv ./nixos-config/.git ./
mv ./nixos-config/.gitignore ./
rm -fr ./nixos-config/
rm ./nixos/hardware-configuration.nix
mv ./temp/hardware-configuration.nix ./nixos/hardware-configuration.nix

sudo nixos-rebuild switch --flake .#<device name>
```
3. This should give you an exact copy of my laptop.

<details open="true">
<summary>
To Do 
</summary>

  ~~- [ ] Sounds~~
    ~~- [ ] move 'ocean' from `~/.local/share/sounds` to `/nixos/assets` and make a symlink to it.~~
  - [x] Bookmark in nautilus: https://discourse.nixos.org/t/how-to-set-the-bookmarks-in-nautilus/36143
  - [x] Git credentials, how to set up git so it won't ask for credentials every time?
  - [x] Fonts
  - [x] Editors
    - [x] VSCode(Config ref: [1](https://github.com/utdemir/dotfiles-nix/blob/297edd96ade9b6437dcf2cb0a7336513ad10f495/home-modules/vscode.nix))
    - [x] Neovim(Config ref: [1](https://github.com/Kranzes/nix-config/blob/9a1a96ad4994059e40e217fd9266a0cc2fd16b01/home/kranzes/editors.nix))
  - [x] Browser config
  - [x] Screenshot tool _[ref](https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/5208#note_1426865)_
  - [x] Cursor
  - [x] Gnome extensions
  - [x] Wallpaper
  ~~- [ ] User picture not working~~
  - [x] Time to 12 hours format
  - [ ] brave browser
    - [ ] Addresses
    - [ ] passwords
  - [x] Screen sharing with external monitor
  - [ ] Stylix for sway
  - [ ] a side panel for auth codes (maybe with TUI)
  - [ ] Keyboard shortcuts panel for reference
  - [ ] better support for code env:
    - [ ] python 
    - [ ] general fix for linking issues
  - [ ] Dynamic external monitor support. Right now, "video=DP-2:1920x1080@60" is hardcoded in the boot.nix file.

</details>

<details>
<summary> Misc Setups </summary>

### Set up prism launcher for free offline account ([ref](https://github.com/antunnitraj/Prism-Launcher-PolyMC-Offline-Bypass))

1. Install Prism Launcher
2. Go through the quick setup
3. run this command

```sh
echo '{"accounts": [{"entitlement": {"canPlayMinecraft": true,"ownsMinecraft": true},"type": "Offline"}],"formatVersion": 3}' > ~/.local/share/PrismLauncher/accounts.json
echo '{"accounts": [{"profile": {"capes": [],"id": "49787d61f64b3b94a8f13d331a9ce421","name": "MrSandman","skin": {"id": "","url": "","variant": ""}},"type": "Offline","ygg": {"extra": {"clientToken": "54e6a07be4414740bc08917e0a9a125c","userName": "MrSandman"},"iat": 1716738991,"token": "0"}}],"formatVersion": 3}' > ~/.local/share/PrismLauncher/accounts.json
```

4. Create an offline account
5. Delete the "No Profile" account
6. Set the new account as the default
7. Enjoy!

_Note: Don't delete the "No Profile" account before you create a new offline account, that will break it!_

### Remove "Failed to save 'xyz': insufficient permissions" error ([ref](https://stackoverflow.com/a/62515421/10376131))


```sh
sudo chown -R $USER .
```
</details>

<p align="center"><img src="./assets/Readme/border_bottom.png" width=80%></p>


### Connect to wifi with nmcli

```bash
nmcli dev wifi list
nmcli device wifi connect "SSID" password "<Pass>"
route -n #if its a public wifi and you want to open the captive portal. Used the first gateway
```

## References  
- It has a lot of good stuff: https://github.com/3rd/config/tree/b9e4c0ea11d724e9d94c413d790b1a2151a694ff