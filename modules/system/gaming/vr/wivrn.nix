{ pkgs, inputs, lib, ... }:
let
  # To fix https://github.com/nix-community/nixpkgs-xr/issues/569
  xrizer-multilib =
    let
      pkg = inputs.nixpkgs-xr.packages.${pkgs.stdenv.hostPlatform.system}.xrizer;
    in
    pkgs.symlinkJoin {
      name = "xrizer-multilib";
      paths =
        let
          attrs = {
            postInstall = ''
              mkdir -p $out/lib/xrizer/$platformPath
              mv "$out/lib/libxrizer.so" "$out/lib/xrizer/$platformPath/vrclient.so"
            '';
          };
        in
        [
          (pkg.overrideAttrs attrs)
          ((pkgs.pkgsi686Linux.callPackage pkg.override { }).overrideAttrs attrs)
        ];
    };

  wivrn-server-lib =
    let
      p = pkgs.pkgsi686Linux;
      pkg = pkgs.pkgsi686Linux.wivrn.overrideAttrs (prev: {
        pname = "wivrn-server-lib";
        nativeBuildInputs = with p; [
          cmake
          git
          glslang
          pkg-config
          python3
        ];

        buildInputs = with p; [
          boost
          eigen
          glm
          libdrm
          nlohmann_json
          openxr-loader
          udev
          vulkan-headers
          vulkan-loader
        ];

        desktopItems = [ ];

        cmakeFlags = [
          (lib.cmakeBool "WIVRN_BUILD_SERVER" false)
          (lib.cmakeBool "WIVRN_BUILD_WIVRNCTL" false)
          (lib.cmakeBool "WIVRN_BUILD_SERVER_LIBRARY" true)
          (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
          (lib.cmakeFeature "WIVRN_OPENXR_MANIFEST_TYPE" "absolute")
          (lib.cmakeFeature "GIT_DESC" "v${prev.version}")
          (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MONADO" "${prev.monado}")
        ];

        preFixup = "";
      });
    in
    pkg;
in
{
  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  services.wivrn = {
    enable = true;
    openFirewall = true;

    # Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
    # will automatically read this and work with WiVRn (Note: This does not currently
    # apply for games run in Valve's Proton)
    defaultRuntime = true;

    # Run WiVRn as a systemd service on startup
    autoStart = true;

    # Whether to enable high priority capability for asynchronous reprojection
    highPriority = true;

    # Configuration with xrizer multilib support for OpenVR compatibility
    config = {
      enable = true;
      json = {
        openvr-compat-path = "${xrizer-multilib}/lib/xrizer";
      };
    };

    # To increase the overhead of the compositor timewarp
    /* package = pkgs.wivrn.overrideAttrs (oldAttrs: {
      preFixup = ''
        export U_PACING_COMP_MIN_TIME_MS=8
      '';
    }); */

    # If you're running this with an nVidia GPU and want to use GPU Encoding (and don't otherwise have CUDA enabled system wide), you need to override the cudaSupport variable.
    #package = (pkgs.wivrn.override { cudaSupport = true; });

    # You should use the default configuration (which is no configuration), as that works the best out of the box.
    # However, if you need to configure something see https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md for configuration options and https://mynixos.com/nixpkgs/option/services.wivrn.config.json for an example configuration.
  };

  programs.steam = {
    package = pkgs.steam.override {
      extraProfile = ''
        # Allows Monado and WiVRn to be used
        export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
      '';
    };
  };
  
  home-manager.users.ang3lo = {
    xdg.configFile."openxr/1/active_runtime.i686.json".source =
      "${wivrn-server-lib}/share/openxr/1/openxr_wivrn.json";
  };
}