{lib}: let
  spaceId = lib.mkId "Cyber";
  toolsId = lib.mkId (spaceId + "Tools");
in {
  pins = [
    {
      name = "GitHub Stars";
      id = lib.mkId (spaceId + "GitHub Stars");
      workspace = spaceId;
      folderParentId = toolsId;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
      folderIcon = "chrome://browser/skin/zen-icons/selectable/star-1.svg";
      order = 7;
    }
  ];
}
