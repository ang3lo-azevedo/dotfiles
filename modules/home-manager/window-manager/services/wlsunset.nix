{pkgs, ...}: let
  # Color temperature values in Kelvin
  dayTemp = "6500"; # Daylight neutral
  nightTemp = "3500"; # Warm evening

  get-location = pkgs.writeShellApplication {
    name = "get-location";
    runtimeInputs = with pkgs; [curl jq];
    text = builtins.readFile ../../../../home/ang3lo/.config/wlsunset/get-location.sh;
  };

  wlsunset-auto = pkgs.writeShellScriptBin "wlsunset-auto" ''
    read -r latitude longitude <<< "$(${get-location}/bin/get-location)"
    echo "Starting wlsunset with lat=$latitude lon=$longitude" >&2
    exec ${pkgs.wlsunset}/bin/wlsunset -l $latitude -L $longitude -T ${dayTemp} -t ${nightTemp}
  '';
in {
  # Disable the standard module to avoid static location requirement
  services.wlsunset.enable = false;

  systemd.user.services.wlsunset = {
    Unit = {
      Description = "Day/night gamma adjustments for Wayland (auto-location)";
      After = ["graphical-session.target" "network-online.target"];
      Wants = ["network-online.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${wlsunset-auto}/bin/wlsunset-auto";
      Restart = "on-failure";
      RestartSec = 5;
      StandardOutput = "journal";
      StandardError = "journal";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
