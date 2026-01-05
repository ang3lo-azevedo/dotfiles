let
  spaceConfig = import ./default.nix;
  spaceId = (builtins.head spaceConfig.spaces).id;
in
{
  pins = [
    {
      name = "Stremio";
      id = "6e428f91-3c6f-5d7g-9e3h-1f2g3h4i5j6k";
      url = "https://web.stremio.com/";
      workspace = spaceId;
    }
  ];
}
