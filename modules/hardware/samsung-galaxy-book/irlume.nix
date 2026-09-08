{inputs, ...}: {
  imports = [inputs.irlume.nixosModules.irlume];

  services.irlume = {
    enable = true;
    rgbDevice = "/dev/video0";
    irDevice = "/dev/video2";

    pam.services = {
      login = {};
      swaylock = {};
      sudo.profile = "lock";
      "polkit-1".profile = "lock";
    };
  };
}
