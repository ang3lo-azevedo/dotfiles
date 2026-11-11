{pkgs, ...}: {
  # AMD-tuned Nintendo Switch and Switch 2 emulator (CheezerWheezer's CheezyEmu):
  # FSR 4, AMD frame generation, and saved compiled shaders (VK_KHR_pipeline_binary).
  # See pkgs/ang3lo-nur/pkgs/cheezyemu.
  home.packages = [pkgs.cheezyemu];
}
