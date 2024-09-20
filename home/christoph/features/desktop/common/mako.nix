{config, ...}: {
  services.mako = {
    enable = true;
    padding = "10,20";
    anchor = "top-center";
    width = 400;
    height = 150;
    borderSize = 2;
    defaultTimeout = 12000;
    layer = "overlay";
    maxHistory = 50;
    extraConfig = ''
      [mode=do-not-disturb]
      invisible=1
    '';
  };
}
