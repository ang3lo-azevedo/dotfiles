{
  pkgs,
  config,
  lib,
  excludeIds ? [],
}: let
  loadExtensionsFlag = import ./chromium-extensions.nix {inherit pkgs config lib excludeIds;};
  insecureOrigins = config.my.browsers.insecureOriginsAsSecure;
in
  [
    "--ozone-platform-hint=auto"
    # Chromium only honours the last --enable-features, so every feature goes here
    "--enable-features=TouchpadOverscrollHistoryNavigation,WebRTCPipeWireCapturer,MiddleClickAutoscroll"
    "--autoplay-policy=document-user-activation-required"
    loadExtensionsFlag
  ]
  ++ lib.optional (insecureOrigins != []) "--unsafely-treat-insecure-origin-as-secure=${lib.concatStringsSep "," insecureOrigins}"
