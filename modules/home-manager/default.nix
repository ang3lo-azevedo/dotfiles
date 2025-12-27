{ inputs, ... }:
{
  # Home Manager modules organized by category
  # Import individual categories as needed
  imports = [
    ./browsers.nix
    ./development.nix
    ./entertainment.nix
    ./gaming
    ./media.nix
    ./utilities.nix
  ];
}
