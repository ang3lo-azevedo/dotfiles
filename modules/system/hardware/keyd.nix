{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.cycle-kbd-backlight ];

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
