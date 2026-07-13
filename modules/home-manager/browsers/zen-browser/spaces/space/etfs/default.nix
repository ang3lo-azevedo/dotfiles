let
  lib = import ../../lib.nix;
  spaceConfig = import ../default.nix;
  spaceId = (builtins.head spaceConfig.spaces).id;
in {
  pins = [
    {
      name = "ETFs";
      id = lib.mkId (spaceId + "ETFs");
      workspace = spaceId;
      isGroup = true;
      isFolderCollapsed = false;
      editedTitle = true;
      order = 2;
    }
  ];
}
