let
  lib = import ../../lib.nix;
  spaceConfig = import ../default.nix;
  spaceId = (builtins.head spaceConfig.spaces).id;
in {
  pins = [
    {
      name = "GitHub Stars";
      id = lib.mkId (spaceId + "GitHub Stars");
      workspace = spaceId;
      isGroup = true;
      isFolderCollapsed = false;
      editedTitle = true;
      folderIcon = "chrome://browser/skin/zen-icons/selectable/star-1.svg";
      order = 7;
    }
  ];
}
