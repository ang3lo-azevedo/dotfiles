{lib}: let
  spaceId = lib.mkId "University";
  mastersId = lib.mkId (spaceId + "Masters");
in {
  pins = [
    {
      name = "1st Year";
      id = lib.mkId (mastersId + "1st Year");
      workspace = spaceId;
      folderParentId = mastersId;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
    }
  ];
}
