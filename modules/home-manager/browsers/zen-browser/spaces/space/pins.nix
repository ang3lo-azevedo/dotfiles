let
  lib = import ../lib.nix;
  spaceConfig = import ./default.nix;
  spaceId = (builtins.head spaceConfig.spaces).id;
in
{
  pins = [
    {
      name = "Stremio";
      id = lib.mkId (spaceId + "Stremio");
      url = "https://web.stremio.com/";
      workspace = spaceId;
      order = 2;
    }
  ];
}
