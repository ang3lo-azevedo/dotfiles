{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, makeWrapper
, fixup-yarn-lock
, yarn
, nodejs
, typescript
, apktool
, zip
, unzip
, jre
}:

stdenv.mkDerivation rec {
  pname = "apk-mitm";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "niklashigi";
    repo = "apk-mitm";
    rev = "5a96363fc9112b97d60fc2bd3799d6bbfd8e4e00";
    hash = "sha256-wcLShZ7O20i0hzz957dNmfjvxCn5lmWObTdTRF7p+I8=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-iRd63vHnVgQAxPu2/Mf1JKNV8apjZWkrF244rUQumw0=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    typescript
    fixup-yarn-lock
    yarn
  ];

  NODE_ENV = "development";
  NPM_CONFIG_PRODUCTION = "false";
  YARN_PRODUCTION = "false";

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror "$offlineCache"
    fixup-yarn-lock yarn.lock
    yarn --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive --production=false install

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    tsc --skipLibCheck --useUnknownInCatchVariables false

    runHook postBuild
  '';

  postInstall = ''
    yarn --offline --production install

    mkdir -p "$out/lib/node_modules/apk-mitm"
    cp -r . "$out/lib/node_modules/apk-mitm"

    makeWrapper "${nodejs}/bin/node" "$out/bin/apk-mitm" \
      --add-flags "$out/lib/node_modules/apk-mitm/bin/apk-mitm" \
      --prefix PATH : ${lib.makeBinPath [ apktool zip unzip jre ]}
  '';

  doCheck = false;

  meta = with lib; {
    description = "CLI that prepares Android APK files for HTTPS inspection";
    homepage = "https://github.com/niklashigi/apk-mitm";
    license = licenses.mit;
    mainProgram = "apk-mitm";
    platforms = platforms.linux;
  };
}