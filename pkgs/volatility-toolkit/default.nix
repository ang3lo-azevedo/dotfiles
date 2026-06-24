{
  lib,
  stdenvNoCC,
  makeWrapper,
  binutils,
  coreutils,
  findutils,
  gnugrep,
  volatility3,
  callPackage,
}: let
  sources = callPackage ../_sources/generated.nix {};
in
  stdenvNoCC.mkDerivation {
    pname = "volatility-toolkit";
    version = sources.volatility-toolkit.version;
    dontBuild = true;

    src = sources.volatility-toolkit.src;

    nativeBuildInputs = [makeWrapper];

    installPhase = ''
      runHook preInstall

      install -Dm755 scripts/vol-analyze.sh $out/bin/vol-analyze
      install -Dm644 completions/vol-analyze.bash $out/share/bash-completion/completions/vol-analyze
      install -Dm644 completions/vol-analyze.zsh $out/share/zsh/site-functions/_vol-analyze
      install -d $out/share/doc/volatility-toolkit
      install -m644 docs/*.md -t $out/share/doc/volatility-toolkit

      wrapProgram $out/bin/vol-analyze \
        --prefix PATH : ${lib.makeBinPath [
        binutils
        coreutils
        findutils
        gnugrep
        volatility3
      ]}

      runHook postInstall
    '';

    meta = with lib; {
      description = "Automated memory forensics wrapper around Volatility 3";
      homepage = "https://github.com/gl0bal01/volatility-toolkit";
      license = licenses.agpl3Only;
      platforms = platforms.all;
      mainProgram = "vol-analyze";
    };
  }
