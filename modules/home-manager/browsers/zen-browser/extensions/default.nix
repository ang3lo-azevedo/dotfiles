{ lib, ... }:

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
}
