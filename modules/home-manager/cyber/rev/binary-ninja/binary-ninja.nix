{pkgs, ...}: {
  home.file.".binaryninja/settings.json" = {
    text = builtins.toJSON {
      "python.binaryOverride" = "${pkgs.python312}/bin/python3.12";
      "python.interpreter" = "${pkgs.python312}/lib/libpython3.12.so";
    };
  };

  home.packages = [
    pkgs.binary-ninja
  ];
}
