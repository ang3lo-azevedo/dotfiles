{ stdenv, python3, lib, src ? null }:

stdenv.mkDerivation rec {
  pname = "angr-management";
  version = "unstable";

  inherit src;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/${pname}
    cp -r . $out/share/${pname}/

    cat > $out/bin/angr-management <<'EOT'
#!/bin/sh
exec ${python3}/bin/python3 -m angr_management "$@"
EOT
    chmod +x $out/bin/angr-management
  '';

  meta = with lib; {
    description = "angr Management UI (sourced from GitHub)";
    license = licenses.unfree; # upstream may have non-free parts
    maintainers = with maintainers; [ ];
  };
}
