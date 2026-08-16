{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  zlib,
}:
stdenv.mkDerivation rec {
  pname = "hayabusa";
  version = "4.0.0";

  src = fetchzip {
    url = "https://github.com/Yamato-Security/hayabusa/releases/download/v${version}/hayabusa-${version}-lin-x64-gnu.zip";
    sha256 = "11k3fp7vjq354x6fhyvmrpfmnm5p8vk2nxcgy1ymz9yhg1wk6q9f";
    stripRoot = false;
  };

  nativeBuildInputs = [autoPatchelfHook];

  buildInputs = [
    stdenv.cc.cc.lib
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp hayabusa-* $out/bin/hayabusa
    chmod +x $out/bin/hayabusa

    if [ -d "rules" ]; then
      cp -r rules $out/bin/rules
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "Yamato Security Windows event log fast forensics timeline generator";
    homepage = "https://github.com/Yamato-Security/hayabusa";
    platforms = platforms.linux;
    mainProgram = "hayabusa";
  };
}
