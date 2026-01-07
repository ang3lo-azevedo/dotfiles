{
  imports = [
    ./steam.nix
  ];

  # Enable GameMode for performance optimization
  programs.gamemode.enable = true;
}