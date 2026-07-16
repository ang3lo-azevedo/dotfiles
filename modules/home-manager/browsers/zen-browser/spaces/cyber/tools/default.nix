{lib}: let
  spaceId = lib.mkId "Cyber";
in {
  pins = [
    {
      name = "Tools";
      id = lib.mkId (spaceId + "Tools");
      workspace = spaceId;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
      folderIcon = "chrome://browser/skin/zen-icons/selectable/construct.svg";
      order = 2;
    }
  ];
}
