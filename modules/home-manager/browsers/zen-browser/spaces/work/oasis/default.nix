{lib}: let
  spaceId = lib.mkId "Work";
in {
  pins = [
    {
      name = "Oasis";
      id = lib.mkId (spaceId + "Oasis");
      workspace = spaceId;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
      order = 1;
    }
  ];
}
