{ inputs, ... }:
{
  # Home Manager modules organized by category
  # Import individual categories as needed
  imports = [
    ./browsers
    ./development.nix
    ./entertainment.nix
    ./gaming
    ./media
    ./utilities.nix
  ];
}
