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

    flags = let
      loadExtensionsFlag = import ../chromium-extensions.nix {
        inherit pkgs config lib;
        excludeIds = ["cjpalhdlnbpafiamejdnhcphjbkeiagm"];
      };
    in [
      "--ozone-platform-hint=auto"
      "--enable-features=TouchpadOverscrollHistoryNavigation,WebRTCPipeWireCapturer"
      loadExtensionsFlag
    ];
  };
}
