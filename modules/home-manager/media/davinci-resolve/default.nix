{ pkgs, ... }:
let
  cfgDir = /. + "/home/ang3lo/nix-config/pkgs/th3m1ghtyduck-nur/pkgs/davinci-resolve-personal/config";
  hasCfg = builtins.pathExists cfgDir;
in {
  home.packages = [
    pkgs.davinci-resolve-personal
  ];

  home.file = if hasCfg then (import cfgDir).homeFiles else {};
}
