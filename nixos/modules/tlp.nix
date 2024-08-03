{ pkgs, config, ... }:
{
  powerManagement = {
    enable = true;
    powertop.enable = true;
    # cpuFreqGovernor = "powersave";
  };

  # services = {
  #   thermald.enable = true;
  #   power-profiles-daemon.enable = false;
  #   tlp = {
  #     enable = true;
  #     settings = {
  #       # Thresholds
  #       # START_CHARGE_THRESH_BAT0 = 0;
  #       STOP_CHARGE_THRESH_BAT0 = 60;

  #       # General
  #       TLP_ENABLE = 1;
  #       TLP_DEFAULT_MODE = "BAT";
  #       TLP_PERSISTENT_DEFAULT = 1;

  #       # Remove dGPU 
  #       RUNTIME_PM_DRIVER_DENYLIST = "mei_me";

  #       # Extend battery life
  #       CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  #       CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

  #       PLATFORM_PROFILE_ON_AC = "performance";
  #       PLATFORM_PROFILE_ON_BAT = "balanced";

  #       CPU_BOOST_ON_AC = 1;
  #       CPU_BOOST_ON_BAT = 0;

  #       # CPU_HWP_DYN_BOOST_ON_AC = 1;
  #       # CPU_HWP_DYN_BOOST_ON_BAT = 0;

  #       # # Reduce power consumption on AC
  #       # RUNTIME_PM_ON_AC = "auto";
  #       # RUNTIME_PM_ON_BAT = "auto";

  #       # WIFI_PWR_ON_AC = "on";
  #       # WIFI_PWR_ON_BAT = "on";

  #       # # Limit power consumption on high load
  #       # CPU_MAX_PERF_ON_AC = "nn";
  #       # CPU_MAX_PERF_ON_BAT = "nn";
  #     };
  #   };
  # };
  services = {
    thermald.enable = true;
    power-profiles-daemon.enable = false;
    auto-cpufreq.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "balanced";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "balanced";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "balanced";

        # CPU_MIN_PERF_ON_AC = 0;
        # CPU_MAX_PERF_ON_AC = 100;
        # CPU_MIN_PERF_ON_BAT = 0;
        # CPU_MAX_PERF_ON_BAT = 20;
        START_CHARGE_THRESH_BAT0 = 65;
        STOP_CHARGE_THRESH_BAT0 = 60;

        TLP_DEFAULT_MODE = "BAT";
        TLP_PERSISTENT_DEFAULT = 1;
      };
    };
  };
}
