{lib}: let
  spaceId = lib.mkId "Work";
in {
  pins = [
    {
      name = "Teaching";
      id = lib.mkId (spaceId + "Teaching");
      workspace = spaceId;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
      folderIcon = "chrome://browser/skin/zen-icons/selectable/book.svg";
      order = 1;
    }
  ];
}
