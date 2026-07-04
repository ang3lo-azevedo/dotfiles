{
  appimageTools,
  callPackage,
  runCommand,
  runCommandCC,
  writeText,
  writeShellScript,
}: let
  sources = callPackage ../_sources/generated.nix {};
  pname = "harbor";
  inherit (sources.harbor) version src;

  appimageContents = appimageTools.extractType2 {inherit pname version src;};

  # linuxdeploy-plugin-gtk.sh unconditionally sets GDK_BACKEND=x11, which
  # fails on pure Wayland (no XWayland) with EGL_BAD_PARAMETER. Patch the
  # extracted AppImage before wrapping so the hook uses wayland instead.
  patchedContents = runCommand "${pname}-${version}-patched" {} ''
    cp -r ${appimageContents} $out
    chmod -R u+w $out
    sed -i 's/export GDK_BACKEND=x11/export GDK_BACKEND=wayland/' \
      $out/apprun-hooks/linuxdeploy-plugin-gtk.sh
  '';

  # pw_log_topic_register/unregister were removed from pipewire's public ABI
  # in 1.x; Harbor's bundled libraries call them via libjack.so.0 at startup.
  pwShim = runCommandCC "pw-log-topic-shim" {} ''
    mkdir -p $out/lib
    cc -shared -fPIC -o $out/lib/pw_log_topic_shim.so \
      ${writeText "pw-shim.c" ''
      void pw_log_topic_register(void *t) {}
      void pw_log_topic_unregister(void *t) {}
    ''}
  '';

  # WebKit uses libepoxy for EGL dispatch. epoxy_eglGetPlatformDisplay() passes
  # attribs (e.g. EGL_PLATFORM_WAYLAND_USE_EXPLICIT_SYNC) that the system Mesa
  # rejects with EGL_BAD_PARAMETER, causing an abort(). Intercepting the epoxy
  # wrappers via LD_PRELOAD (PLT-based, interceptable) and retrying without
  # attribs lets Mesa pick safe defaults.
  eglShim = runCommandCC "egl-epoxy-shim" {} ''
    mkdir -p $out/lib
    cc -shared -fPIC -ldl -o $out/lib/egl_epoxy_shim.so \
      ${writeText "egl-shim.c" ''
      #include <dlfcn.h>
      #include <stddef.h>
      #include <stdint.h>
      typedef void *EGLDisplay;
      typedef unsigned int EGLenum;
      typedef intptr_t EGLAttrib;
      typedef int EGLint;
      typedef EGLDisplay (*pfn_t)(EGLenum, void *, const EGLAttrib *);
      typedef EGLDisplay (*pfn_ext_t)(EGLenum, void *, const EGLint *);

      EGLDisplay epoxy_eglGetPlatformDisplay(EGLenum platform, void *native,
                                             const EGLAttrib *attribs) {
        static pfn_t real;
        if (!real) real = (pfn_t)dlsym(RTLD_NEXT, "epoxy_eglGetPlatformDisplay");
        if (!real) return (EGLDisplay)0;
        EGLDisplay d = real(platform, native, attribs);
        if (!d && attribs) d = real(platform, native, NULL);
        return d;
      }

      EGLDisplay epoxy_eglGetPlatformDisplayEXT(EGLenum platform, void *native,
                                                const EGLint *attribs) {
        static pfn_ext_t real;
        if (!real) real = (pfn_ext_t)dlsym(RTLD_NEXT, "epoxy_eglGetPlatformDisplayEXT");
        if (!real) return (EGLDisplay)0;
        EGLDisplay d = real(platform, native, attribs);
        if (!d && attribs) d = real(platform, native, NULL);
        return d;
      }
    ''}
  '';

  wrapper = writeShellScript "harbor" ''
    export LD_PRELOAD="${pwShim}/lib/pw_log_topic_shim.so:${eglShim}/lib/egl_epoxy_shim.so''${LD_PRELOAD:+:$LD_PRELOAD}"
    exec "$(dirname "$0")/.harbor-unwrapped" "$@"
  '';
in
  appimageTools.wrapAppImage {
    inherit pname version;
    src = patchedContents;
    extraPkgs = pkgs: [pkgs.webkitgtk_4_1];

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/Harbor.png \
        $out/share/icons/hicolor/256x256/apps/harbor.png
      install -m 444 -D ${appimageContents}/usr/share/applications/Harbor.desktop \
        $out/share/applications/harbor.desktop
      sed -i 's|^Exec=.*|Exec=harbor %u|' $out/share/applications/harbor.desktop

      mv $out/bin/harbor $out/bin/.harbor-unwrapped
      cp ${wrapper} $out/bin/harbor
      chmod +x $out/bin/harbor
    '';

    meta = {
      description = "Custom Stremio client built for adventure";
      homepage = "https://github.com/harborstremio/harbor";
    };
  }
