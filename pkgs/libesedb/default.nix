{
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "libesedb";
  version = "20240420";

  src = fetchurl {
    url = "https://github.com/libyal/libesedb/releases/download/${version}/libesedb-experimental-${version}.tar.gz";
    sha256 = "sha256-ByUHQd/4oeofXjjALxuaGuXp+lLQE0AQZzOIQog6W58=";
  };
}
