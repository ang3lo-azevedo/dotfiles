let
  lib = import ../../../lib.nix;
  spaceConfig = import ../../default.nix;
  spaceId = (builtins.head spaceConfig.spaces).id;
  folderConfig = import ./default.nix;
  folderId = (builtins.head folderConfig.pins).id;
in {
  pins = [
    {
      name = "OnlineHashCrack";
      id = lib.mkId (spaceId + "OnlineHashCrack");
      url = "https://www.onlinehashcrack.com/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 1;
    }
  ];
}
