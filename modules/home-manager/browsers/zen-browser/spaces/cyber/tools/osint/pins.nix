{lib}: let
  spaceId = lib.mkId "Cyber";
  folderId = lib.mkId (spaceId + "OSINT");
in {
  pins = [
    {
      name = "dox.soy";
      id = lib.mkId (spaceId + "dox.soy");
      url = "https://dox.soy/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 1;
    }
    {
      name = "OSINT Toolbox";
      id = lib.mkId (spaceId + "OSINT Toolbox");
      url = "https://github.com/The-Osint-Toolbox/Data-Acquisition-OSINT";
      workspace = spaceId;
      folderParentId = folderId;
      order = 2;
    }
    {
      name = "offshore.cat OSINT";
      id = lib.mkId (spaceId + "offshore.cat OSINT");
      url = "https://offshore.cat/?page=osint";
      workspace = spaceId;
      folderParentId = folderId;
      order = 3;
    }
  ];
}
