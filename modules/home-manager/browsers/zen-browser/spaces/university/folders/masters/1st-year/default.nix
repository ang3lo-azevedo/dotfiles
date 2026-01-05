let
  parentConfig = import ../default.nix;
  parentPin = builtins.head parentConfig.pins;
in
{
  pins = [
    {
      name = "1st Year";
      id = "b2c3d4e5-f6a7-4b5c-9d0e-1f2a3b4c5d6e";
      workspace = parentPin.workspace;
      folderParentId = parentPin.id;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
    }
  ];
}
