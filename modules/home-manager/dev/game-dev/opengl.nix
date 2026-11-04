{pkgs, ...}: {
  # C/C++ OpenGL toolchain for the CGJ (Computação Gráfica e Jogos) labs.
  # The authoritative per-lab build environment is each lab's flake devShell;
  # these are installed user-wide so editor tooling (clangd, cmake integration)
  # and ad-hoc g++/pkg-config invocations resolve the headers outside a shell.
  home.packages = with pkgs; [
    gcc
    cmake
    pkg-config
    glew
    glfw
    glm
    libGL
  ];
}
