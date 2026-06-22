{ pkgs, config, lib, ... }:
let
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
in
{
  # Enable NetworkManager for networking
  networking.networkmanager = {
    enable = true;
    plugins = [ pkgs.networkmanager-openvpn ];
  };

  # WiFi configurations specifically for the laptop
  age.secrets.wifi-env = lib.mkIf (config.networking.hostName == "pc-angelo") {
    file = ../../../secrets/wifi-env.age;
  };

  networking.networkmanager.ensureProfiles = lib.mkIf (config.networking.hostName == "pc-angelo") {
    environmentFiles = [
      config.age.secrets.wifi-env.path
    ];
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
