{...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader - assumes systemd-boot for EFI
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "proxmox-vm";
  networking.networkmanager.enable = true;

  # QEMU Guest Agent is critical for Proxmox
  services.qemuGuest.enable = true;

  system.stateVersion = "24.05"; # Match this to your initial install version
}
