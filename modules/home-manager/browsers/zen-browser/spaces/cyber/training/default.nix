{lib}: let
  spaceId = lib.mkId "Cyber";
in {
  pins = [
    {
      name = "Training";
      id = lib.mkId (spaceId + "Training");
      workspace = spaceId;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
      folderIcon = "chrome://browser/skin/zen-icons/selectable/school.svg";
      order = 9;
    }
  ];
}
