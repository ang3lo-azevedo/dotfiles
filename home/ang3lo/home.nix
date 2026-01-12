{ inputs, trakt-scrobbler-src, ... }:
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
      wayvr = inputs.scrumplex-nixpkgs.legacyPackages.${prev.system}.wayvr;
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
