{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    # nix-direnv replaces the built-in use_nix/use_flake with a faster implementation
    # that caches the devshell and avoids re-evaluating the flake on every shell entry
    nix-direnv.enable = true;
  };
}
