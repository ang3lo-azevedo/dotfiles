{ pkgs, ... }:
{
  home.packages = with pkgs; [
    stardust-xr-server
    stardust-xr-atmosphere
    stardust-xr-protostar
  ];
}
