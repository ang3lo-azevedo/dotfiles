{ ... }:
{
  imports = [
    # IMPORTANT: Use the VM's own hardware configuration
    /etc/nixos/hardware-configuration.nix

    # Import the same software modules as pc-angelo
    ../../modules/nixos/common.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/virtualisation.nix
  ];

  # Use the same hostname and display manager as pc-angelo
  networking.hostName = "pc-angelo";
  services.displayManager.ly.enable = true;

  # Override the bootloader from common.nix
  # Use GRUB for this BIOS-style VM instead of systemd-boot (UEFI)
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda"; # Or "/dev/sda" depending on your VM setup
    useOSProber = true;
  };
}