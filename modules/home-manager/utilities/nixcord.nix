{ inputs, ... }:
{
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];
  programs.nixcord = {
    enable = true;
    equibop.enable = true;
    config = {
      autoUpdate = true;
    };
  };
}
