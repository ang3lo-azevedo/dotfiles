let
  lib = import ../../../lib.nix;
  spaceConfig = import ../../default.nix;
  spaceId = (builtins.head spaceConfig.spaces).id;
  folderConfig = import ./default.nix;
  folderId = (builtins.head folderConfig.pins).id;
in {
  pins = [
    {
      name = "HaveIBeenPwned";
      id = lib.mkId (spaceId + "HaveIBeenPwned");
      url = "https://haveibeenpwned.com/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 1;
    }
    {
      name = "intelbase";
      id = lib.mkId (spaceId + "intelbase");
      url = "https://intelbase.is/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 2;
    }
    {
      name = "swolesome";
      id = lib.mkId (spaceId + "swolesome");
      url = "https://swolesome.pages.dev/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 3;
    }
    {
      name = "breach.vip";
      id = lib.mkId (spaceId + "breach.vip");
      url = "https://breach.vip/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 4;
    }
    {
      name = "emailosint";
      id = lib.mkId (spaceId + "emailosint");
      url = "https://emailosint.org/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 5;
    }
    {
      name = "osintleak";
      id = lib.mkId (spaceId + "osintleak");
      url = "https://app.osintleak.com/";
      workspace = spaceId;
      folderParentId = folderId;
      order = 6;
    }
  ];
}
