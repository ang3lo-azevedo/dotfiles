let
  lib = import ../../../lib.nix;
  parentConfig = import ../default.nix;
  parentPin = builtins.head parentConfig.pins;
in
{
  pins = [
    {
      name = "1st Year";
      id = lib.mkId (parentPin.id + "1st Year");
      workspace = parentPin.workspace;
      folderParentId = parentPin.id;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
    }
  ];
}
