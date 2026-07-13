{lib}: let
  spaceId = lib.mkId "Space";
in {
  pins = [
    {
      name = "Debrid";
      id = lib.mkId (spaceId + "Debrid");
      workspace = spaceId;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
      folderIcon = "chrome://browser/skin/zen-icons/selectable/cloud.svg";
      order = 3;
    }
  ];
}
