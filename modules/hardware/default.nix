{
  imports = [
    ./amdgpu.nix
    ./bluetooth.nix
    ./thunderbolt.nix
    ./samsung-galaxy-book
  ];

  # Enable audio fix for Samsung Galaxy Book
  hardware.samsung-galaxy-book-audio.enable = true;
}