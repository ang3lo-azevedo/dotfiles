{ lib
, stdenvNoCC
, fetchFromGitHub
, makeWrapper
, binutils
, coreutils
, findutils
, gnugrep
, volatility3
}:

stdenvNoCC.mkDerivation {
  pname = "volatility-toolkit";
  version = "2.1.1";
  dontBuild = true;

  src = fetchFromGitHub {
    owner = "gl0bal01";
    repo = "volatility-toolkit";
    rev = "v2.1.1";
    sha256 = "0s860y5rdrwzq3qx53r3vha7js5r3vq74ay03rwpy2j3bnj5yxyq";
  };

  nativeBuildInputs = [ makeWrapper ];

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