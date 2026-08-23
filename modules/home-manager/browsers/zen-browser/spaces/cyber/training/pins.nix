{lib}: let
  spaceId = lib.mkId "Cyber";
  folderId = lib.mkId (spaceId + "Training");
in {
  pins = lib.imap1 (i: v:
    v
    // {
      order = i;
      workspace = folderId;
      id = lib.mkId (folderId + v.name);
    }) [
    {
      name = "pwn.college";
      url = "https://pwn.college/";
    }
    {
      name = "Crackmes.one";
      url = "https://crackmes.one/";
    }
    {
      name = "Dashboard | Web Security Academy - PortSwigger";
      url = "https://portswigger.net/web-security/dashboard";
    }
    {
      name = "CyLab Security Academy - Dashboard";
      url = "https://learn.cylabacademy.org/dashboard";
    }
  ];
}
