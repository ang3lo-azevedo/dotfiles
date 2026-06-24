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

  mkHomeNetwork = envPrefix: {
    connection = {
      id = "$WIFI_${envPrefix}_SSID";
      type = "wifi";
    };
    wifi = {
      mode = "infrastructure";
      ssid = "$WIFI_${envPrefix}_SSID";
    };
    wifi-security = {
      auth-alg = "open";
      key-mgmt = "wpa-psk";
      psk = "$WIFI_HOME_PSK";
    };
    ipv4.method = "auto";
    ipv6 = {
      addr-gen-mode = "stable-privacy";
      method = "auto";
    };
  };
in {
  imports = [
    ./hardware-configuration.nix
    ../../modules/system
    ../../modules/system/pc.nix
  ];

  time.hardwareClockInLocalTime = true;

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

  age = {
    identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];

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

      # WiFi credentials
      wifi-env = {
        file = ../../secrets/wifi-env.age;
      };
    };
  };

  nix.extraOptions = ''
    !include ${config.age.secrets.nix_access_tokens.path}
  '';

  # WiFi profiles for the laptop
  networking.networkmanager.ensureProfiles = {
    environmentFiles = [config.age.secrets.wifi-env.path];
    profiles = {
      "home" = mkHomeNetwork "HOME";
      "home-5g" = mkHomeNetwork "HOME_5G";
      "home-6g" = mkHomeNetwork "HOME_6G";

      "university" = {
        connection = {
          id = "$WIFI_UNI_SSID";
          type = "wifi";
        };
        wifi = {
          mode = "infrastructure";
          ssid = "$WIFI_UNI_SSID";
        };
        wifi-security = {
          key-mgmt = "wpa-eap";
        };
        "802-1x" = {
          anonymous-identity = "$WIFI_UNI_ANON_IDENTITY";
          ca-cert = "$WIFI_UNI_CA_CERT";
          eap = "peap;";
          identity = "$WIFI_UNI_IDENTITY";
          password = "$WIFI_UNI_PASSWORD";
          phase2-auth = "mschapv2";
        };
        ipv4.method = "auto";
        ipv6 = {
          addr-gen-mode = "stable-privacy";
          method = "auto";
        };
      };
    };
  };
}
