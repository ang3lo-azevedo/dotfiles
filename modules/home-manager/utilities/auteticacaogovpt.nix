{pkgs, ...}: let
  pkg = pkgs.autenticacao-gov-pt-bin;
  # PKCS#11 module exposed by the middleware; registers the citizen card as a
  # security device in Firefox/Zen so https://autenticacao.gov.pt sign-in works.
  pkcs11Lib = "${pkg}/app/lib/libpteidpkcs11.so";
in {
  home.packages = [pkg];

  # Register the PKCS#11 security device in the Zen profile database so the
  # citizen card is available for web authentication without manual browser setup.
  home.activation.autenticacaoPkcs11 = pkgs.lib.hm.dag.entryAfter ["writeBoundary"] ''
    profile="$HOME/.config/zen/ang3lo"
    if [ -d "$profile" ]; then
      ${pkgs.nss_tools}/bin/modutil -dbdir "sql:$profile" \
        -add "Autenticacao.Gov PT" \
        -libfile "${pkcs11Lib}" \
        -force 2>/dev/null || true
    fi
  '';
}
