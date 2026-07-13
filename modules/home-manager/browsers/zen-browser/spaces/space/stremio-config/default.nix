{lib}: let
  spaceId = lib.mkId "Space";
in {
  pins = [
    {
      name = "Stremio Config";
      id = lib.mkId (spaceId + "Stremio Config");
      workspace = spaceId;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
      folderIcon = "chrome://browser/skin/zen-icons/selectable/rocket.svg";
      order = 4;
    }
  ];
}
