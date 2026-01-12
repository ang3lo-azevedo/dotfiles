{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system
  ];

  environment.systemPackages = with pkgs; [
    wineWow64Packages.waylandFull
    winetricks
  ];

  # Ensure the system knows to open the LUKS container
  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-partlabel/disk-main-luks";
    allowDiscards = true;
  };

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
