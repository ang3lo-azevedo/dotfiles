let
  parentConfig = import ../default.nix;
  parentPin = builtins.head parentConfig.pins;
in
{
  pins = [
    {
      name = "P2";
      id = "c3d4e5f6-a7b8-1f2a-3b4c-5d6e7f8g9h0i";
      workspace = parentPin.workspace;
      folderParentId = parentPin.id;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
    }
  ];
}
