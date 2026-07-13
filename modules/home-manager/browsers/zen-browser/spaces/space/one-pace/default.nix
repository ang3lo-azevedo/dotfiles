let
  lib = import ../../lib.nix;
  spaceConfig = import ../default.nix;
  spaceId = (builtins.head spaceConfig.spaces).id;
in {
  pins = [
    {
      name = "One Pace";
      id = lib.mkId (spaceId + "One Pace");
      workspace = spaceId;
      isGroup = true;
      isFolderCollapsed = false;
      editedTitle = true;
      folderIcon = "chrome://browser/skin/zen-icons/selectable/flag.svg";
      order = 1;
    }
  ];
}
