let
  lib = import ../../../../lib.nix;
  parentConfig = import ../default.nix;
  parentPin = builtins.head parentConfig.pins;
in
{
  pins = [
    {
      name = "P2";
      id = lib.mkId (parentPin.id + "P2");
      workspace = parentPin.workspace;
      folderParentId = parentPin.id;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
    }
  ];
}
