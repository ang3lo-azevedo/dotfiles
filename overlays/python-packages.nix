final: prev: {
  python3Packages = prev.python3Packages.overrideScope (pyFinal: pyPrev: {
    # pycparser 3.00 made CLexer.filename a read-only property; angr's sim_type.py
    # still assigns to it directly (`self.clex.filename = filename`), which crashes
    # on import. Pin the last 2.x release until angr updates for pycparser 3.
    # TODO: Remove once angr supports pycparser>=3.
    pycparser = pyPrev.pycparser.overrideAttrs (_: {
      version = "2.22";
      src = final.fetchFromGitHub {
        owner = "eliben";
        repo = "pycparser";
        tag = "release_v2.22";
        hash = "sha256-RY0xQ4Mj8IfYAcypZQx4lDBmcgzYqtM4ARm9NSccBgA=";
      };
    });

    # angr ships a real Rust extension (native/angr, built via setuptools-rust) that
    # nixpkgs' build-system = [ setuptools ] doesn't account for.
    # TODO: Remove when nixpkgs adds setuptools-rust/cargo to angr's build inputs upstream
    #
    # angr also pins archinfo/cle/pyvex to its own exact version (both as a
    # [build-system] requirement and as a runtime dependency), but nixpkgs carries
    # older releases of those siblings than of angr itself. pythonRelaxDeps only
    # patches the built wheel's METADATA (postBuild), too late for the pyproject.toml
    # build-system pin that's checked before the build starts, so strip the pins
    # from pyproject.toml directly; the angr suite's lockstep releases stay
    # API-compatible across these minor gaps.
    # TODO: Remove once nixpkgs syncs archinfo/cle/pyvex to angr's version.
    angr = pyPrev.angr.overridePythonAttrs (old: {
      postPatch =
        (old.postPatch or "")
        + ''
          sed -i -E 's/(archinfo|cle|pyvex)==[0-9.]+/\1/' pyproject.toml
        '';
      cargoDeps = final.rustPlatform.fetchCargoVendor {
        inherit (old) src;
        name = "angr-${old.version}";
        hash = "sha256-HnvNJW7Q3bWr2VxtM+Ux0gyDC5P5QlHjZwooyOkGaow=";
      };
      nativeBuildInputs =
        (old.nativeBuildInputs or [])
        ++ [
          pyFinal.setuptools-rust
          final.rustPlatform.cargoSetupHook
          final.rustc
          final.cargo
        ];
      # v9.2.193's wheel requires these but nixpkgs' `dependencies` list hasn't caught up yet.
      dependencies =
        (old.dependencies or [])
        ++ [
          pyFinal.lmdb
          pyFinal.msgspec
          pyFinal.pypcode
        ];
    });

    # TODO: remove once fs 2.4.x migrates from pkg_resources to importlib.metadata upstream.
    # Two pkg_resources issues, both because setuptools is not in the build sandbox:
    # (1) fs/__init__.py (and opener/__init__.py) call declare_namespace -- strip those
    #     (Python 3.3+ native namespace packages, PEP 420, make this a no-op).
    # (2) fs/opener/registry.py uses pkg_resources.iter_entry_points at module level;
    #     migrate that call to importlib.metadata.entry_points (stdlib since Python 3.9)
    #     so import fs never requires setuptools. Tests skip (doInstallCheck=false) because
    #     test_opener.py still imports pkg_resources directly.
    fs = pyPrev.fs.overrideAttrs (old: {
      postPatch =
        (old.postPatch or "")
        + ''
                    find . -name '__init__.py' -exec sed -i '/pkg_resources.*declare_namespace/d' {} +
                    python3 - <<'PYEOF'
          import re
          with open('fs/opener/registry.py') as f:
              src = f.read()
          src = src.replace('import pkg_resources',
              'from importlib.metadata import entry_points as _metadata_entry_points')
          def _repl(m):
              args = [a.strip() for a in m.group(1).split(',', 1)]
              if len(args) == 1:
                  return 'iter(_metadata_entry_points(group={}))'.format(args[0])
              return 'iter(_metadata_entry_points(group={}, name={}))'.format(args[0], args[1])
          src = re.sub(r'pkg_resources\.iter_entry_points\(([^)]+)\)', _repl, src)
          with open('fs/opener/registry.py', 'w') as f:
              f.write(src)
          PYEOF
        '';
      doInstallCheck = false;
      propagatedBuildInputs = (old.propagatedBuildInputs or []) ++ [pyPrev.setuptools];
    });

    # click-threading's test suite imports docs/conf.py which uses pkg_resources
    # (setuptools), not declared as a dependency. Broken under Python 3.14.
    # vdirsyncer → click-threading; remove once fixed upstream.
    click-threading = pyPrev.click-threading.overridePythonAttrs (_: {doCheck = false;});

    # test_build_linkcheck.py / test_anchors_ignored spins up a local HTTP server
    # which times out in the Nix sandbox (no loopback networking).
    # TODO: Remove when nixpkgs disables network-dependent tests upstream.
    sphinx = pyPrev.sphinx.overridePythonAttrs (old: {
      disabledTests =
        (old.disabledTests or [])
        ++ [
          "test_anchors_ignored"
        ];
    });

    i3ipc = pyPrev.i3ipc.overridePythonAttrs (_: {doCheck = false;});
  });
}
