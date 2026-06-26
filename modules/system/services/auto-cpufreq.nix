{
  # auto-cpufreq and power-profiles-daemon are mutually exclusive: both control
  # the CPU scaling governor, so only one can be active at a time.
  services.power-profiles-daemon.enable = false;

  # auto-cpufreq monitors CPU load and battery state, switching governor and
  # turbo settings automatically. It only covers the CPU.
  #
  # TLP (if ever needed) goes further: battery charge thresholds (e.g. stop
  # charging at 80% to preserve long-term battery health), USB autosuspend,
  # PCI/NVMe runtime power management, and WiFi power saving. TLP can coexist
  # with auto-cpufreq if CPU governor control is disabled in TLP.
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        # powersave lets intel_pstate use HWP to scale dynamically, which is
        # more efficient than locking to a fixed frequency.
        governor = "powersave";

        # auto allows turbo boost when the CPU is under load (e.g. gaming on
        # battery). "never" would hurt performance significantly.
        turbo = "auto";

        # Intel Energy Performance Bias: hints to the CPU how to trade off
        # performance vs power. balance_power leans toward efficiency on battery.
        energy_perf_bias = "balance_power";
      };

      charger = {
        governor = "performance";
        turbo = "auto";

        # Favor performance over efficiency when plugged in.
        energy_perf_bias = "performance";
      };
    };
  };
}
