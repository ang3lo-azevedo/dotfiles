{pkgs, ...}: {
  imports = [
    ./options.nix
    ./extensions
    ./zen-browser
    ./helium-browser
  ];

  my.browsers.insecureOriginsAsSecure = ["http://pkappa.ecsc.pt"];

  home.packages = with pkgs; [
    (ungoogled-chromium.override {
      commandLineArgs = "--enable-features=WebRTCPipeWireCapturer";
    })
  ];
}
