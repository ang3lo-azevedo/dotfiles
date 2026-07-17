{pkgs, ...}: let
  sources = pkgs.callPackage ../_sources/generated.nix {};
  version = sources.jackify.version;
  appimage = sources.jackify.src;
in
  pkgs.appimageTools.wrapType2 {
    pname = "jackify";
    inherit version;
    src = appimage;

    extraPkgs = _: [];

    meta = {
      description = "Simplifying Wabbajack modlist installation and configuration on Linux";
      longDescription = ''
        Jackify installs and configures Wabbajack modlists on Linux and Steam Deck,
        handling downloading, Steam shortcut creation, Proton prefix setup, and
        post-install configuration through a GUI and CLI.
      '';
      homepage = "https://github.com/Omni-guides/Jackify";
    };
  }
