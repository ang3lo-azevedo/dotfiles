{ ... }:
{
  imports = [
    ../../modules/system
    ../../modules/system/audio.nix
    ../../modules/system/bluetooth.nix
    ../../modules/system/networking/networkmanager.nix
    ../../modules/system/nerd-fonts.nix
    ../../modules/system/services
  ];

  # Ensure the system knows to open the LUKS container
  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-partlabel/disk-main-luks";
    allowDiscards = true;
  };

  # Required for Btrfs on LVM on LUKS
  boot.initrd.supportedFilesystems = [ "btrfs" ];
  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_blk"
    "virtio_scsi"
    "ata_piix"
    "uhci_hcd"
  ];

  # Enable the Ly display manager
  services.displayManager.ly.enable = true;

  # Enable Plymouth for a nice boot splash screen
  boot.plymouth = {
    enable = true;
  };

  # Make sure systemd is enabled in initrd for plymouth
  boot.initrd.systemd.enable = true;

  # Identify the SSH host key to be used with Agenix
  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # Provision secrets with Agenix
  age.secrets.user_password.file = ../../secrets/user_password.age;
  age.secrets.root_password.file = ../../secrets/root_password.age;
  #age.secrets.wifi-ssid.file = ../../secrets/wifi-ssid.age;
  #age.secrets.wifi-password.file = ../../secrets/wifi-password.age;
}
