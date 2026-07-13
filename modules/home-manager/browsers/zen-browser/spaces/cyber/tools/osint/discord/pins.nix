{lib}: let
  spaceId = lib.mkId "Cyber";
  folderId = lib.mkId (spaceId + "Discord");
in {
  pins = [
    {
      name = "dis.cord.cat";
      id = lib.mkId (spaceId + "dis.cord.cat");
      url = "https://dis.cord.cat/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 1;
    }
  ];
}
