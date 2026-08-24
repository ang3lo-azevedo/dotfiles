{
  inputs,
  config,
  ...
}: {
  imports = [inputs.nirinit.nixosModules.nirinit];

  services.nirinit = {
    enable = true;
    # You can configure custom launch commands for specific app_ids here:
    settings = {
      launch = {
        "com.mitchellh.ghostty" = "ghostty";
        "org.mozilla.firefox" = "firefox";
        "Code" = "code";
        "Spotify" = "spotify";
      };
      # Apps to ignore when restoring:
      # ignore = [
      #   "org.wezfurlong.wezterm"
      # ];
    };
  };

  environment.systemPackages = [config.services.nirinit.package];
}
