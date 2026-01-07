{ pkgs, ... }:
{
  # Add ProtonUp for managing Proton versions
  home.packages = with pkgs; [
    protonup-qt
  ];
}
