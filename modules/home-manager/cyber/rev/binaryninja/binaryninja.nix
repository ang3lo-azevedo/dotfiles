{pkgs, ...}: {
  home.file.".binaryninja/settings.json" = {
    text = builtins.toJSON {
      "python.binaryOverride" = pkgs.python3.interpreter;
      "python.interpreter" = "${pkgs.python3}/lib/lib${pkgs.python3.libPrefix}.so";
    };
  };

  home.packages = [
    pkgs.binaryninja-personal
  ];
}
