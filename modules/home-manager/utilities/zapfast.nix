{inputs, ...}: {
  home.packages = [
    inputs.zapfast.packages.x86_64-linux.zapfast
  ];
}
