_: prev: let
  mkXpi = {
    guid,
    pname,
    version,
    url,
    sha256,
  }:
    prev.stdenv.mkDerivation {
      inherit pname version;
      src = prev.fetchurl {inherit url sha256;};
      preferLocalBuild = true;
      allowSubstitutes = true;
      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${guid}.xpi"
      '';
      meta = {};
    };
in {
  firefoxAddons =
    prev.firefoxAddons
    // {
      wappalyzer = mkXpi {
        guid = "wappalyzer@crunchlabz.com";
        pname = "wappalyzer";
        version = "6.12.4";
        url = "https://addons.mozilla.org/firefox/downloads/file/4887810/wappalyzer-6.12.4.xpi";
        sha256 = "1yppiiw539d5k4wcgkw9rnxhdpqnp0z2x9wkrrqky5dwylkam60i";
      };
      motrix-next-extension = mkXpi {
        guid = "motrix-next-extension@aninsomniacy.dev";
        pname = "motrix-next-extension";
        version = "1.3.2";
        url = "https://addons.mozilla.org/firefox/downloads/file/4851145/motrix_next_extension-1.3.2.xpi";
        sha256 = "0dw87680icz598pxp137wj6aaczyhnly5mlfs2045b42ciw40crs";
      };
    };
}
