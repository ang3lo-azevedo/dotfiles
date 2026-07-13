{lib}: let
  spaceId = lib.mkId "Work";
in {
  pins = [
    {
      name = "CSF";
      id = lib.mkId (spaceId + "CSF");
      workspace = spaceId;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
      folderIcon = "chrome://browser/skin/zen-icons/selectable/inbox.svg";
      order = 1;
    }
  ];
}
