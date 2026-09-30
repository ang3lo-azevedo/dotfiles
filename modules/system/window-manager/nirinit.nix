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
      # Launched in a fixed layout by niri's right-screen.sh instead
      skip.apps = [
        "app.btop"
        "app.nix-config-term"
        "equibop"
        "zapfast"
      ];
    };
  };

  environment.systemPackages = [config.services.nirinit.package];
}
