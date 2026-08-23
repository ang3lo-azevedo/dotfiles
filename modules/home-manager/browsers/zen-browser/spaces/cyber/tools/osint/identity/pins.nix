{lib}: let
  spaceId = lib.mkId "Cyber";
  folderId = lib.mkId (spaceId + "identity");
in {
  pins = lib.imap1 (i: v:
    v
    // {
      order = i;
      workspace = folderId;
      id = lib.mkId (folderId + v.name);
    }) [
    {
      name = "HaveIBeenPwned";
      url = "https://haveibeenpwned.com/";
    }
    {
      name = "intelbase";
      url = "https://intelbase.is/";
    }
    {
      name = "swolesome";
      url = "https://swolesome.pages.dev/";
    }
    {
      name = "breach.vip";
      url = "https://breach.vip/";
    }
    {
      name = "emailosint";
      url = "https://emailosint.org/";
    }
    {
      name = "osintleak";
      url = "https://app.osintleak.com/";
    }
  ];
}
