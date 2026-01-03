{ pkgs, ... }:
let
  wlsunset-auto = pkgs.writeShellScriptBin "wlsunset-auto" ''
    RETRIES=30
    counter=0
    while true; do
        CONTENT=$(${pkgs.curl}/bin/curl -s http://ip-api.com/json/)
        if [ $? -eq 0 ]; then
            break
        fi
        counter=$((counter + 1))
        if [ $counter -eq $RETRIES ]; then
            echo "Unable to connect to ip-api."
            exit 1
        fi
        sleep 2
    done
    longitude=$(echo $CONTENT | ${pkgs.jq}/bin/jq .lon)
    latitude=$(echo $CONTENT | ${pkgs.jq}/bin/jq .lat)
    exec ${pkgs.wlsunset}/bin/wlsunset -l $latitude -L $longitude
  '';
in
{
  # Disable the standard module to avoid static location requirement
  services.wlsunset.enable = false;

  systemd.user.services.wlsunset = {
    Unit = {
      Description = "Day/night gamma adjustments for Wayland (auto-location)";
      After = [ "graphical-session.target" "network-online.target" ];
      Wants = [ "network-online.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${wlsunset-auto}/bin/wlsunset-auto";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
