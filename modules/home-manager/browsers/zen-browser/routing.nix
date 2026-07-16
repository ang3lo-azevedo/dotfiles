{
  pkgs,
  lib,
  ...
}: let
  inherit (import ./spaces/lib.nix) mkId;

  rules = {
    "Space" = [
      "stremio.com"
      "nuvio.tv"
      "torbox.app"
      "elfhosted.com"
    ];
    "Cyber" = [
      "portswigger.net"
      "pwn.college"
      "hackthebox.com"
      "tryhackme.com"
      "ctftime.org"
      "crackmes.one"
      "gtfobins.github.io"
      "revshells.com"
      "cspbypass.com"
      "swisskyrepo.github.io"
    ];
  };

  routing = {
    defaultRouteExternal = "most-recent-space";
    routes = lib.concatLists (lib.mapAttrsToList (
        space: domains:
          map (domain: {
            id = mkId ("route-" + domain);
            reference = domain;
            matchType = "contains";
            openIn = "{${mkId space}}";
          })
          domains
      )
      rules);
  };

  routingJson = pkgs.writeText "zen-space-routing.json" (builtins.toJSON routing);

  # Writes routingJson to the mozLz4 format Zen Browser expects:
  # 8-byte magic + 4-byte LE uncompressed size + LZ4 block-compressed payload.
  writerPy = pkgs.writeText "zen-routing-writer.py" ''
    import ctypes, struct, sys, os

    lib = ctypes.CDLL("${pkgs.lz4.lib}/lib/liblz4.so.1")
    with open("${routingJson}", "rb") as f:
        data = f.read()
    n = len(data)
    bound = lib.LZ4_compressBound(n)
    buf = ctypes.create_string_buffer(bound)
    compressed_size = lib.LZ4_compress_default(data, buf, n, bound)
    out = sys.argv[1]
    with open(out + ".tmp", "wb") as f:
        f.write(b"mozLz40\x00")
        f.write(struct.pack("<I", n))
        f.write(buf.raw[:compressed_size])
    os.replace(out + ".tmp", out)
  '';

  applyScript = pkgs.writeShellScript "zen-space-routing-apply" ''
    ${pkgs.python3}/bin/python3 ${writerPy} "$HOME/.config/zen/ang3lo/zen-space-routing.jsonlz4"
  '';
in {
  home.activation.zenSpaceRouting = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${applyScript}
  '';
}
