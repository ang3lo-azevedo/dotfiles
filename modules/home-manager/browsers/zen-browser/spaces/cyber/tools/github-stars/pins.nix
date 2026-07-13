let
  lib = import ../../../lib.nix;
  spaceConfig = import ../../default.nix;
  spaceId = (builtins.head spaceConfig.spaces).id;
  folderConfig = import ./default.nix;
  folderId = (builtins.head folderConfig.pins).id;
in {
  pins = [
    {
      name = "Your Stars";
      id = lib.mkId (spaceId + "Stars");
      url = "https://github.com/ang3lo-azevedo?tab=stars";
      workspace = spaceId;
      folderParentId = folderId;
      order = 1;
    }
    {
      name = "my-awesome-stars";
      id = lib.mkId (spaceId + "my-awesome-stars");
      url = "https://github.com/ang3lo-azevedo/my-awesome-stars";
      workspace = spaceId;
      folderParentId = folderId;
      order = 2;
    }
  ];
}
