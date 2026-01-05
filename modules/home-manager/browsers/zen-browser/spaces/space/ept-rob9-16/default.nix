let
  lib = import ../../lib.nix;
  spaceConfig = import ../default.nix;
  spaceId = (builtins.head spaceConfig.spaces).id;
in
{
  pins = [
    {
      name = "EPT/ROB9-16";
      id = lib.mkId "EPT/ROB9-16";
      workspace = spaceId;
      order = 1;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
    }
  ];
}
