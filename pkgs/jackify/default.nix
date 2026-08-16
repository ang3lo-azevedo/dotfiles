{pkgs, ...}: let
  sources = pkgs.callPackage ../_sources/generated.nix {};
  version = sources.jackify.version;
  appimage = sources.jackify.src;
in
  pkgs.appimageTools.wrapType2 {
    pname = "jackify";
    inherit version;
    src = appimage;

    extraPkgs = pkgs: with pkgs; [zstd];

    extraInstallCommands = ''
      mkdir -p $out/share/applications
      cp ${pkgs.makeDesktopItem {
        name = "jackify";
        exec = "jackify %u";
        icon = "com.jackify.app";
        desktopName = "Jackify";
        comment = "Wabbajack modlist manager for Linux";
        categories = ["Game" "Utility"];
        mimeTypes = ["x-scheme-handler/jackify" "x-scheme-handler/nxm"];
      }}/share/applications/* $out/share/applications/
    '';

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
