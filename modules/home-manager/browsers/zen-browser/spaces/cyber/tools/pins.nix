let
  lib = import ../../lib.nix;
  spaceConfig = import ../default.nix;
  spaceId = (builtins.head spaceConfig.spaces).id;
  folderConfig = import ./default.nix;
  folderId = (builtins.head folderConfig.pins).id;
in {
  pins = [
    {
      name = "CyberChef";
      id = lib.mkId (spaceId + "CyberChef");
      url = "https://gchq.github.io/CyberChef/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 1;
    }
    {
      name = "PayloadsAllTheThings";
      id = lib.mkId (spaceId + "PayloadsAllTheThings");
      url = "https://swisskyrepo.github.io/PayloadsAllTheThings/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 2;
    }
    {
      name = "RevShells";
      id = lib.mkId (spaceId + "RevShells");
      url = "https://www.revshells.com/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 3;
    }
    {
      name = "GTFOBins";
      id = lib.mkId (spaceId + "GTFOBins");
      url = "https://gtfobins.github.io/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 4;
    }
  ];
}
