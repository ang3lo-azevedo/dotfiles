{lib}: let
  spaceId = lib.mkId "University";
  mastersId = lib.mkId (spaceId + "Masters");
  firstYearId = lib.mkId (mastersId + "1st Year");
in {
  pins = [
    {
      name = "P2";
      id = lib.mkId (firstYearId + "P2");
      workspace = spaceId;
      folderParentId = firstYearId;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
    }
  ];
}
