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
            # The Copilot key sends meta+shift+f23 as a momentary tap, so it cannot be
            # held as a modifier. Use f23 as a one-shot leader: tap Copilot, then a
            # letter, to fire an action (Copilot then U = system update).
            "f23" = "oneshot(copilot)";
          };
          # Leader layer, active for the single keypress after the Copilot key. Each
          # letter maps to a spare F-key that niri binds to a command. Note niri binds
          # by xkb keysym, and the evdev keymap gives these F-keys XF86 symbols rather
          # than F13.. names (f13 -> XF86Tools, f14 -> XF86Launch5, f15 -> XF86Launch6),
          # so the niri side must name that keysym, not "F13".
          copilot = {
            "u" = "f13";
            "n" = "f14";
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
