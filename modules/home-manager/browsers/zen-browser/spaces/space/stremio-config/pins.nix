{lib}: let
  spaceId = lib.mkId "Space";
  folderId = lib.mkId (spaceId + "Stremio Config");
in {
  pins = lib.imap1 (i: v:
    v
    // {
      order = i;
      workspace = folderId;
      id = lib.mkId (folderId + v.name);
    }) [
    {
      name = "Syncio";
      url = "https://syncio.pi.at.eu.org/addons";
    }
    {
      name = "AIOStreams";
      url = "https://aiostreams.pi.at.eu.org/dashboard/analytics";
    }
    {
      name = "AIOMetadata";
      url = "https://aiometadata.pi.at.eu.org/dashboard";
    }
    {
      name = "Nuvio";
      url = "https://nuvio.tv/account?tab=settings";
    }
    {
      name = "Account Cloner";
      url = "https://nuvio-account-cloner.vercel.app/manage";
    }
    {
      name = "AIO Manager";
      url = "https://aiomanager.pi.at.eu.org/";
    }
    {
      name = "BingeCat";
      url = "https://bingecat.com/";
    }
    {
      name = "Xperience";
      url = "https://xperience-app.com/profile/adc01d05-8281-47cd-863c-a7d3d7feb0d0";
    }
  ];
}
