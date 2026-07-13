let
  lib = import ../../../lib.nix;
  spaceConfig = import ../../default.nix;
  spaceId = (builtins.head spaceConfig.spaces).id;
  parentConfig = import ../default.nix;
  parentId = (builtins.head parentConfig.pins).id;
  folderId = lib.mkId (spaceId + "identity");
in {
  pins = [
    {
      name = "🔍";
      id = folderId;
      workspace = spaceId;
      folderParentId = parentId;
      isGroup = true;
      isFolderCollapsed = false;
      editedTitle = true;
      order = 5;
    }
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
