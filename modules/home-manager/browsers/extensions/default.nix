# Every *.nix file in this directory is auto-imported. To add an extension,
# drop a new file here, no registration in default.nix required.
{lib, ...}: let
  files = builtins.attrNames (builtins.readDir ./.);
  nixFiles = builtins.filter (name: name != "default.nix" && lib.hasSuffix ".nix" name) files;
  importsList = map (name: ./. + "/${name}") nixFiles;
in {
  imports = importsList;
}
