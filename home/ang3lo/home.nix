{ inputs, trakt-scrobbler-src, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  home.username = "ang3lo";
  home.homeDirectory = "/home/ang3lo";

  imports = [
    inputs.stylix.homeModules.stylix
    ../../modules/home-manager
  ];

  programs.home-manager.enable = true;

  nixpkgs.overlays = [ 
    inputs.firefox-addons.overlays.default
    inputs.nix-vscode-extensions.overlays.default

    # For IDA Pro
    inputs.ida-pro-overlay.overlays.default

    # For Jackify
    inputs.nixpkgs-extra.overlays.default

    # nixpkgs-xr overlay without wivrn
    (final: prev: builtins.removeAttrs (inputs.nixpkgs-xr.overlays.default final prev) [ "wivrn" ])

    (final: prev: {
      # For QRookie
      glaumar_repo = inputs.glaumar_repo.packages."${system}";

      trakt-scrobbler = prev.callPackage ../../pkgs/trakt-scrobbler/default.nix { src = trakt-scrobbler-src; };
      cursor-id-modifier = prev.callPackage ../../pkgs/cursor-id-modifier/default.nix { };
    })
  ];

  nixpkgs.config.allowUnfree = true;

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";
}
