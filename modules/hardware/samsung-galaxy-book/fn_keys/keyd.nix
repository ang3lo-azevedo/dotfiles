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
    text = builtins.readFile ./scripts/kbdillumtoggle.sh;
  };
in
{
  environment.systemPackages = [ 
    touchpadtoggle-pkg
    kbdillumtoggle-pkg
    pkgs.keyd
  ];

  services.keyd = {
    enable = true;
    keyboards = {
      "samsung-galaxybook" = {
        ids = [ "0001:0001" ];
        settings = {
          main = {
            # TODO: Add the missing keys

            # Touchpad toggle (Fn+F5)
            "f5" = "overload(fn, command(touchpadtoggle))";

            # Keyboard backlight toggle (Fn+F9)
            "kbdillumtoggle" = "overload(fn, command(kbdillumtoggle))";
          };
        };
      };
    };
  };

  # Optional, but makes sure that when you type the make palm rejection work with keyd
  # https://github.com/rvaiya/keyd/issues/723
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';
}
