let
  lib = import ../../../lib.nix;
  spaceConfig = import ../../default.nix;
  spaceId = (builtins.head spaceConfig.spaces).id;
  parentConfig = import ../default.nix;
  parentId = (builtins.head parentConfig.pins).id;
in {
  pins = [
    {
      name = "OSINT";
      id = lib.mkId (spaceId + "OSINT");
      workspace = spaceId;
      folderParentId = parentId;
      isGroup = true;
      isFolderCollapsed = false;
      editedTitle = true;
      order = 3;
    }
  ];
}
