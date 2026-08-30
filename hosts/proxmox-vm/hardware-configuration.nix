# This is a stub hardware-configuration.nix.
# When you install NixOS on the Proxmox VM, overwrite this file with the output of `nixos-generate-config --show-hardware-config`
{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd.availableKernelModules = ["uhci_hcd" "ehci_pci" "ahci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"];
    initrd.kernelModules = [];
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };

  # Note: You MUST update the fileSystems section with your actual disk UUIDs
  # after running nixos-generate-config.
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-UUID";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-UUID";
    fsType = "vfat";
  };

  swapDevices = [];
  networking.useDHCP = lib.mkDefault true;
}
