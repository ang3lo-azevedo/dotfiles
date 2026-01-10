{ pkgs, ... }:
{
  # Enable the LACT service for GPU configuration
  services.lact.enable = true;

  # Add the LACT package to the system
  environment.systemPackages = [ pkgs.lact ];
}
