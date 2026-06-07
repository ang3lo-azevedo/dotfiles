{ lib, profileName, ... }:

let
  # Get all .nix files in the current directory
  files = builtins.attrNames (builtins.readDir ./.);
  # Filter out default.nix and keep only .nix files
  nixFiles = builtins.filter (name: name != "default.nix" && lib.hasSuffix ".nix" name) files;
  # Create paths for imports
  importsList = map (name: ./. + "/${name}") nixFiles;
in
{
  imports = importsList;

  programs.zen-browser.profiles.${profileName}.sine = {
    enable = true;
    mods = [
      "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better Find Bar
      "f7c71d9a-bce2-420f-ae44-a64bd92975ab" # Better Unloaded Tabs
      "quick-tabs"
    ];
  };
}
