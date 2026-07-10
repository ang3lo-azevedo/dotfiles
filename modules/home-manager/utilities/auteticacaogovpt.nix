{
  pkgs,
  lib,
  ...
}: let
  pkg = pkgs.autenticacao-gov-pt-bin;
  pkcs11Lib = "${pkg}/app/lib/libpteidpkcs11.so";
in {
  home.packages = [pkg];

  home.activation.autenticacaoPkcs11 = lib.hm.dag.entryAfter ["writeBoundary"] ''
    profile="$HOME/.config/zen/ang3lo"
    if [ -d "$profile" ]; then
      ${pkgs.nssTools}/bin/modutil -dbdir "sql:$profile" \
        -add "Autenticacao.Gov PT" \
        -libfile "${pkcs11Lib}" \
        -force 2>/dev/null || true
    fi
  '';
}
