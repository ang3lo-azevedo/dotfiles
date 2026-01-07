{
  imports = [
    ./steam.nix
    ./lutris.nix
    ./vr.nix
  ];

  # Enable accelerated graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Enable GameMode for performance optimization
  programs.gamemode.enable = true;
}
