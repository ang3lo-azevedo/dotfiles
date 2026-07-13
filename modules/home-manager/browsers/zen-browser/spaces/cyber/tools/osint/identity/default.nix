{lib}: let
  spaceId = lib.mkId "Cyber";
  osintId = lib.mkId (spaceId + "OSINT");
in {
  pins = [
    {
      name = "🔍";
      id = lib.mkId (spaceId + "identity");
      workspace = spaceId;
      folderParentId = osintId;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
      order = 5;
    }
  ];
}
