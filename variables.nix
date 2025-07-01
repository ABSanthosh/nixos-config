{
  # Git Configuration ( For Pulling Software Repos )
  git = {
    userName = "ABSanthosh";
    userEmail = "a.b.santhosh02@gmail.com";
  };

  # User Configuration
  user = {
    name = "santhosh";
    home = "/home/santhosh";
    host = "zoro";
    system = "x86_64-linux";
  };

  # Colorscheme
  catppuccin = {
    flavor = "mocha";
    kitty_theme = "catppuccin-mocha"; # catppuccin-frappe | catppuccin-latte | catppuccin-macchiato | catppuccin-mocha
  };

  # Program Options
  browser = "brave"; # Set Default Browser (google-chrome-stable for google-chrome)
  terminal = "kitty"; # Set Default System Terminal
  wallpaper = assets/Wallpapers/Misc/anime-cplusplus.jpg;
  stateVersion = "25.05";

  # Sops
  sops = {
    secrets = ./secrets.yaml;
  };

  bluetooth = {
    airpods = {
      command-name = "inheritance";
      name = "Inheritance(AirPods ProMax)";
      address = "90:9C:4A:E3:B6:FB"; # Replace with your AirPods MAC address
    };
    jawbone = {
      command-name = "jawbone";
      name = "Jawbone Mini Jambox";
      address = "E0:D1:E6:05:A6:67"; # Replace with your Jawbone MAC address
    };
    recurrence = {
      command-name = "recurrence";
      name = "Recurrence(iPhone 12 Pro)";
      address = "94:5C:9A:D5:58:35"; # Replace with your Recurrence MAC address
    };
  };
}
