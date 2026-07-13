{lib}: let
  spaceId = lib.mkId "Cyber";
  folderId = lib.mkId (spaceId + "Training");
in {
  pins = [
    {
      name = "pwn.college";
      id = lib.mkId (spaceId + "pwn.college");
      url = "https://pwn.college/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 1;
    }
    {
      name = "crackmes.one";
      id = lib.mkId (spaceId + "crackmes.one");
      url = "https://crackmes.one/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 2;
    }
    {
      name = "PortSwigger Academy";
      id = lib.mkId (spaceId + "PortSwigger Academy");
      url = "https://portswigger.net/web-security/dashboard";
      workspace = spaceId;
      folderParentId = folderId;
      order = 3;
    }
  ];
}
