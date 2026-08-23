{lib}: let
  spaceId = lib.mkId "Cyber";
  folderId = lib.mkId (spaceId + "CTFs");
in {
  pins = lib.imap1 (i: v:
    v
    // {
      order = i;
      workspace = folderId;
      id = lib.mkId (folderId + v.name);
    }) [
    {
      name = "CTFtime";
      url = "https://ctftime.org/";
    }
  ];
}
