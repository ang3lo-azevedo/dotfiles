let
  lib = import ../lib.nix;
  spaceConfig = import ./default.nix;
  spaceId = (builtins.head spaceConfig.spaces).id;
in {
  pins = [
    {
      name = "Yandex";
      id = lib.mkId (spaceId + "Yandex");
      url = "https://yandex.com/";
      workspace = spaceId;
      order = 100;
    }
  ];
}
