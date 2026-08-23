{lib}: let
  spaceId = lib.mkId "Space";
in {
  pins = lib.imap1 (i: v:
    v
    // {
      order = i;
      workspace = spaceId;
      id = lib.mkId (spaceId + v.name);
    }) [
    {
      name = "Stremio";
      url = "https://web.stremio.com/";
    }
  ];
}
