{lib}: let
  spaceId = lib.mkId "Space";
  folderId = lib.mkId (spaceId + "ETFs");
in {
  pins = lib.imap1 (i: v:
    v
    // {
      order = i;
      workspace = folderId;
      id = lib.mkId (folderId + v.name);
    }) [
    {
      name = "XTB";
      url = "https://xstation5.xtb.com/";
    }
    {
      name = "Trading 212";
      url = "https://app.trading212.com/";
    }
    {
      name = "World Monitor";
      url = "https://world-monitor.com/";
    }
    {
      name = "JustETF";
      url = "https://www.justetf.com/en/";
    }
  ];
}
