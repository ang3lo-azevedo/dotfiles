let
  lib = import ../../lib.nix;
  universityConfig = import ../default.nix;
  universityId = (builtins.head universityConfig.spaces).id;
in
{
  pins = [
    {
      name = "Masters";
      id = lib.mkId (universityId + "Masters");
      workspace = universityId;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
    }
  ];
}
