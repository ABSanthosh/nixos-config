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

  - [ ] Sounds
    - [ ] move 'ocean' from `~/.local/share/sounds` to `/nixos/assets` and make a symlink to it.
  - [ ] Bookmark in nautilus: https://discourse.nixos.org/t/how-to-set-the-bookmarks-in-nautilus/36143
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
  - [ ] User picture not working
  - [x] Time to 12 hours format
  - [ ] brave browser
    - [ ] Addresses
    - [ ] passwords
  - Screen sharing with external monitor

</details>

<details>
<summary> Misc Setups </summary>

### Set up prism launcher for free offline account ([ref](https://github.com/antunnitraj/Prism-Launcher-PolyMC-Offline-Bypass))

1. Install Prism Launcher
2. Go through the quick setup
3. run this command

```sh
echo '{"accounts": [{"entitlement": {"canPlayMinecraft": true,"ownsMinecraft": true},"type": "Offline"}],"formatVersion": 3}' > ~/.local/share/PrismLauncher/accounts.json
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
