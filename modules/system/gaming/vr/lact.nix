{
  lib,
  pkgs,
  ...
}: let
  lactSettings = {
    version = 5;
    daemon = {
      log_level = "info";
      admin_group = "wheel";
      disable_clocks_cleanup = false;
    };
    apply_settings_timer = 5;
    profiles = {
      "VR gaming" = {
        # Key format: "vendor:device-subsystem_vendor:subsystem_device-DBDF"
        # Run `lact gui` or check /sys/bus/pci/devices to find your GPU's identifier.
        gpus."1002:7590-1DA2:E493-0000:2f:00.0" = {
          fan_control_enabled = false;
          performance_level = "manual";
          # Index 4 is "VR Ready Premium" on RDNA3, which disables power-saving clock gating
          # and keeps clocks stable, reducing latency spikes during reprojection.
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

  settingsJson = builtins.toJSON lactSettings;
  settingsFile = pkgs.writeText "lact-config.json" settingsJson;
in {
  services.lact = {
    enable = true;
    # Disable settings management to allow mutable config
    settings = lib.mkForce {};
  };

  # Create writable config file via activation script
  system.activationScripts.lactSettings = ''
    configDir="/etc/lact"
    configPath="$configDir/config.yaml"

    # Create directory if it doesn't exist
    mkdir -p "$configDir"

    # Copy settings from Nix store, making it writable
    # This overwrites on each rebuild to apply Nix-defined settings
    cp -f "${settingsFile}" "$configPath"
    chmod u+w "$configPath"
  '';
}
