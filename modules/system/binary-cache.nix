{
  # These are the global system-level binary caches.
  # They are applied to /etc/nix/nix.conf and take effect AFTER the system is built.
  # This ensures the Nix daemon automatically uses these caches for any future
  # standard Nix commands run by any user.
  #
  # IMPORTANT: Keep this list in sync with `nixConfig` in `flake.nix`!
  nix.settings = {
    extra-substituters = [
      # Personal cache, custom packages and full system closure
      "https://ang3lo.cachix.org"
      # Official cache for community flakes (home-manager, disko, impermanence, stylix)
      "https://nix-community.cachix.org"
      # Lantian's cache (custom networking tools, CachyOS kernels)
      "https://attic.xuyh0120.win/lantian"
      # Garnix CI cache (used by flakes like zen-browser and dmatools)
      "https://cache.garnix.io"
      # Proxmox NixOS cache (pre-compiled guest agents and VM tools)
      "https://cache.saumon.network/proxmox-nixos"
      # Berberman cache (apple-emoji, fcitx5 themes, nvfetcher)
      "https://berberman.cachix.org"
      # Cache for nix-gaming packages (wine, lutris, etc.)
      "https://nix-gaming.cachix.org"
    ];
    extra-trusted-public-keys = [
      "ang3lo.cachix.org-1:RckESjXE0fJr+FTfC4akKPi3+EBgpyPQLmZU23N4y3E="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "proxmox-nixos:D9RYSWpQQC/msZUWphOY2I5RLH5Dd6yQcaHIuug7dWM="
      "berberman.cachix.org-1:UHGhodNXVruGzWrwJ12B1grPK/6Qnrx2c3TjKueQPds="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };
}
