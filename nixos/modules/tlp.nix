{ pkgs, config, ... }: {
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

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
