{ config, pkgs, lib, ... }:

let
  evolve = pkgs.callPackage ../../../../../pkgs/evolve {};
in {
  options.cyber.forensics.memory.evolve = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "If true, install evolve into the user's $PATH via home.packages.";
    };
  };

  config = lib.mkIf config.cyber.forensics.memory.evolve.enable {
    home.packages = [ evolve ];
  };
}

