let
  lib = import ../../lib.nix;
  spaceConfig = import ../default.nix;
  spaceId = (builtins.head spaceConfig.spaces).id;
in {
  pins = [
    {
      name = "Tools";
      id = lib.mkId (spaceId + "Tools");
      workspace = spaceId;
      isGroup = true;
      isFolderCollapsed = false;
      editedTitle = true;
      folderIcon = "chrome://browser/skin/zen-icons/selectable/build.svg";
      order = 2;
    }
  ];
}
