{pkgs, ...}: {
  # Jackify is currently unavailable because the upstream Mistyttm/nixpkgs-extra repo was deleted
  home.packages = with pkgs; [
    # jackify
  ];
}
