{
  lib,
  pkgs,
  ...
}: {
  boot = {
    # lanzaboote replaces systemd-boot and adds Secure Boot signing.
    # initrd.systemd must be true for lanzaboote to work (it patches the initrd).
    initrd.systemd.enable = true;
    lanzaboote = {
      enable = true;
      # Keys are stored on /persist so they survive the impermanence wipe.
      pkiBundle = "/var/lib/sbctl";
      autoGenerateKeys.enable = true;
      autoEnrollKeys = {
        enable = true;
        # Reboot automatically after enrolling keys so the new policy takes effect.
        autoReboot = true;
      };
      measuredBoot = {
        enable = true;
        # PCR 0: firmware, PCR 4: boot loader, PCR 7: Secure Boot state.
        # These three cover the full pre-OS trust chain without tying to kernel (PCR 9).
        pcrs = [0 4 7];
      };
    };
    loader.systemd-boot = {
      # lanzaboote conflicts with systemd-boot; mkForce overrides the default true.
      enable = lib.mkForce false;
      configurationLimit = lib.mkForce 8;
    };
  };

  environment.systemPackages = [
    pkgs.sbctl
    # systemd-pcrlock lives in systemd's lib dir, not on PATH; wrap it so it is usable as a command.
    (pkgs.writeShellScriptBin "systemd-pcrlock" "exec ${pkgs.systemd}/lib/systemd/systemd-pcrlock \"$@\"")
  ];
}
