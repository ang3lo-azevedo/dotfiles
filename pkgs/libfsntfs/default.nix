{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libfsntfs";
  version = "20240501";

  src = fetchurl {
    url = "https://github.com/libyal/libfsntfs/releases/download/${version}/libfsntfs-experimental-${version}.tar.gz";
    sha256 = "sha256-xFeU2L61iGFrR9MmkU8oFje2K5WtFHRVk70jblIgqUk=";
  };
}
