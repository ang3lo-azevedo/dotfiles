let
  lib = import ../../lib.nix;
  spaceConfig = import ../default.nix;
  spaceId = (builtins.head spaceConfig.spaces).id;
  folderConfig = import ./default.nix;
  folderId = (builtins.head folderConfig.pins).id;
in {
  pins = [
    {
      name = "CTFtime";
      id = lib.mkId (spaceId + "CTFtime");
      url = "https://ctftime.org/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 1;
    }
  ];
}
