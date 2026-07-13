{lib}: let
  spaceId = lib.mkId "Cyber";
in {
  pins = [
    {
      name = "CyberChef";
      id = lib.mkId "CyberChef";
      url = "https://gchq.github.io/CyberChef/";
      workspace = spaceId;
      order = 1;
    }
    {
      name = "Yandex";
      id = lib.mkId (spaceId + "Yandex");
      url = "https://yandex.com/";
      workspace = spaceId;
      order = 100;
    }
  ];
}
