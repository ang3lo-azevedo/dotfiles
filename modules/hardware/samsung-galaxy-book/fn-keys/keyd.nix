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

  # Opens this nix-config workspace in VS Code (or VSCodium / xdg-open fallback)
  open-nix-config-pkg = pkgs.writeShellApplication {
    name = "open-nix-config";
    runtimeInputs = [ pkgs.coreutils pkgs.xdg-utils ];
    text = builtins.readFile ./scripts/open-nix-config.sh;
  };
in
{
  environment.systemPackages = [ 
    touchpadtoggle-pkg
    kbdillumtoggle-pkg
    open-nix-config-pkg
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

            # Open nix-config in VS Code
            #"f1" = "command(open-nix-config)";

            #left meta + p

            # Touchpad toggle (Fn+F5) -> (left meta + f21)
            #"f5" = "command(touchpadtoggle)";

            # Keyboard backlight toggle (Fn+F9)
            #"kbdillumtoggle" = "command(cycle-kbd-backlight)";
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
