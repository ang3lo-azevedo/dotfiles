{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

let
  fhsEnv = pkgs.buildFHSEnv {
    name = "android-build-env";
    
    targetPkgs = pkgs: with pkgs; [
      # Version control
      git
      gitRepo
      gnupg

      # Python
      python3
      python312Packages.pip

      # Build tools
      curl
      procps
      openssl
      gnumake
      nettools
      jdk17
      schedtool
      util-linux
      m4
      gperf
      perl
      libxml2
      zip
      unzip
      bison
      flex
      lzop
      bc
      rsync
      file
      which
      coreutils

      # Android tools
      android-tools

      # Build acceleration
      ccache
      ninja
      
      # Additional libraries
      zlib
      ncurses5
      
      # FIX: Add legacy libcrypt for prebuilt Android tools
      libxcrypt-legacy
    ];

    multiPkgs = pkgs: with pkgs; [
      zlib
      ncurses5
      # FIX: Ensure 32-bit/64-bit compatibility for libcrypt if needed
      libxcrypt-legacy 

      freetype
      fontconfig
    ];

    runScript = "bash";
    
    profile = ''
      export ALLOW_NINJA_ENV=true
      export USE_CCACHE=1
      export CCACHE_EXEC=$(which ccache)
      export ANDROID_JAVA_HOME=${pkgs.jdk17.home}
      #export LD_LIBRARY_PATH=/usr/lib:/usr/lib32
      
      # Use a writable git config location
      mkdir -p "$PWD/.build-config/git"
      export GIT_CONFIG_GLOBAL="$PWD/.build-config/git/config"
      export GIT_CONFIG_SYSTEM=/dev/null
      
      # Initialize git config if it doesn't exist
      if [ ! -f "$GIT_CONFIG_GLOBAL" ]; then
        git config --global user.name "Angelo Azevedo" 2>/dev/null || true
        git config --global user.email "ang3lo@azevedos.eu.org" 2>/dev/null || true
        git config --global color.ui auto 2>/dev/null || true
      fi
    '';
  };
in
pkgs.mkShell {
  name = "android-env";
  nativeBuildInputs = [ fhsEnv ];
  shellHook = ''
    exec android-build-env
  '';
}