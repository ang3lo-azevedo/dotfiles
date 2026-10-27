{pkgs, ...}: {
  # ldapsearch (and ldapwhoami, ldapcompare) ship in openldap, alongside the
  # slapd server binaries, which go unused in a client toolkit
  home.packages = with pkgs; [
    openldap
  ];
}
