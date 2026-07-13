{lib}: let
  spaceId = lib.mkId "Cyber";
  folderId = lib.mkId (spaceId + "CTFs");
in {
  pins = [
    {
      name = "CTFtime";
      id = lib.mkId (spaceId + "CTFtime");
      url = "https://ctftime.org/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 1;
    }
  ];
}
