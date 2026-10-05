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

    flags = import ../chromium-flags.nix {
      inherit pkgs config lib;
      excludeIds = ["cjpalhdlnbpafiamejdnhcphjbkeiagm"];
    };
  };
}
