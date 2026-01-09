{ ... }:
let
  sharedSettings = import ../shared-settings.nix;
in
{
  # Cursor stores its settings in ~/.config/Cursor/User/settings.json
  # Since there's no programs.cursor module, we manage it via xdg.configFile
  xdg.configFile."Cursor/User/settings.json".text = builtins.toJSON sharedSettings.sharedSettings;
}

