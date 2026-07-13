let
  lib = import ../../lib.nix;
  spaceConfig = import ../default.nix;
  spaceId = (builtins.head spaceConfig.spaces).id;
  folderConfig = import ./default.nix;
  folderId = (builtins.head folderConfig.pins).id;
in {
  pins = [
    {
      name = "Syncio";
      id = lib.mkId (spaceId + "Stremio Config Syncio");
      url = "https://syncio.pi.at.eu.org/addons";
      workspace = spaceId;
      folderParentId = folderId;
      order = 1;
    }
    {
      name = "AIOStreams";
      id = lib.mkId (spaceId + "Stremio Config AIOStreams");
      url = "https://aiostreams.pi.at.eu.org/dashboard/analytics";
      workspace = spaceId;
      folderParentId = folderId;
      order = 2;
    }
    {
      name = "AIOMetadata";
      id = lib.mkId (spaceId + "Stremio Config AIOMetadata");
      url = "https://aiometadata.pi.at.eu.org/dashboard";
      workspace = spaceId;
      folderParentId = folderId;
      order = 3;
    }
    {
      name = "Nuvio";
      id = lib.mkId (spaceId + "Stremio Config Nuvio");
      url = "https://nuvio.tv/account?tab=settings";
      workspace = spaceId;
      folderParentId = folderId;
      order = 4;
    }
    {
      name = "Account Cloner";
      id = lib.mkId (spaceId + "Stremio Config Account Cloner");
      url = "https://nuvio-account-cloner.vercel.app/manage";
      workspace = spaceId;
      folderParentId = folderId;
      order = 5;
    }
    {
      name = "AIO Manager";
      id = lib.mkId (spaceId + "Stremio Config AIO Manager");
      url = "https://aiomanager.pi.at.eu.org/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 6;
    }
    {
      name = "BingeCat";
      id = lib.mkId (spaceId + "Stremio Config BingeCat");
      url = "https://bingecat.com/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 7;
    }
    {
      name = "Xperience";
      id = lib.mkId (spaceId + "Stremio Config Xperience");
      url = "https://xperience-app.com/profile/adc01d05-8281-47cd-863c-a7d3d7feb0d0";
      workspace = spaceId;
      folderParentId = folderId;
      order = 8;
    }
  ];
}
