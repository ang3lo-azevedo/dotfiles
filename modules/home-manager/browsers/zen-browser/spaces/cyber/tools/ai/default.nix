{lib}: let
  spaceId = lib.mkId "Cyber";
  toolsId = lib.mkId (spaceId + "Tools");
in {
  pins = [
    {
      name = "AI";
      id = lib.mkId (spaceId + "AI");
      workspace = spaceId;
      folderParentId = toolsId;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
      folderIcon = "chrome://browser/skin/zen-icons/selectable/globe-1.svg";
      order = 100;
    }
  ];
}
