{
  lib,
  pkgs,
  config,
  ...
}: {
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  # Upstream ships the bluetooth backend disabled by default (KDE bugs 513536, 520578).
  # The config file is also written by the daemon (name, keys), so only this key is patched.
  home.activation.kdeconnectBluetooth = lib.hm.dag.entryAfter ["writeBoundary"] ''
    configDir="${config.xdg.configHome}/kdeconnect"
    $DRY_RUN_CMD mkdir -p "$configDir"
    $DRY_RUN_CMD ${lib.getExe pkgs.crudini} --ini-options=nospace \
      --set "$configDir/config" General disabled_providers_v2 loopback
  '';
}
