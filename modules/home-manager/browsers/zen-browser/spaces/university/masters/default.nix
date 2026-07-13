{lib}: let
  spaceId = lib.mkId "University";
in {
  pins = [
    {
      name = "Masters";
      id = lib.mkId (spaceId + "Masters");
      workspace = spaceId;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
    }
  ];
}
