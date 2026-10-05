{
  imports = [
    # Disabled: nixpkgs replaced this package with a hard `throw` ("bloodhound's
    # upstream is archived, and the package is running on Electron 11"), so it
    # can no longer be built at all, unlike an insecure-package flag this isn't
    # something permittedInsecurePackages can opt back into. The legacy Electron
    # GUI is dead upstream; the actively maintained successor is BloodHound CE
    # (github.com/SpecterOps/BloodHound), packaged in current nixpkgs as
    # `bloodhound-ce`, but it expects a Postgres + Neo4j backend behind it
    # rather than being a drop-in single-binary GUI, so wiring it up is a
    # separate decision, not a rename here.
    # ./bloodhound.nix
    ./certipy.nix
    ./coercer.nix
    ./enum4linux-ng.nix
    ./evil-winrm.nix
    ./kerbrute.nix
    ./mitm6.nix
    ./netexec.nix
    ./rusthound-ce.nix
    ./smbmap.nix
  ];
}
