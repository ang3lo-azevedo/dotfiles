{pkgs}: {
  name ? "chromium-extension",
  url,
  hash,
}:
pkgs.stdenv.mkDerivation {
  inherit name;
  src = pkgs.fetchurl {
    inherit url;
    sha256 = hash;
  };
  nativeBuildInputs = [pkgs.unzip];
  unpackPhase = ''
    mkdir -p $out
    unzip -q $src -d $out || true
  '';
  installPhase = ''
    # unzip already put things in $out
    true
  '';
}
