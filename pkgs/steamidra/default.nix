{
  lib,
  stdenv,
  makeWrapper,
  python3,
  callPackage,
  p7zip,
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
      steam
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
      platformdirs
      pathvalidate
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

                        cat > sff_data_dir_patch.py <<'PYEOF'
      import re
      import sys
      p = sys.argv[1]
      with open(p) as f:
          content = f.read()
      pat = r'def sff_data_dir\(\) -> Path:.*?(?=\n    def |\ndef |\n\n\n)'
      repl = """def sff_data_dir() -> Path:
          env_dir = os.environ.get("STEAMIDRA_DATA_DIR")
          if env_dir:
              return Path(env_dir)
          import platformdirs
          return Path(platformdirs.user_data_dir("steamidra", ensure_exists=True))
      """
      new = re.sub(pat, repl, content, count=1, flags=re.DOTALL)
      with open(p, 'w') as f:
          f.write(new)
      PYEOF
                        ${pythonEnv}/bin/python sff_data_dir_patch.py $out/share/steamidra/sff/core/utils.py

                        cat > sff_provider_patch.py <<'PYEOF'
      import re
      import sys
      p = sys.argv[1]
      with open(p) as f:
          content = f.read()
      pat = r'def cache_dir\(\) -> Path:.*?(?=\n    return d|\n\n\n|\n\ndef )(\n    return d)?'
      repl = """def cache_dir() -> Path:
          from sff.core.utils import sff_data_dir
          d = sff_data_dir() / "provider_cache"
          d.mkdir(parents=True, exist_ok=True)
          return d
      """
      new = re.sub(pat, repl, content, count=1, flags=re.DOTALL)
      with open(p, 'w') as f:
          f.write(new)
      PYEOF
                        ${pythonEnv}/bin/python sff_provider_patch.py $out/share/steamidra/sff/lua/provider.py

                        makeWrapper ${pythonEnv}/bin/python $out/bin/steamidra \
                          --add-flags "$out/share/steamidra/Main_gui.py" \
                          --prefix PYTHONPATH : $out/share/steamidra \
                          --prefix PATH : ${lib.makeBinPath [p7zip]} \
                          --set PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION python

                        makeWrapper ${pythonEnv}/bin/python $out/bin/steamidra-cli \
                          --add-flags "$out/share/steamidra/Main.py" \
                          --prefix PYTHONPATH : $out/share/steamidra \
                          --prefix PATH : ${lib.makeBinPath [p7zip]} \
                          --set PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION python

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
