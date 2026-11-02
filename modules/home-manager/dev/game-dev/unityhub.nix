{pkgs, ...}: {
  home.packages = with pkgs; [
    (unityhub.override {
      # UnityShaderCompiler (used for VR/shader builds) is dynamically linked
      # against libtinfo.so.6, which is not part of the FHS env by default.
      # Providing ncurses makes libtinfo available inside the FHS namespace.
      extraLibs = p: [p.ncurses];
    })
  ];
}
