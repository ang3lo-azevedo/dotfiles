{lib}: let
  spaceId = lib.mkId "Cyber";
  toolsId = lib.mkId (spaceId + "Tools");
in {
  pins = [
    {
      name = "OSINT";
      id = lib.mkId (spaceId + "OSINT");
      workspace = spaceId;
      folderParentId = toolsId;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
      order = 3;
    }
  ];
}
