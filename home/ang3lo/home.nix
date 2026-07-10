{
  inputs,
  pkgs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
in {
  home = {
    username = "ang3lo";
    homeDirectory = "/home/ang3lo";
    stateVersion = "26.05";
    sessionVariables = {
      EDITOR = "antigravity-ide";
      BROWSER = "zen-browser";
      EXPLORER = "ghostty -e yazi";
      MUSIC_PLAYER = "spotify";
      DISCORD = "equibop";
      YOUTUBE_PLAYER = "grayjay";
    };
  };

  imports = [
    inputs.stylix.homeModules.stylix
    inputs.binaryninja.hmModules.binaryninja
    "${inputs.self}/modules/home-manager"
  ];

  programs.home-manager.enable = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-39.8.10"
        "ventoy-1.1.12"
      ];
    };
    overlays = [
      (import (inputs.self + "/overlays/python-packages.nix"))
      inputs.firefox-addons.overlays.default
      (import (inputs.self + "/overlays/firefox-addons.nix"))
      inputs.nix-vscode-extensions.overlays.default

      (_: prev: {
        angr-management = prev.callPackage (inputs.self + "/pkgs/angr-management/default.nix") {
          src = inputs.angr-management;
        };
        archi = prev.callPackage (inputs.self + "/pkgs/archi/default.nix") {
          inherit inputs;
        };
      })

      # For Antigravity
      inputs.antigravity-nix.overlays.default

      # For IDA Pro
      inputs.ida-pro-overlay.overlays.default

      # For Binary Ninja
      inputs.binaryninja.overlays.default

      # For MemProcFS
      inputs.dmatools.overlays.default

      # Access nixpkgs-xr packages via pkgs.xr instead of globally overriding core libraries
      (_: _: {
        xr = inputs.nixpkgs-xr.packages.${system};
      })

      (_: prev: {
        # For QRookie
        glaumar_repo = inputs.glaumar_repo.packages."${system}";
        # xddxdd's NUR packages (bambu-studio-bin, etc.)
        xddxdd = inputs.xddxdd-nur.packages."${system}";

        trakt-scrobbler = prev.callPackage (inputs.self + "/pkgs/trakt-scrobbler/default.nix") {};
        cursor-id-modifier = prev.callPackage (inputs.self + "/pkgs/cursor-id-modifier/default.nix") {};
        stremio-enhanced = prev.callPackage (inputs.self + "/pkgs/stremio-enhanced/default.nix") {};
        ctfd-parser = prev.callPackage (inputs.self + "/pkgs/ctfd-parser/default.nix") {};
        ese-database-view = prev.callPackage (inputs.self + "/pkgs/ese-database-view/default.nix") {};
        ffmpeg-encoder-plugin-resolve = prev.callPackage (inputs.self + "/pkgs/ffmpeg-encoder-plugin-resolve/default.nix") {};
        libesedb = prev.callPackage (inputs.self + "/pkgs/libesedb/default.nix") {};
        libfsntfs = prev.callPackage (inputs.self + "/pkgs/libfsntfs/default.nix") {};
        sidr = prev.callPackage (inputs.self + "/pkgs/sidr/default.nix") {};
        monkeylauncher = prev.callPackage (inputs.self + "/pkgs/monkeylauncher/default.nix") {};
        linoffice = prev.callPackage (inputs.self + "/pkgs/linoffice/default.nix") {};
      })
    ];
  };
}
