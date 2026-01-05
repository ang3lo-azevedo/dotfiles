let
  lib = import ../lib.nix;
in
{
  spaces = [
    {
      name = "University";
      id = lib.mkId "University";
      icon = "🎓";
    }
  ];
}