{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lutris
    
    # Wine and compatibility layers
    wine
    winetricks
    dxvk  # DirectX to Vulkan translation
    
    # Performance monitoring
    mangohud
    gamemode
    
    # Optional: other game launchers
    # heroic        # Epic Games & GOG
    bottles       # Wine prefix manager
  ];

  # Optional: Set default environment variables for Lutris
  # This makes games use NVIDIA by default when launched from Lutris
  # Remove this section if you want to manually control per-game
  home.sessionVariables = {
    # Uncomment these to make Lutris always use NVIDIA:
    LUTRIS_RUNTIME = "1";
    LUTRIS_SKIP_INIT = "0";
  };
}