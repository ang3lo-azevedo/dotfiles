{pkgs, ...}: {
  my.browsers.extensions.translate = {
    firefoxPackage = pkgs.firefoxAddons.traduzir-paginas-web;
    chromeId = "mifafbjbnhpmhfkpeepbkbkjdlldenlm";
    chromiumUrl = "https://github.com/FilipePS/Traduzir-paginas-web/releases/download/v10.2.1.0/TWP_10.2.1.0_Chromium_MV2_deprecated.crx";
    chromiumHash = "0cnsnyv11vnm6g2hfld1j9kyf8r1yiyzs27z0hc4qhf75bp9sbmv";
  };
}
