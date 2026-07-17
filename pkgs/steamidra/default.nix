{
  lib,
  stdenv,
  makeWrapper,
  python3,
  callPackage,
}: let
  sources = callPackage ../_sources/generated.nix {};
  pythonEnv = python3.withPackages (ps:
    with ps; [
      pyqt6
      pyqt6-webengine
      beautifulsoup4
      gevent
      greenlet
      httpx
      keyring
      lxml
      pillow
      protobuf
      psutil
      pycryptodome
      pygments
      pynacl
      pyperclip
      pyyaml
      requests
      rich
      setuptools
      six
      tqdm
      websocket-client
      vdf
      py7zr
      rarfile
      google-auth
      google-auth-oauthlib
      google-api-python-client
      certifi
      charset-normalizer
      colorama
      h11
      httpcore
      idna
      markdown-it-py
      mdurl
      more-itertools
      msgpack
      outcome
      packaging
      prompt-toolkit
      pycparser
      pysocks
      sniffio
      sortedcontainers
      trio
      typing-extensions
      urllib3
      wcwidth
      wsproto
      zipp
      cffi
      cachetools
      jaraco-classes
      jaraco-context
      jaraco-functools
      cryptography
      jeepney
      secretstorage
    ]);
in
  stdenv.mkDerivation {
    pname = "steamidra";
    version = sources.steamidra.version;
    src = sources.steamidra.src;

    nativeBuildInputs = [makeWrapper];
    buildInputs = [pythonEnv];

    installPhase = ''
        runHook preInstall

        mkdir -p $out/{bin,share/steamidra,share/applications,share/icons/hicolor/256x256/apps}

        cp -r . $out/share/steamidra/

        makeWrapper ${pythonEnv}/bin/python $out/bin/steamidra \
          --add-flags "$out/share/steamidra/Main_gui.py" \
          --prefix PYTHONPATH : $out/share/steamidra

        makeWrapper ${pythonEnv}/bin/python $out/bin/steamidra-cli \
          --add-flags "$out/share/steamidra/Main.py" \
          --prefix PYTHONPATH : $out/share/steamidra

        cp $out/share/steamidra/SFF.png $out/share/icons/hicolor/256x256/apps/steamidra.png

        cat > $out/share/applications/steamidra.desktop <<EOF
      [Desktop Entry]
      Name=SteaMidra
      Comment=Advanced Steam game setup and management tool
      Exec=$out/bin/steamidra
      Icon=steamidra
      Type=Application
      Categories=Game;Utility;
      Terminal=false
      StartupNotify=true
      EOF

        runHook postInstall
    '';

    meta = with lib; {
      description = "SteaMidra - Advanced Steam game setup and management tool featuring manifest handling, Lua integrations, and LumaCore deployment";
      homepage = "https://github.com/Midrags/SFF";
      license = licenses.gpl3Only;
      platforms = platforms.linux;
      mainProgram = "steamidra";
    };
  }
