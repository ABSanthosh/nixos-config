# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # documentation.nixos.enable = false;
  
  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
    supportedFilesystems = [ "ntfs" ];
    kernelParams = ["quiet" "splash" "loglevel=0"];
    initrd.verbose = false;
    consoleLogLevel = 0;
    plymouth = { 
      enable = true; 
    };
  };

  systemd = {
    targets.network-online.wantedBy = pkgs.lib.mkForce []; # Normally ["multi-user.target"]
    services.NetworkManager-wait-online.wantedBy = pkgs.lib.mkForce []; # Normally ["network-online.target"]
  };

  # Enable OpenGL
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
  
      extraPackages = with pkgs; [
        vaapiVdpau
      ];
    };

    #nvidia = {
    #  open = false;
    #  nvidiaSettings = true;
    #  modesetting.enable = true;
    #  package = config.boot.kernelPackages.nvidiaPackages.stable;
    #  powerManagement = {
    #    enable = false;
    #    finegrained = false;
    #  };
    #  prime = {
    #    sync.enable = true;
    #    intelBusId = "PCI:0:2:0";
    #    nvidiaBusId = "PCI:1:0:0";
    #    };
    #};
  };

  networking.hostName = "zoro"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
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

  # Enable the X11 windowing system.
  services = {
    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
    
      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      # Configure keymap in X11
      layout = "us";
      xkbVariant = "";

      # GPU
      # videoDrivers = [ "nvidia" ];
      videoDrivers = [ "intel" ];
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # TLP
    thermald.enable = true;
    power-profiles-daemon.enable = false;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
 
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;
	START_CHARGE_THRESH_BAT0 = 65;
	STOP_CHARGE_THRESH_BAT0 = 60;
      };
    };

    # Disable tracker 
    gnome.tracker.enable = false;
    gnome.tracker-miners.enable = false;
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.santhosh = {
    isNormalUser = true;
    description = "Santhosh";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  # Allow unfree packages
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  fonts = { 
    fonts = with pkgs; [
      jetbrains-mono
    ];
    fontconfig = {
      enable = true;
      antialias = true;
      allowBitmaps = true;
      defaultFonts = {
        # monospace = "jetbrains-mono";
      };
    };
  };
  console.font = "jetbrains-mono";


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = { 
    systemPackages = with pkgs; [
      git
      neovim
      vscode
      pkgs.librewolf
      firefox
      amberol
      gnome.gnome-tweaks
      pkgs.brave

      # Development
      nodejs
      python311
      mysql80
      docker

      # fonts
      jetbrains-mono
      gnomeExtensions.freon
    ];

    gnome.excludePackages = with pkgs.gnome; [
      baobab      # disk usage analyzer
      epiphany    # web browser
      gedit       # text editor
      simple-scan # document scanner
      yelp        # help viewer
      geary       # email client
      seahorse    # password manager
   
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


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
