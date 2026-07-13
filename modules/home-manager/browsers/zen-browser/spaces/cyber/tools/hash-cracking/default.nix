{lib}: let
  spaceId = lib.mkId "Cyber";
  toolsId = lib.mkId (spaceId + "Tools");
in {
  pins = [
    {
      name = "Hash Cracking";
      id = lib.mkId (spaceId + "Hash Cracking");
      workspace = spaceId;
      folderParentId = toolsId;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
      folderIcon = "chrome://browser/skin/zen-icons/selectable/skull.svg";
      order = 8;
    }
  ];
}
