{lib}: let
  spaceId = lib.mkId "Space";
  folderId = lib.mkId (spaceId + "ETFs");
in {
  pins = [
    {
      name = "XTB";
      id = lib.mkId (spaceId + "ETFs XTB");
      url = "https://xstation5.xtb.com/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 1;
    }
    {
      name = "Trading 212";
      id = lib.mkId (spaceId + "ETFs Trading 212");
      url = "https://app.trading212.com/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 2;
    }
    {
      name = "World Monitor";
      id = lib.mkId (spaceId + "ETFs World Monitor");
      url = "https://world-monitor.com/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 3;
    }
    {
      name = "JustETF";
      id = lib.mkId (spaceId + "ETFs JustETF");
      url = "https://www.justetf.com/en/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 4;
    }
  ];
}
