{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # services.avahi = {
  #   enable = true;
  #   publish = {
  #     enable = true;
  #     userServices = true;
  #   };
  # };

  services.wivrn = {
    enable = true;
    openFirewall = true;
    package = inputs.nixpkgs-xr.packages.${pkgs.stdenv.hostPlatform.system}.wivrn;

    # Run WiVRn as a systemd service on startup
    autoStart = true;

    # Whether to enable high priority capability for asynchronous reprojection
    #highPriority = true;

    # Configuration with xrizer multilib support for OpenVR compatibility
    /*
       config = {
      enable = true;
      json = {
        openvr-compat-path = "${xrizer-multilib}/lib/xrizer";
      };
    };
    */

    # To increase the overhead of the compositor timewarp
    /*
       package = pkgs.wivrn.overrideAttrs (oldAttrs: {
      preFixup = ''
        export U_PACING_COMP_MIN_TIME_MS=8
      '';
    });
    */

    # If you're running this with an nVidia GPU and want to use GPU Encoding (and don't otherwise have CUDA enabled system wide), you need to override the cudaSupport variable.
    #package = (pkgs.wivrn.override { cudaSupport = true; });

    # You should use the default configuration (which is no configuration), as that works the best out of the box.
    # However, if you need to configure something see https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md for configuration options and https://mynixos.com/nixpkgs/option/services.wivrn.config.json for an example configuration.
  };

  # # `services.wivrn.defaultRuntime` was removed upstream; only set WiVRn as
  # # system OpenXR runtime when the WiVRn service itself is enabled.
  # environment.etc = lib.mkIf config.services.wivrn.enable {
  #   "xdg/openxr/1/active_runtime.json".source =
  #     "${config.services.wivrn.package}/share/openxr/1/openxr_wivrn.json";
  # };

  programs.steam = {
    package = pkgs.steam.override {
      extraProfile = ''
        # Allows Monado/WiVRn to be used
        export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
        # Fixes timezones on VRChat
        unset TZ
      '';
    };
  };

  # xdg.configFile."openvr/openvrpaths.vrpath".text = let
  #   steam = "${config.xdg.dataHome}/Steam";
  # in builtins.toJSON {
  #   version = 1;
  #   jsonid = "vrpathreg";

  #   external_drivers = null;
  #   config = [ "${steam}/config" ];

  #   log = [ "${steam}/logs" ];

  #   runtime = [
  #     "${pkgs.xrizer}/lib/xrizer"
  #     # OR
  #     #"${pkgs.opencomposite}/lib/opencomposite"
  #   ];
  # };

  /*
     home-manager.users.ang3lo = {
    xdg.configFile."openxr/1/active_runtime.i686.json".source =
      "${wivrn-server-lib}/share/openxr/1/openxr_wivrn.json";
  };
  */
}
