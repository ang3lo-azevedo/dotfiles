{pkgs, ...}: let
  kbdillumtoggle-pkg = pkgs.writeShellApplication {
    name = "cycle-kbd-backlight";
    runtimeInputs = [pkgs.brightnessctl];
    text = builtins.readFile ./scripts/kbdillumtoggle.sh;
  };
in {
  environment.systemPackages = [
    kbdillumtoggle-pkg
    pkgs.keyd
  ];

  services.keyd = {
    enable = true;
    keyboards = {
      "samsung-galaxybook" = {
        ids = ["0001:0001" "0000:0000"];
        settings = {
          main = {
            # Samsung F1 Fn-function ('?'/help) emits 'help'; remap to f1 for niri bind.
            "help" = "f1";
            # The laptop defaults to media keys: physical F9 emits 'kbdillumtoggle'
            # and Fn+F9 emits 'f9'. Swap so F9 = F9 and Fn+F9 cycles backlight.
            "kbdillumtoggle" = "f9";
            "f9" = "command(cycle-kbd-backlight)";
          };
        };
      };
    };
  };

  # Grant the input group write access to the touchpad inhibit sysfs file
  # so ~/.config/niri/scripts/touchpad-toggle.sh can disable it without root.
  services.udev.extraRules = ''
    SUBSYSTEM=="input", ATTRS{name}=="ZNT0001:00 14E5:E760 Touchpad", ACTION=="add", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys%p/inhibited"
  '';

  # Makes palm rejection work with keyd's virtual keyboard
  # https://github.com/rvaiya/keyd/issues/723
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';
}
