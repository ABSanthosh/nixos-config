# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./home/home-manager.nix
      # ./home/system/vm.nix

      # Modules
      ./modules/postgresql.nix
      ./modules/tlp.nix
      ./modules/nix.nix
      ./modules/fonts.nix
      ./modules/hardware.nix
      ./modules/docker.nix
      ./modules/bluetooth.nix
      ./modules/sound.nix
      ./modules/activationScripts.nix
    ];

  nixpkgs = {
    config.allowAliases = false;
  };

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
    tmp.cleanOnBoot = true;
    supportedFilesystems = [ "ntfs" "exfat" ];
    kernelParams = [ "quiet" "splash" "loglevel=0" "intel_pstate=passive" "reboot=acpi" ];
    initrd.verbose = false;
    consoleLogLevel = 0;
    plymouth = {
      enable = true;
      logo = /etc/nixos/assets/plymouth/logo.png;
    };
  };

  systemd = {
    targets.network-online.wantedBy = pkgs.lib.mkForce [ ]; # Normally ["multi-user.target"]
    services = {
      systemd-udev-settle.enable = false;
      NetworkManager-wait-online = {
        enable = false;
        wantedBy = pkgs.lib.mkForce [ ]; # Normally ["network-online.target"] 
      };
    };
  };

  networking = {
    hostName = "zoro";
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "9.9.9.9" ];
    dhcpcd = {
      wait = "background";
      extraConfig = "noarp";
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_IN";
    extraLocaleSettings = {
      LC_ADDRESS = "en_IN";
      LC_IDENTIFICATION = "en_IN";
      LC_MEASUREMENT = "en_IN";
      LC_MONETARY = "en_IN";
      LC_NAME = "en_IN";
      LC_NUMERIC = "en_IN";
      LC_PAPER = "en_IN";
      LC_TELEPHONE = "en_IN";
      LC_TIME = "en_IN";
    };
  };

  services = {
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];

      # Enable the GNOME Desktop Environment.
      displayManager = {
        autoLogin = {
          enable = true;
          user = "santhosh";
        };
        gdm = {
          enable = true;
          wayland = true;
        };
      };
      desktopManager = {
        gnome = {
          enable = true;
        };
      };


      # Configure keymap in X11
      layout = "us";
      xkbVariant = "";

      # GPU
      videoDrivers = lib.mkForce [ "nvidia" ];
      # videoDrivers = [ "intel" ];
    };

    # Enable CUPS to print documents.
    printing.enable = false;
    avahi = {
      enable = true;
      nssmdns = true;
    };

    # Disable tracker 
    gnome.tracker.enable = false;
    gnome.tracker-miners.enable = false;

    # Enable the OpenSSH daemon.
    openssh.enable = true;

    # mySql
    mysql = {
      enable = true;
      package = pkgs.mariadb;
      # To configure the database, run the following
      # [nix-shell:~]$ mysql
      # mysql> select password('<password>');
      # +-------------------------------------------+
      # | password("Ranchero0")                     |
      # +-------------------------------------------+
      # | *432C338E13B8D7FB08E225BECBD0C0959CF98292 |
      # +-------------------------------------------+

      # [nix-shell:~]$ sudo mysql_secure_installation
      # then paste the above password and follow the instructions

    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.santhosh = {
    isNormalUser = true;
    description = "Santhosh";
    extraGroups = [ "networkmanager" "wheel" "audio" "docker" ];
    packages = with pkgs; [ ];
  };

  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    shellAliases = {
      nix-garbage = "sudo nix-collect-garbage && sudo nix-env --delete-generations +5 && sudo nixos-rebuild switch";
      nix-clear = "sudo nix profile wipe-history --profile /nix/var/nix/profile/system --older-than 5d && sudo nixos-rebuild switch";
      nix-refresh = "sudo nixos-rebuild switch";
    };
    systemPackages = with pkgs; [ ];

    gnome.excludePackages = with pkgs.gnome; [
      baobab # disk usage analyzer
      epiphany # web browser
      # gedit # text editor
      simple-scan # document scanner
      yelp # help viewer
      geary # email client
      # seahorse # password manager

      pkgs.gnome-tour
      gnome-characters
      gnome-logs
      gnome-maps
      gnome-music
      gnome-weather
      gnome-contacts
      pkgs.gnome-connections
      pkgs.gnome-photos
    ];
  };

  powerManagement = {
    cpuFreqGovernor = "performance";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system = {
    stateVersion = "23.11"; # Did you read the comment?
    autoUpgrade = {
      enable = true;
      allowReboot = false;
    };
  };
}
