{ ... }:
{
  # Gaming related configurations
  # VR support imported from a separate file
  imports = [
    ./vr.nix
  ];

  programs.steam = {
    enable = true;
    extraCompatPackages = [
      inputs.nix-proton-cachyos.packages.${system}.proton-cachyos
    ];
  };

  home.packages = with pkgs; [
    lutris
  ];
}
