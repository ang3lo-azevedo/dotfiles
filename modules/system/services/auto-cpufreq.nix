{
  # Enable auto-cpufreq service to optimize CPU frequency based on usage
  services.auto-cpufreq = {
    enable = true;
    settings = {
      # Start power saving when on battery
      battery = {
        governor = "powersave";
        turbo = "never";
      };

      # Start performance mode when plugged in
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
}