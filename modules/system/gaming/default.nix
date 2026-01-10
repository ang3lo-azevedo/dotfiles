{
  imports = [
    ./steam.nix
    ./vr
  ];

  # Enable GameMode for performance optimization
  programs.gamemode.enable = true;
}