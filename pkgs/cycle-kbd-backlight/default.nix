{ writeShellApplication, brightnessctl }:

writeShellApplication {
  name = "cycle-kbd-backlight";
  runtimeInputs = [ brightnessctl ];
  text = ''
    ${brightnessctl}/bin/brightnessctl --device='samsung-galaxybook::kbd_backlight' set +1
  '';
}
