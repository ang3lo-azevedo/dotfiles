{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.helium-browser.homeModules.default
  ];

  programs.helium = {
    enable = true;

    package =
      inputs.helium-browser.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
      (_: {
        preferLocalBuild = true;
      });

    flags = import ../chromium-flags.nix {
      inherit pkgs config lib;
      excludeIds = ["cjpalhdlnbpafiamejdnhcphjbkeiagm"];
    };
  };
}
