{lib}: let
  spaceId = lib.mkId "Cyber";
  osintId = lib.mkId (spaceId + "OSINT");
in {
  pins = [
    {
      name = "Data Breaches";
      id = lib.mkId (spaceId + "Data Breaches");
      workspace = spaceId;
      folderParentId = osintId;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
      order = 4;
    }
  ];
}
