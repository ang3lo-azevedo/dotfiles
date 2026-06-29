{
  pkgs,
  inputs,
  ...
}: let
  dayTemp = "6500";
  nightTemp = "3500";

  tempStateFile = ''"''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/wlsunset-night-temp"'';
  locationCache = ''"$HOME/.cache/wlsunset_location.json"'';

  get-location = pkgs.writeShellApplication {
    name = "get-location";
    runtimeInputs = with pkgs; [curl jq];
    text = builtins.readFile (inputs.self + "/home/ang3lo/.config/wlsunset/get-location.sh");
  };

  wlsunset-auto = pkgs.writeShellScriptBin "wlsunset-auto" ''
    read -r latitude longitude <<< "$(${get-location}/bin/get-location)"
    echo "Starting wlsunset with lat=$latitude lon=$longitude" >&2
    night=$(cat ${tempStateFile} 2>/dev/null || echo ${nightTemp})
    exec ${pkgs.wlsunset}/bin/wlsunset -l $latitude -L $longitude -T ${dayTemp} -t $night
  '';

  wlsunset-set-temp = pkgs.writeShellApplication {
    name = "wlsunset-set-temp";
    runtimeInputs = [pkgs.wlsunset pkgs.jq];
    text = ''
      temp="$1"
      echo "$temp" > ${tempStateFile}

      if [ -f ${locationCache} ]; then
          lat=$(jq -r .lat < ${locationCache})
          lon=$(jq -r .lon < ${locationCache})
      else
          lat=38.7223
          lon=-9.1393
      fi

      pkill wlsunset 2>/dev/null || true
      wlsunset -l "$lat" -L "$lon" -T ${dayTemp} -t "$temp" &
    '';
  };

  wlsunset-get-temp = pkgs.writeShellScriptBin "wlsunset-get-temp" ''
    cat ${tempStateFile} 2>/dev/null || echo ${nightTemp}
  '';
in {
  services.wlsunset.enable = false;

  home.packages = [wlsunset-set-temp wlsunset-get-temp];

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
