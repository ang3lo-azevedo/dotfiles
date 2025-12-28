{ ... }:
{
  imports = [
    # IMPORTANT: Use the VM's own hardware configuration
    ./hardware-configuration.nix

    # Import the same software modules as pc-angelo
    ../../modules/nixos/common.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/virtualisation.nix
  ];

  # Use the same hostname and display manager as pc-angelo
  networking.hostName = "pc-angelo";
  services.displayManager.ly.enable = true;
}