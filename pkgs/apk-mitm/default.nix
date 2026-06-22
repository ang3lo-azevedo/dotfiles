{ lib
, stdenv
, callPackage
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
let
  sources = callPackage ../_sources/generated.nix { };
in
stdenv.mkDerivation rec {
  pname = "apk-mitm";
  version = sources.apk-mitm.version;

  src = sources.apk-mitm.src;

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