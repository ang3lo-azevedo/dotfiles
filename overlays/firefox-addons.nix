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
    (prev.firefoxAddons or {})
    // {
      equicord-web = mkXpi {
        guid = "firefox@equicord.org";
        pname = "equicord-web";
        version = "1.15.13.0";
        url = "https://addons.mozilla.org/firefox/downloads/file/5162914/equicord_web-1.15.13.0.xpi";
        sha256 = "8b754bff4a4e95fef537ceb7afaf286381ba718265db18d2c5c22c3ab3e40c9f";
      };
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
      libredirect = mkXpi {
        guid = "7esoorv3@alefvanoon.anonaddy.me";
        pname = "libredirect";
        version = "3.3.0";
        url = "https://addons.mozilla.org/firefox/downloads/file/4734268/libredirect-3.3.0.xpi";
        sha256 = "0zc78ys9vy30bly9z6dkc7cqapixghwkiyqf5x9bhvicwnd7748w";
      };
      european-portuguese-spellcheck = mkXpi {
        guid = "pt-PT@dictionaries.addons.mozilla.org";
        pname = "european-portuguese-spellcheck";
        version = "19.2.3.4resigned1";
        url = "https://addons.mozilla.org/firefox/downloads/file/4270174/european_portuguese_spellcheck-19.2.3.4resigned1.xpi";
        sha256 = "sha256-0mL/BD9qpuAbUw7VEx70Yr2Kw2rBG+JaEvHW9n+jEaU=";
      };
    };
}
