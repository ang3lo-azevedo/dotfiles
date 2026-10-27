{
  imports = [
    # BloodHound: the legacy Electron GUI is a hard `throw` in nixpkgs (dead upstream).
    # Its successor, BloodHound CE, needs a Postgres + Neo4j backend, so it lives as a
    # NixOS service in modules/system/services/bloodhound-ce.nix and is launched on
    # demand with the `bloodhound` command rather than being a home-manager package.
    ./bloodhound-quickwin.nix
    ./certipy.nix
    ./coercer.nix
    ./enum4linux-ng.nix
    ./evil-winrm.nix
    ./kerbrute.nix
    ./ldapsearch.nix
    ./mitm6.nix
    ./netexec.nix
    ./rusthound-ce.nix
    ./smbmap.nix
  ];
}
