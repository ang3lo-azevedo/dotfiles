let
  lib = import ../../../lib.nix;
  spaceConfig = import ../../default.nix;
  spaceId = (builtins.head spaceConfig.spaces).id;
  parentConfig = import ../default.nix;
  parentId = (builtins.head parentConfig.pins).id;
in {
  pins = [
    {
      name = "Hash Cracking";
      id = lib.mkId (spaceId + "Hash Cracking");
      workspace = spaceId;
      folderParentId = parentId;
      isGroup = true;
      isFolderCollapsed = false;
      editedTitle = true;
      folderIcon = "chrome://browser/skin/zen-icons/selectable/skull.svg";
      order = 8;
    }
  ];
}
