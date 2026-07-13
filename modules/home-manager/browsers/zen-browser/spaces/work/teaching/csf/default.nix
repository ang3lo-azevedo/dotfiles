{lib}: let
  spaceId = lib.mkId "Work";
  teachingId = lib.mkId (spaceId + "Teaching");
in {
  pins = [
    {
      name = "CSF";
      id = lib.mkId (spaceId + "CSF");
      workspace = spaceId;
      folderParentId = teachingId;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
      folderIcon = "chrome://browser/skin/zen-icons/selectable/inbox.svg";
      order = 1;
    }
  ];
}
