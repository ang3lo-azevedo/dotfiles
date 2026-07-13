{lib}: let
  spaceId = lib.mkId "Cyber";
in {
  pins = [
    {
      name = "CTFs";
      id = lib.mkId (spaceId + "CTFs");
      workspace = spaceId;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
      folderIcon = "chrome://browser/skin/zen-icons/selectable/flag.svg";
      order = 1;
    }
  ];
}
