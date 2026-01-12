{ inputs, trakt-scrobbler-src, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  nixpkgs = inputs.nixpkgs.legacyPackages.${system};
  nixpkgs-master = inputs.nixpkgs-master.legacyPackages.${system};
  nixpkgs-xr = inputs.nixpkgs-xr.legacyPackages.${system};
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
    (final: prev: {
      trakt-scrobbler = prev.callPackage ../../pkgs/trakt-scrobbler/default.nix { src = trakt-scrobbler-src; };
      cursor-id-modifier = prev.callPackage ../../pkgs/cursor-id-modifier/default.nix { };

      # Make Wivrn come from nixpkgs-unstable to not have to deal with https://github.com/nix-community/nixpkgs-xr/issues/569 and to fix flicker issues
      wivrn = nixpkgs.wivrn;

      # Make Stardust XR come from nixpkgs-xr
      stardust-xr = nixpkgs-xr.stardust-xr;

      # Make WayVR temporarily come from master branch
      wayvr = nixpkgs-master.wayvr;
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
