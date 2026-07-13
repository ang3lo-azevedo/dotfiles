{lib}: let
  spaceId = lib.mkId "Space";
in {
  pins = [
    {
      name = "Stremio";
      id = lib.mkId (spaceId + "Stremio");
      url = "https://web.stremio.com/";
      workspace = spaceId;
      order = 2;
    }
  ];
}
