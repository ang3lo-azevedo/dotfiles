{
  services.lact = {
    enable = true;
    settings = {
      version = 5;
      daemon = {
        log_level = "info";
        admin_group = "wheel";
        disable_clocks_cleanup = false;
      };
      apply_settings_timer = 5;
      profiles = {
        "VR gaming" = {
          gpus."1002:7590-1DA2:E493-0000:2f:00.0" = {
            fan_control_enabled = false;
            performance_level = "manual";
            power_profile_mode_index = 4;
          };
          rule = {
            type = "or";
            filter = [
              {
                type = "process";
                filter = {
                  name = ".wivrn-dashboard-wrapped";
                };
              }
            ];
          };
        };
      };
      current_profile = "VR gaming";
      auto_switch_profiles = true;
    };
  };
}
