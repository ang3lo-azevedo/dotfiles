let
  lib = import ../../../lib.nix;
  spaceConfig = import ../../default.nix;
  spaceId = (builtins.head spaceConfig.spaces).id;
  folderConfig = import ./default.nix;
  folderId = (builtins.head folderConfig.pins).id;
in {
  pins = [
    {
      name = "vecert";
      id = lib.mkId (spaceId + "vecert");
      url = "https://analyzer.vecert.io/forum";
      workspace = spaceId;
      folderParentId = folderId;
      order = 1;
    }
    {
      name = "breach.house PT";
      id = lib.mkId (spaceId + "breach.house PT");
      url = "https://breach.house/all_breaches?group-filter=&country-filter=PT&discovered-order=newest";
      workspace = spaceId;
      folderParentId = folderId;
      order = 2;
    }
  ];
}
