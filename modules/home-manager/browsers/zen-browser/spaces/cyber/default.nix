let
  lib = import ../lib.nix;
in {
  spaces = [
    {
      name = "Cyber";
      id = lib.mkId "Cyber";
      icon = "chrome://browser/skin/zen-icons/selectable/bug.svg";
      # theme = lib.blackTheme;
      container = 6;
    }
  ];
}
