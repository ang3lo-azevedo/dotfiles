let
  lib = import ../../../../lib.nix;
  spaceConfig = import ../../../default.nix;
  spaceId = (builtins.head spaceConfig.spaces).id;
  folderConfig = import ./default.nix;
  folderId = (builtins.head folderConfig.pins).id;
in {
  pins = [
    {
      name = "dis.cord.cat";
      id = lib.mkId (spaceId + "dis.cord.cat");
      url = "https://dis.cord.cat/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 1;
    }
  ];
}
