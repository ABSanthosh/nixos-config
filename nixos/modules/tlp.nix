{ pkgs, config, ... }: {
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  services = {
    thermald.enable = true;
    power-profiles-daemon.enable = false;
    # auto-cpufreq.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "balanced";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "balanced";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        START_CHARGE_THRESH_BAT0 = 65;
        STOP_CHARGE_THRESH_BAT0 = 60;

        TLP_DEFAULT_MODE = "BAT";
        TLP_PERSISTENT_DEFAULT = 1;

        RUNTIME_PM_ON_AC = "on";
        RUNTIME_PM_ON_BAT = "auto";

        # Platform
        PLATFORM_PROFILE_ON_BAT = "low-power";
        PLATFORM_PROFILE_ON_AC = "perfomance";

        # Processor
        CPU_BOOST_ON_BAT = 0;
        CPU_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 0;
        CPU_HWP_DYN_BOOST_ON_AC = 1;
      };
    };
  };
}
