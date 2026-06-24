{
  inputs,
  config,
  ...
}: {
  imports = [inputs.nirinit.nixosModules.nirinit];

  services.nirinit = {
    enable = true;
    # You can configure custom launch commands for specific app_ids here:
    # settings = {
    #   launch = {
    #     "zen-browser" = "zen";
    #     "org.mozilla.firefox" = "firefox";
    #   };
    #   # Apps to ignore when restoring:
    #   ignore = [
    #     "org.wezfurlong.wezterm"
    #   ];
    # };
  };

  environment.systemPackages = [config.services.nirinit.package];
}
