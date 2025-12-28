{ inputs, pkgs, ... }:
{
  # Enable Steam at the system level
  #programs.steam = {
    #enable = true;

    # Add the CachyOS Proton
    # extraCompatPackages = [
    #   inputs.nix-proton-cachyos.packages.${pkgs.system}.proton-cachyos
    # ];
  #};
}
