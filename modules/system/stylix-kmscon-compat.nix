{lib, ...}: let
  inherit (lib) mkAliasOptionModule;
in {
  imports = [
    (mkAliasOptionModule ["services" "kmscon" "config"] ["services" "kmscon" "extraConfig"])
  ];
}
