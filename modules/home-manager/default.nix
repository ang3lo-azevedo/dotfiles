{ ... }:
{
  # Home Manager modules organized by category
  # Import individual categories as needed
  imports = [
    ./browsers.nix
    ./development.nix
    ./entertainment.nix
    ./gaming.nix
    ./media.nix
    ./utilities.nix
  ];
}
