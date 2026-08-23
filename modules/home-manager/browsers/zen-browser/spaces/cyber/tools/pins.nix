{lib}: let
  spaceId = lib.mkId "Cyber";
  folderId = lib.mkId (spaceId + "Tools");
in {
  pins = lib.imap1 (i: v:
    v
    // {
      order = i;
      workspace = folderId;
      id = lib.mkId (folderId + v.name);
    }) [
    {
      name = "CyberChef";
      url = "https://gchq.github.io/CyberChef/";
    }
    {
      name = "PayloadsAllTheThings";
      url = "https://swisskyrepo.github.io/PayloadsAllTheThings/";
    }
    {
      name = "RevShells";
      url = "https://www.revshells.com/";
    }
    {
      name = "GTFOBins";
      url = "https://gtfobins.github.io/";
    }
    {
      name = "CSP Bypass";
      url = "https://cspbypass.com/";
    }
    {
      name = "PoC-in-GitHub";
      url = "https://github.com/nomi-sec/PoC-in-GitHub";
    }
    {
      name = "Welcome • freemediaheckyeah";
      url = "https://fmhy.net/";
    }
    {
      name = "HackTricks";
      url = "https://book.hacktricks.xyz/";
    }
  ];
}
