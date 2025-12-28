{ config, pkgs, ... }:
{
  imports = [
    ./disko.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/virtualisation.nix
  ];

  # Ensure the system knows to open the LUKS container
  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-partlabel/disk-main-luks";
    allowDiscards = true;
  };

  # Required for Btrfs on LVM on LUKS
  boot.initrd.supportedFilesystems = [ "btrfs" ];
  boot.initrd.availableKernelModules = [ "virtio_pci" "virtio_blk" "virtio_scsi" "ata_piix" "uhci_hcd" ];

  networking.hostName = "pc-angelo"; # Define your hostname.
  
  # Enable the Ly display manager
  services.displayManager.ly.enable = true;

  # Enable Plymouth for a nice boot splash screen
  boot.plymouth = {
    enable = true;
  };

  # Make sure systemd is enabled in initrd for plymouth
  boot.initrd.systemd.enable = true;

  # Provision secrets with sops-nix:
  sops.defaultSopsFile = ../../secrets/secrets.yaml;

  sops.secrets = {
    user_password = {
      neededForUsers = true;
    };
    root_password = {
      neededForUsers = true;
    };
  };
}
