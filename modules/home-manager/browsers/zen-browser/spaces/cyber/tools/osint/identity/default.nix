let
  lib = import ../../../../lib.nix;
  spaceConfig = import ../../../default.nix;
  spaceId = (builtins.head spaceConfig.spaces).id;
  parentConfig = import ../default.nix;
  parentId = (builtins.head parentConfig.pins).id;
in {
  pins = [
    {
      name = "🔍";
      id = lib.mkId (spaceId + "identity");
      workspace = spaceId;
      folderParentId = parentId;
      isGroup = true;
      isFolderCollapsed = false;
      editedTitle = true;
      order = 5;
    }
  ];
}
