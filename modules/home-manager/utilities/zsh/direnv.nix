{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true; # Enable Zsh integration
    nix-direnv.enable = true;    # Enable nix-direnv for better Nix flake support
    # direnv is an extension for your shell. It augments existing shells with a
    # new feature that can load and unload environment variables depending on the
    # current directory.
  };
}
