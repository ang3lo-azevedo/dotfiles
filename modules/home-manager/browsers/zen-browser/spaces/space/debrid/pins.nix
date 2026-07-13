{lib}: let
  spaceId = lib.mkId "Space";
  folderId = lib.mkId (spaceId + "Debrid");
in {
  pins = [
    {
      name = "TorBox";
      id = lib.mkId (spaceId + "Debrid TorBox");
      url = "https://torbox.app/dashboard";
      workspace = spaceId;
      folderParentId = folderId;
      order = 1;
    }
    {
      name = "Debrid Vault";
      id = lib.mkId (spaceId + "Debrid Vault");
      url = "https://debridvault.elfhosted.com/analytics";
      workspace = spaceId;
      folderParentId = folderId;
      order = 2;
    }
    {
      name = "TBM Tools";
      id = lib.mkId (spaceId + "Debrid TBM Tools");
      url = "https://tbm.tools/en";
      workspace = spaceId;
      folderParentId = folderId;
      order = 3;
    }
  ];
}
