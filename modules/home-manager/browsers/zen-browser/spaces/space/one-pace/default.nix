{lib}: let
  spaceId = lib.mkId "Space";
in {
  pins = [
    {
      name = "One Pace";
      id = lib.mkId (spaceId + "One Pace");
      workspace = spaceId;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
      folderIcon = "chrome://browser/skin/zen-icons/selectable/flag.svg";
      order = 1;
    }
  ];
}
