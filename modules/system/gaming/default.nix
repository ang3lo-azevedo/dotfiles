{
  imports = [
    ./steam.nix
    ./vr.nix
  ];

  # Enable GameMode for performance optimization
  programs.gamemode.enable = true;
}