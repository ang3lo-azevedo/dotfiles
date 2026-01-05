let
  spaceConfig = import ../default.nix;
  spaceId = (builtins.head spaceConfig.spaces).id;
in
{
  pins = [
    {
      name = "EPT/ROB9-16";
      id = "a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d";
      workspace = spaceId;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
    }
  ];
}
