{ pkgs, ... }:
let
  idaRun = ./ida93sp2/ida-pro_93_x64linux.run;

  scriptJs = ./ida93sp2/kg_patch/keygen.js; 
in
{
  home.packages = with pkgs; [
    (ida-pro.overrideAttrs (old: let stdenv = pkgs.stdenv; in {
      version = "9.3.0";
      src = idaRun;

      # Add Node.js as a build dependency so the 'node' command is available
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.nodejs ];

      propagatedBuildInputs = (old.propagatedBuildInputs or []) ++ [ pkgs."libxcrypt-legacy" ];

      installPhase = ''
        mkdir -p $TMP/ida-inst
        cd $TMP/ida-inst
        cp ${idaRun} ./installer.run
        chmod +x ./installer.run || true
        ./installer.run --mode unattended --prefix $out/opt || true

        # If installer extracted into a temporary opt tree, copy it into $out
        if [ -d "$TMP/ida-inst/opt" ]; then
          mkdir -p $out/opt
          cp -a "$TMP/ida-inst/opt/." "$out/opt/"
        fi

        # Ensure scripts are executable and adjust perms where needed
        if [ -d "$out/opt" ]; then
          find "$out/opt" -type f -name '*.sh' -exec chmod +x {} + || true
        fi

        # Copy the script to the IDA installation folder and run it
        if [ -d "$out/opt" ]; then
          echo "Copying script.js to IDA installation folder..."
          cp ${scriptJs} $out/opt/script.js
          
          echo "Running script.js..."
          cd $out/opt
          node ./script.js
        fi
      '';
    }))
  ];
}