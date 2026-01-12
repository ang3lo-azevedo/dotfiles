{ config, lib, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
      ../../modules/hardware
    ];

  # Bootloader kernel modules
  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_blk"
    "virtio_scsi"
    "ata_piix"
    "uhci_hcd"
  ];
  
  # Enable Xen PV drivers in the initrd
  boot.initrd.kernelModules = [ "xe" ];

  # Add kernel parameter to force Xen to probe all devices
  boot.kernelParams = [ "xe.force_probe=*" ];

  # Required for Btrfs on LVM on LUKS
  # Also add NTFS support
  boot.initrd.supportedFilesystems = [ "btrfs" "ntfs3" ];

  # Enable graphics drivers for Intel integrated GPU
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Basic networking config
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
