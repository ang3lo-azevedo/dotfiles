let
  lib = import ../lib.nix;
in
{
  spaces = [
    {
      name = "Space";
      id = lib.mkId "Space";
    }
  ];
}