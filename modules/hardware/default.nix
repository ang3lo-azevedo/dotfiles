{
  imports = [
    ./amdgpu.nix
    ./bluetooth.nix
    ./fingerprint.nix
    ./keyd.nix
    ./samsung-galaxy-book-audio.nix
    ./thunderbolt.nix
  ];

  # Enable audio fix for Samsung Galaxy Book
  hardware.samsung-galaxy-book-audio.enable = true;
}