{lib}: let
  spaceId = lib.mkId "Space";
in {
  pins = [
    {
      name = "ETFs";
      id = lib.mkId (spaceId + "ETFs");
      workspace = spaceId;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
      order = 2;
    }
  ];
}
