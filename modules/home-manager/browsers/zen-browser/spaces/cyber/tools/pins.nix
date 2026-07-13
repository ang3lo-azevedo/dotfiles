{lib}: let
  spaceId = lib.mkId "Cyber";
  folderId = lib.mkId (spaceId + "Tools");
in {
  pins = [
    {
      name = "PayloadsAllTheThings";
      id = lib.mkId (spaceId + "PayloadsAllTheThings");
      url = "https://swisskyrepo.github.io/PayloadsAllTheThings/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 2;
    }
    {
      name = "RevShells";
      id = lib.mkId (spaceId + "RevShells");
      url = "https://www.revshells.com/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 3;
    }
    {
      name = "GTFOBins";
      id = lib.mkId (spaceId + "GTFOBins");
      url = "https://gtfobins.github.io/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 4;
    }
    {
      name = "CSP Bypass";
      id = lib.mkId (spaceId + "CSP Bypass");
      url = "https://cspbypass.com/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 5;
    }
    {
      name = "PoC-in-GitHub";
      id = lib.mkId (spaceId + "PoC-in-GitHub");
      url = "https://github.com/nomi-sec/PoC-in-GitHub";
      workspace = spaceId;
      folderParentId = folderId;
      order = 6;
    }
    {
      name = "FMHY";
      id = lib.mkId (spaceId + "FMHY");
      url = "https://fmhy.net/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 7;
    }
  ];
}
