{lib}: let
  spaceId = lib.mkId "Space";
  folderId = lib.mkId (spaceId + "Debrid");
in {
  pins = lib.imap1 (i: v:
    v
    // {
      order = i;
      workspace = folderId;
      id = lib.mkId (folderId + v.name);
    }) [
    {
      name = "TorBox";
      url = "https://torbox.app/dashboard";
    }
    {
      name = "Debrid Vault";
      url = "https://debridvault.elfhosted.com/analytics";
    }
    {
      name = "TBM Tools";
      url = "https://tbm.tools/en";
    }
  ];
}
