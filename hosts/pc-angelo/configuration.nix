{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system
  ];

  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;

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

  # Enable USB device multiplexing
  services.usbmuxd.enable = true;

  # Identify the SSH host key to be used with Agenix
  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # Provision secrets with Agenix
  age.secrets.user_password.file = ../../secrets/user_password.age;
  age.secrets.root_password.file = ../../secrets/root_password.age;

  age.secrets.nvchecker_keyfile = {
    file = ../../secrets/nvchecker-keyfile.age;
    owner = "ang3lo";
    group = "users";
  };

  age.secrets.nix_access_tokens = {
    file = ../../secrets/nix-access-tokens.age;
  };

  age.secrets.git_config = {
    file = ../../secrets/git_config.age;
    owner = "ang3lo";
    group = "users";
  };

  nix.extraOptions = ''
    !include ${config.age.secrets.nix_access_tokens.path}
  '';
}
