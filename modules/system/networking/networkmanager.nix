{ pkgs, ... }:
{
  # Enable NetworkManager for networking
  networking.networkmanager = {
    enable = true;
    packages = [ pkgs.networkmanager-openvpn ];
  };
}
