{ pkgs, ... }:

let
  cycle-kbd-backlight-pkg = pkgs.writeShellApplication {
    name = "cycle-kbd-backlight";
    runtimeInputs = [ pkgs.brightnessctl ];
    text = ''
      DEVICE='samsung-galaxybook::kbd_backlight'
      CURRENT=$(brightnessctl --device="$DEVICE" g)
      MAX=$(brightnessctl --device="$DEVICE" m)
      if [ "$CURRENT" -ge "$MAX" ]; then
        brightnessctl --device="$DEVICE" set 0
      else
        brightnessctl --device="$DEVICE" set +1
      fi
    '';
  };
in
{
  environment.systemPackages = [ cycle-kbd-backlight-pkg ];

  # TODO: Add all the other function keys
  services.keyd = {
    enable = true;
    keyboards = {
      "samsung-galaxybook" = {
        ids = [ "*" ];
        settings = {
          main = {
            "kbdillumtoggle" = "command(cycle-kbd-backlight)";
          };
        };
      };
    };
  };
}
