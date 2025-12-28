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
  
  services.displayManager.ly.enable = true;

  boot.plymouth = {
    enable = true;
    theme = "spinner";
  };

  boot.initrd.systemd.enable = true;
}
