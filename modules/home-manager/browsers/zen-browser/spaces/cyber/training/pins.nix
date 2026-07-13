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
      name = "Crackmes.one";
      id = lib.mkId (spaceId + "Crackmes.one");
      url = "https://crackmes.one/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 2;
    }
    {
      name = "Dashboard | Web Security Academy - PortSwigger";
      id = lib.mkId (spaceId + "Dashboard | Web Security Academy - PortSwigger");
      url = "https://portswigger.net/web-security/dashboard";
      workspace = spaceId;
      folderParentId = folderId;
      order = 3;
    }
    {
      name = "CyLab Security Academy - Dashboard";
      id = lib.mkId (spaceId + "CyLab Security Academy - Dashboard");
      url = "https://learn.cylabacademy.org/dashboard";
      workspace = spaceId;
      folderParentId = folderId;
      order = 4;
    }
  ];
}
