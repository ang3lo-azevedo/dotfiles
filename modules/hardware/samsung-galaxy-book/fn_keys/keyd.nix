{ pkgs, ... }:

let
  touchpadtoggle-pkg = pkgs.writeShellApplication {
    name = "toggle-touchpad";
    runtimeInputs = [ pkgs.libinput pkgs.xorg.xinput ];
    text = builtins.readFile ./scripts/touchpadtoggle.sh;
  };

  kbdillumtoggle-pkg = pkgs.writeShellApplication {
    name = "cycle-kbd-backlight";
    runtimeInputs = [ pkgs.brightnessctl ];
    text = builtins.readFile ./kbdillumtoggle/kbdillumtoggle.sh;
  };
in
{
  environment.systemPackages = [ 
    touchpadtoggle-pkg
    kbdillumtoggle-pkg
  ];

  services.keyd = {
    enable = true;
    keyboards = {
      "samsung-galaxybook" = {
        ids = [ "*" ];
        settings = {
          main = {
            # Touchpad toggle (Fn+F5)
            "f5" = "overload(fn, command(touchpadtoggle))";

            # Keyboard backlight toggle (Fn+F9)
            "kbdillumtoggle" = "overload(fn, command(kbdillumtoggle))";
          };
        };
      };
    };
  };
}
