{ pkgs, ... }:
{
  # Enable NetworkManager for networking
  networking.networkmanager = {
    enable = true;
    plugins = [ pkgs.networkmanager-openvpn ];
  };
}
