{ inputs, trakt-scrobbler-src, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  home.username = "ang3lo";
  home.homeDirectory = "/home/ang3lo";

  imports = [
    inputs.stylix.homeModules.stylix
    inputs.binaryninja.hmModules.binaryninja
    ../../modules/home-manager
  ];

  programs.home-manager.enable = true;

  nixpkgs.overlays = [
    (import ../../overlays/python-packages.nix)
    inputs.firefox-addons.overlays.default
    inputs.nix-vscode-extensions.overlays.default

    (final: prev: {
      angr-management = prev.callPackage ../../pkgs/angr-management/default.nix {
        src = inputs.angr-management;
      };
      archi = prev.callPackage ../../pkgs/archi/default.nix {
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
    (final: prev: {
      xr = inputs.nixpkgs-xr.packages.${system};
    })

    (final: prev: {
      # For QRookie
      glaumar_repo = inputs.glaumar_repo.packages."${system}";

      trakt-scrobbler = prev.callPackage ../../pkgs/trakt-scrobbler/default.nix { };
      cursor-id-modifier = prev.callPackage ../../pkgs/cursor-id-modifier/default.nix { };
      stremio-enhanced = prev.callPackage ../../pkgs/stremio-enhanced/default.nix { };
      ctfd-parser = prev.callPackage ../../pkgs/ctfd-parser/default.nix { };
      ese-database-view = prev.callPackage ../../pkgs/ese-database-view/default.nix { };
      libesedb = prev.callPackage ../../pkgs/libesedb/default.nix { };
      libfsntfs = prev.callPackage ../../pkgs/libfsntfs/default.nix { };
      sidr = prev.callPackage ../../pkgs/sidr/default.nix { };
    })
  ];

  nixpkgs.config.allowUnfree = true;

  # TODO: remove these
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
    "ventoy-gtk3-1.1.12"
  ];

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state
  # changes in each release.
  home.stateVersion = "26.05";
}
