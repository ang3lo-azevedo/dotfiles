{ inputs, ... }:
{
  # Home Manager modules organized by category
  # Import individual categories as needed
  imports = [
    ./browsers
    ./dev
    ./gaming
    ./media
    ./utilities.nix
  ];
}
