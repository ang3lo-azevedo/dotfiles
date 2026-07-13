{lib}: let
  spaceId = lib.mkId "Cyber";
  folderId = lib.mkId (spaceId + "Hash Cracking");
in {
  pins = [
    {
      name = "OnlineHashCrack";
      id = lib.mkId (spaceId + "OnlineHashCrack");
      url = "https://www.onlinehashcrack.com/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 1;
    }
  ];
}
