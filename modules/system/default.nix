{
  # Shared NixOS modules applied to all hosts.
  imports = [
    ./networking
    ./binary-cache.nix
    ./configuration.nix
  ];
}
