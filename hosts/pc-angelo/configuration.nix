{
  pkgs,
  config,
  ...
}: let
  userSecretConfig = {
    owner = "ang3lo";
    group = "users";
    mode = "0440";
  };
in {
  imports = [
    ./hardware-configuration.nix
    ../../modules/system
  ];

  boot = {
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;

    # Ensure the system knows to open the LUKS container
    initrd.luks.devices."cryptroot" = {
      device = "/dev/disk/by-partlabel/disk-main-luks";
      allowDiscards = true;
    };

    # Enable Plymouth for a nice boot splash screen
    plymouth = {
      enable = true;
      extraConfig = ''
        DeviceScale=2
      '';
    };

    # Make sure systemd is enabled in initrd for plymouth
    initrd.systemd.enable = true;
  };

  # Enable USB device multiplexing
  services.usbmuxd.enable = true;

  # Identify the SSH host key to be used with Agenix
  age = {
    # Identify the SSH host key to be used with Agenix
    identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];

    # Provision secrets with Agenix
    secrets = {
      user_password.file = ../../secrets/user_password.age;
      root_password.file = ../../secrets/root_password.age;

      nvchecker_keyfile =
        userSecretConfig
        // {
          file = ../../secrets/nvchecker-keyfile.age;
        };

      nix_access_tokens =
        userSecretConfig
        // {
          file = ../../secrets/nix-access-tokens.age;
        };

      git_config =
        userSecretConfig
        // {
          file = ../../secrets/git_config.age;
        };

      # Backup secrets
      rclone-conf =
        userSecretConfig
        // {
          file = ../../secrets/rclone.conf.age;
        };
      restic_password =
        userSecretConfig
        // {
          file = ../../secrets/restic_password.age;
        };
      nextcloud_caldav =
        userSecretConfig
        // {
          file = ../../secrets/nextcloud_caldav.age;
        };
    };
  };

  nix.extraOptions = ''
    !include ${config.age.secrets.nix_access_tokens.path}
  '';
}
