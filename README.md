# NixOS Configurations


### Fast boot configs(At least attempts)
- https://majiehong.com/post/2021-07-30_slow_nixos_startup/


### ToDo
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

## Set up prism launcher for free offline account ([ref](https://github.com/antunnitraj/Prism-Launcher-PolyMC-Offline-Bypass))

1) Install Prism Launcher
2) Go through the quick setup
3) run this command 

```sh
echo '{"accounts": [{"entitlement": {"canPlayMinecraft": true,"ownsMinecraft": true},"type": "Offline"}],"formatVersion": 3}' > ~/.local/share/PrismLauncher/accounts.json
```
4) Create an offline account
5) Delete the "No Profile" account
6) Set the new account as the default
7) Enjoy!

_Note: Don't delete the "No Profile" account before you create a new offline account, that will break it!_

### Remove "Failed to save 'xyz': insufficient permissions" error
[ref](https://stackoverflow.com/a/62515421/10376131)
```sh
sudo chown -R $USER .
```


Hey! I'm Santhosh, incoming fall 2024 graduate student at Penn State university. I'm interested 