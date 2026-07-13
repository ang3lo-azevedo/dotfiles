let
  lib = import ../../lib.nix;
  spaceConfig = import ../default.nix;
  spaceId = (builtins.head spaceConfig.spaces).id;
in {
  pins = [
    {
      name = "Debrid";
      id = lib.mkId (spaceId + "Debrid");
      workspace = spaceId;
      isGroup = true;
      isFolderCollapsed = false;
      editedTitle = true;
      folderIcon = "chrome://browser/skin/zen-icons/selectable/cloud.svg";
      order = 3;
    }
  ];
}
