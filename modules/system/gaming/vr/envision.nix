{ pkgs, ... }:
{
  programs.envision = {
    enable = true;
  };

  # TODO: Fix envision

  environment.systemPackages = with pkgs; [
    cairo
    libcap 
    librsvg
  ];
}