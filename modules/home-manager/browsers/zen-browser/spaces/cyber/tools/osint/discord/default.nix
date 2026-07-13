{lib}: let
  spaceId = lib.mkId "Cyber";
  osintId = lib.mkId (spaceId + "OSINT");
in {
  pins = [
    {
      name = "Discord";
      id = lib.mkId (spaceId + "Discord");
      workspace = spaceId;
      folderParentId = osintId;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
      order = 6;
    }
  ];
}
