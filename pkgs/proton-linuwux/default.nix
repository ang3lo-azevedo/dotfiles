{
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation {
  pname = "proton-cachyos-linuwux";
  version = "11.0.20260702";

  src = fetchurl {
    url = "https://buzzheavier.com/j16xmusmpmsr/download?t=MTc4NDE0MjA1MTcwMQ.TBiSF-f-H7zy5M11ycea1TUNbdJLh6zc67xAfbnN9bs&alt=true";
    hash = "sha256-YXMBv4a7G9HTarGmJwQlGR6LU9dk1hn+Od9Gk8h1RJ4=";
    curlOptsList = [
      "--user-agent"
      "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36"
    ];
  };

  buildCommand = ''
    mkdir -p $out/bin $out/share
    tar -C $out/bin --strip=1 -x -f $src
    sed -i -r 's|"\w+_[0-9]+\.[0-9]+_[0-9]+-LinUwUx.*"|"Proton-CachyOS-LinUwUx"|' $out/bin/compatibilitytool.vdf
  '';

  meta = {
    homepage = "https://github.com/CachyOS/proton-cachyos";
    description = "Proton-CachyOS with LinUwUx patch — syscall/CPUID spoofing for game compatibility";
    license = {
      fullName = "BSD 3-Clause";
    };
    platforms = ["x86_64-linux"];
  };
}
