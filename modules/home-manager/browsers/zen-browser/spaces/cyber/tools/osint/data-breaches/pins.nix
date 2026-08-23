{lib}: let
  spaceId = lib.mkId "Cyber";
  folderId = lib.mkId (spaceId + "Data Breaches");
in {
  pins = lib.imap1 (i: v:
    v
    // {
      order = i;
      workspace = folderId;
      id = lib.mkId (folderId + v.name);
    }) [
    {
      name = "vecert";
      url = "https://analyzer.vecert.io/forum";
    }
    {
      name = "breach.house PT";
      url = "https://breach.house/all_breaches?group-filter=&country-filter=PT&discovered-order=newest";
    }
  ];
}
