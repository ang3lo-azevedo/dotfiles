{inputs, ...}: {
  imports = [inputs.gaze.nixosModules.default];

  services.gaze.enable = true;

  security.pam.services = {
    login.gaze.enable = true;
    greetd.gaze.enable = true;
    swaylock.gaze.enable = true;
  };
}
