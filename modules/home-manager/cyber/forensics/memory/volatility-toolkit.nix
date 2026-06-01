{ config, lib, pkgs, ... }:

let
  volatilityToolkit = pkgs.callPackage ../../../../../pkgs/volatility-toolkit/default.nix { };
in
{
  options.cyber.forensics.memory."volatility-toolkit" = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "If true, install vol-analyze and its completions into the user's $PATH via home.packages.";
    };
  };

  config = lib.mkIf config.cyber.forensics.memory."volatility-toolkit".enable {
    home.packages = [ volatilityToolkit ];
  };
}

