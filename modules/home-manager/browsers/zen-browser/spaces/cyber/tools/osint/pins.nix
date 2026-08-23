{lib}: let
  spaceId = lib.mkId "Cyber";
  folderId = lib.mkId (spaceId + "OSINT");
in {
  pins = lib.imap1 (i: v:
    v
    // {
      order = i;
      workspace = folderId;
      id = lib.mkId (folderId + v.name);
    }) [
    {
      name = "dox.soy";
      url = "https://dox.soy/";
    }
    {
      name = "OSINT Toolbox";
      url = "https://github.com/The-Osint-Toolbox/Data-Acquisition-OSINT";
    }
    {
      name = "offshore.cat OSINT";
      url = "https://offshore.cat/?page=osint";
    }
  ];
}
