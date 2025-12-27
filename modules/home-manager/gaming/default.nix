{ ... }:
{
  # Gaming related configurations
  # VR support imported from a separate file
  imports = [
    ./vr.nix
  ];

  # Enable Steam
  programs.steam = {
    enable = true;

    # Add the CachyOS Proton
    extraCompatPackages = [
      inputs.nix-proton-cachyos.packages.${system}.proton-cachyos
    ];
  };

  home.packages = with pkgs; [
    lutris
  ];
}
